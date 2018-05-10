
#import "RNHkit.h"
#import "TypesAndPermissions.h"
#import "HKMethods.h"

@implementation RNHkit
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE(hkit);

RCT_REMAP_METHOD(isAvailable, isAvailable:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL isAvailable = NO;
    if ([HKHealthStore isHealthDataAvailable]) {
        isAvailable = YES;
    }
    resolve(@(isAvailable));
    if (isAvailable == nil) {
        reject(@"isAvailable fail", @"isAvailable failure", nil);
    }
}

RCT_REMAP_METHOD(requestForPermission:(NSDictionary *)input, requestForPermission:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    if (!self.hkStore) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    if (![HKHealthStore isHealthDataAvailable]) {
        reject(@"init fail", @"permissions must be provided in the initialization options", nil);
        return;
    } else {
        NSDictionary *permissions = [input objectForKey:@"permissions"];
        if (permissions == nil) {
            reject(@"init fail", @"permissions must be provided in the initialization options", nil);
            return;
        }
        NSSet *writeDataTypes = [self getReadPermsFromOptions:[permissions objectForKey:@"read"]];
        NSSet *readDataTypes = [self getWritePermsFromOptions:[permissions objectForKey:@"write"]];
        // make sure at least 1 read or write permission is provided
        if(!writeDataTypes && !readDataTypes){
            reject(@"init fail", @"permissions must be provided in the initialization options", nil);
            return;
        }
        [self.hkStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSString *errMsg = [NSString stringWithFormat:@"Error with HealthKit authorization: %@", error];
                reject(@"init fail", errMsg, error);
                return;
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    resolve(@true);
                });
            }
        }];
    }
}


// Characteristic
RCT_REMAP_METHOD(getBiologicalSex, getBiologicalSexWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSError *error;
    HKBiologicalSexObject *bioSex = [self.hkStore biologicalSexWithError:&error];
    NSString *value = nil;
    
    switch (bioSex.biologicalSex) {
        case HKBiologicalSexNotSet:     value = @"unknown"; break;
        case HKBiologicalSexFemale:     value = @"female";  break;
        case HKBiologicalSexMale:       value = @"male";    break;
        case HKBiologicalSexOther:      value = @"other";   break;
    }
    
    if(value == nil) {
        NSLog(@"error getting biological sex: %@", error);
        reject(@"no_datas", @"There were no datas", error);
        return;
    }
    resolve(value);
}

RCT_REMAP_METHOD(getDateOfBirth, getDateOfBirthWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSError *error;
    NSDateComponents *dateOfBirth = [self.hkStore dateOfBirthComponentsWithError:&error];
    
    if(error != nil || dateOfBirth == nil) {
        NSLog(@"error getting date of birth: %@", error);
        reject(@"no_datas", @"There were no datas", error);
        return;
    }
    
    NSString *value = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)dateOfBirth.year, (long)dateOfBirth.month, (long)dateOfBirth.day];
    resolve(value);
}

RCT_REMAP_METHOD(getBloodType, getBloodTypeWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSError *error;
    HKBloodTypeObject *bloodObject = [self.hkStore bloodTypeWithError:&error];
    
    NSString *value = nil;
    switch (bloodObject.bloodType) {
        case HKBloodTypeNotSet:     value = @"NotSet";  break;
        case HKBloodTypeAPositive:  value = @"A+";      break;
        case HKBloodTypeANegative:  value = @"A-";      break;
        case HKBloodTypeBPositive:  value = @"B+";      break;
        case HKBloodTypeBNegative:  value = @"B-";      break;
        case HKBloodTypeABPositive: value = @"AB+";     break;
        case HKBloodTypeABNegative: value = @"AB-";     break;
        case HKBloodTypeOPositive:  value = @"O+";      break;
        case HKBloodTypeONegative:  value = @"O-";      break;
    }
    if(value == nil) {
        NSLog(@"error getting blood type: %@", error);
        reject(@"no_datas", @"error getting blood type", error);
    } else {
        resolve(value);
    }
}

/*
 FitzpatrickSkin
 TypeI 햇볕에 항상 쉽게 화상을 입히고 볕에 타지 않는 하얀 피부.
 TypeII 쉽게 화상을 입으며 최소한의 탄력있는 흰색 피부.
 TypeIII 적당히 화상을 입히고 균일하게 태우는 밝은 갈색 피부.
 TypeIV Beige-olive, 가볍게 태닝 한 피부. 최소한의 화상과 적당히 탄.
 TypeV 거의 화상을 입지 않고 무미건조 한 갈색 피부.
 TypeVI 결코 화상을 입지 않고 검은 색 피부에 검은 갈색의 피부.
 */
RCT_REMAP_METHOD(getFitzpatrickSkin, getFitzpatrickSkinWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSError *error;
    HKFitzpatrickSkinTypeObject *skin = [self.hkStore fitzpatrickSkinTypeWithError:&error];
    NSString *value = nil;
    switch (skin.skinType) {
        case HKFitzpatrickSkinTypeNotSet:   value = @"NotSet";      break;
        case HKFitzpatrickSkinTypeI:        value = @"White";       break;
        case HKFitzpatrickSkinTypeII:       value = @"Beige";       break;
        case HKFitzpatrickSkinTypeIII:      value = @"LightBrown";  break;
        case HKFitzpatrickSkinTypeIV:       value = @"MediumBrown"; break;
        case HKFitzpatrickSkinTypeV:        value = @"DarkBrown";   break;
        case HKFitzpatrickSkinTypeVI:       value = @"Black";       break;
    }
    if(value == nil) {
        NSLog(@"error getting FitzpatrickSkin: %@", error);
        reject(@"no_datas", @"There were no datas", error);
        return;
    } else {
        resolve(value);
    }
}

RCT_REMAP_METHOD(getWheelchairUse, getWheelchairUseWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSError *error;
    HKWheelchairUseObject *object = [self.hkStore wheelchairUseWithError:&error];
    NSString *value = nil;
    switch (object.wheelchairUse) {
        case HKWheelchairUseNotSet:
            value = @"NotSet";
            break;
        case HKWheelchairUseNo:
            value = @"No";
            break;
        case HKWheelchairUseYes:
            value = @"Yes";
            break;
    }
    if(value == nil) {
        NSLog(@"error getting WheelchairUse: %@", error);
        reject(@"no_datas", @"There were no datas", error);
        return;
    } else {
        resolve(value);
    }
}

RCT_REMAP_METHOD(getBloodGlucoseSamples:(NSDictionary *)input, getBloodGlucoseSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    return [self getBloodGlucoseSamples:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getHeartRateSamples:(NSDictionary *)input, getHeartRateSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getHeartRateSamples:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getBodyTemperatureSamples:(NSDictionary *)input, getBodyTemperatureSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getBodyTemperatureSamples:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getBloodPressureSamples:(NSDictionary *)input, getBloodPressureSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getBloodPressureSamples:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getRespiratoryRateSamples:(NSDictionary *)input, getRespiratoryRateSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getRespiratoryRateSamples:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getLatestWeight:(NSDictionary *)input, getLatestWeight:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getLatestWeight:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getWeightSamples:(NSDictionary *)input, getWeightSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getWeightSamples:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getLatestBodyMassIndex:(NSDictionary *)input, getLatestBodyMassIndex:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getLatestBodyMassIndex:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getLatestHeight:(NSDictionary *)input, getLatestHeight:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getLatestHeight:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getHeightSamples:(NSDictionary *)input, getHeightSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self  getHeightSamples:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getLatestBodyFatPercentage:(NSDictionary *)input, getLatestBodyFatPercentage:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getLatestBodyFatPercentage:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getLatestLeanBodyMass:(NSDictionary *)input, getLatestLeanBodyMass:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getLatestLeanBodyMass:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getStepCountOnDay:(NSDictionary *)input, getStepCountOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getStepCountOnDay:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getDailyStepSamples:(NSDictionary *)input, getDailyStepSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getDailyStepSamples:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getDistanceWalkingRunningOnDay:(NSDictionary *)input, getDistanceWalkingRunningOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getDistanceWalkingRunningOnDay:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getDistanceCyclingOnDay:(NSDictionary *)input, getDistanceCyclingOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getDistanceCyclingOnDay:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getFlightsClimbedOnDay:(NSDictionary *)input, getFlightsClimbedOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getFlightsClimbedOnDay:input Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(getSleepSamples:(NSDictionary *)input, getSleepSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    return [self getSleepSamples:input Resolver:resolve rejecter:reject];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end

/*
 
 RCT_REMAP_METHOD(initHealthKit:(NSDictionary *)input, initHealthKit:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
 {
 self.hkStore = [[HKHealthStore alloc] init];
 
 if ([HKHealthStore isHealthDataAvailable]) {
 NSSet *writeDataTypes;
 NSSet *readDataTypes;
 
 // get permissions from input object provided by JS options argument
 NSDictionary* permissions =[input objectForKey:@"permissions"];
 if(permissions != nil){
 NSArray* readPermsArray = [permissions objectForKey:@"read"];
 NSArray* writePermsArray = [permissions objectForKey:@"write"];
 NSSet* readPerms = [self getReadPermsFromOptions:readPermsArray];
 NSSet* writePerms = [self getWritePermsFromOptions:writePermsArray];
 
 if(readPerms != nil) {
 readDataTypes = readPerms;
 }
 if(writePerms != nil) {
 writeDataTypes = writePerms;
 }
 } else {
 reject(@"init fail", @"permissions must be provided in the initialization options", nil);
 return;
 }
 
 // make sure at least 1 read or write permission is provided
 if(!writeDataTypes && !readDataTypes){
 reject(@"init fail", @"permissions must be provided in the initialization options", nil);
 return;
 }
 
 [self.hkStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
 if (!success) {
 NSString *errMsg = [NSString stringWithFormat:@"Error with HealthKit authorization: %@", error];
 reject(@"init fail", errMsg, error);
 return;
 } else {
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 resolve(@true);
 });
 }
 }];
 } else {
 reject(@"init fail", @"permissions must be provided in the initialization options", nil);
 }
 }
 
 */
