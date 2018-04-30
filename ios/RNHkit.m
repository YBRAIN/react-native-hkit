
#import "RNHkit.h"
#import "TypesAndPermissions.h"
#import "HKMethods.h"

@implementation RNHkit
@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE(RNHkit);

RCT_EXPORT_METHOD(isAvailable:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    BOOL isAvailable = NO;
    if ([HKHealthStore isHealthDataAvailable]) {
        isAvailable = YES;
    }
    callback(@[[NSNull null], @(isAvailable)]);
}


RCT_EXPORT_METHOD(initHealthKit:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
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
            callback(@[RCTMakeError(@"permissions must be provided in the initialization options", nil, nil)]);
            return;
        }
        
        // make sure at least 1 read or write permission is provided
        if(!writeDataTypes && !readDataTypes){
            callback(@[RCTMakeError(@"at least 1 read or write permission must be set in options.permissions", nil, nil)]);
            return;
        }
        
        [self.hkStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSString *errMsg = [NSString stringWithFormat:@"Error with HealthKit authorization: %@", error];
                callback(@[RCTMakeError(errMsg, nil, nil)]);
                return;
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    callback(@[[NSNull null], @true]);
                });
            }
        }];
    } else {
        callback(@[RCTMakeError(@"HealthKit data is not available", nil, nil)]);
    }
}

RCT_EXPORT_METHOD(sendRequestForPermission:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    if (![HKHealthStore isHealthDataAvailable]) {
        callback(@[RCTMakeError(@"isHealthDataAvailable fail", nil, nil)]);
        return;
    } else {
        NSDictionary *permissions = [input objectForKey:@"permissions"];
        if(permissions != nil) {
            NSSet *writeDataTypes = [self getReadPermsFromOptions:[permissions objectForKey:@"read"]];
            NSSet *readDataTypes = [self getWritePermsFromOptions:[permissions objectForKey:@"write"]];
            // make sure at least 1 read or write permission is provided
            if(!writeDataTypes && !readDataTypes){
                callback(@[RCTMakeError(@"at least 1 read or write permission must be set in options.permissions", nil, nil)]);
                return;
            }
            self.hkStore = [[HKHealthStore alloc] init];
            [self.hkStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                if (!success) {
                    NSString *errMsg = [NSString stringWithFormat:@"Error with HealthKit authorization: %@", error];
                    callback(@[RCTMakeError(errMsg, nil, nil)]);
                    return;
                } else {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        callback(@[[NSNull null], @true]);
                    });
                }
            }];
        } else {
            callback(@[RCTMakeError(@"permissions must be provided in the initialization options", nil, nil)]);
            return;
        }
    }
}

RCT_EXPORT_METHOD(getAllActivityDatas:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback)
{
    if (!self.hkStore) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self getAllActivityDatas:input callback:callback];
}

// Characteristic
RCT_REMAP_METHOD(getBiologicalSex, getBiologicalSexWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSError *error;
    HKBiologicalSexObject *bioSex = [self.hkStore biologicalSexWithError:&error];
    NSString *value = nil;
    
    switch (bioSex.biologicalSex) {
        case HKBiologicalSexNotSet:
            value = @"unknown";
            break;
        case HKBiologicalSexFemale:
            value = @"female";
            break;
        case HKBiologicalSexMale:
            value = @"male";
            break;
        case HKBiologicalSexOther:
            value = @"other";
            break;
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

RCT_REMAP_METHOD(getFitzpatrickSkin, getFitzpatrickSkinWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSError *error;
    HKFitzpatrickSkinTypeObject *skin = [self.hkStore fitzpatrickSkinTypeWithError:&error];
    NSString *value = nil;
    switch (skin.skinType) {
        case HKFitzpatrickSkinTypeNotSet:
            value = @"NotSet";
            break;
        case HKFitzpatrickSkinTypeI:
            value = @"White";
            break;
        case HKFitzpatrickSkinTypeII:
            value = @"Beige";
            break;
        case HKFitzpatrickSkinTypeIII:
            value = @"LightBrown";
            break;
        case HKFitzpatrickSkinTypeIV:
            value = @"MediumBrown";
            break;
        case HKFitzpatrickSkinTypeV:
            value = @"DarkBrown";
            break;
        case HKFitzpatrickSkinTypeVI:
            value = @"Black";
            break;
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

@end
