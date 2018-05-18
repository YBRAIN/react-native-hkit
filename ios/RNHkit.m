
#import "RNHkit.h"
#import "Queries.h"
#import "TypesAndPermissions.h"

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
}

RCT_REMAP_METHOD(requestPermission, requestPermission:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    self.hkStore = [[HKHealthStore alloc] init];
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *writeDataTypes;
        NSSet *readDataTypes;
        
        NSDictionary *permissions = [input objectForKey:@"permissions"];
        if (permissions == nil) {
            reject(@"init fail", @"permissions must be provided in the initialization options", nil);
            return;
        }
        NSArray *reads = [permissions objectForKey:@"read"];
        NSArray *writes = [permissions objectForKey:@"write"];
        NSSet *readPerms = [self getReadPermsFromOptions:reads];
        NSSet *writePerms = [self getWritePermsFromOptions:writes];
        if(readPerms != nil) {
            readDataTypes = readPerms;
        }
        if(writePerms != nil) {
            writeDataTypes = writePerms;
        }
        // make sure at least 1 read or write permission is provided
        if(!writeDataTypes && !readDataTypes){
            reject(@"init fail", @"permissions must be provided in the initialization options", nil);
            return;
        }
        [self.hkStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (error) {
                NSString *errMsg = [NSString stringWithFormat:@"Error with HealthKit authorization: %@", error];
                reject(@"init fail", errMsg, error);
                return;
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (success) {
                        resolve(@(true);
                    } else {
                        resolve(false);
                    }
                };
            }
        }];
    } else {
        reject(@"init fail", @"permissions must be provided in the initialization options", nil);
        return;
    }
}

RCT_REMAP_METHOD(isPermissionAvailable, isPermissionAvailable:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    if ([HKHealthStore isHealthDataAvailable]) {
        
        NSDictionary *dicPermissons = [RNHkit readPermissonsDict];
        HKObjectType *val = [dicPermissons objectForKey:name];
        if(val != nil) {
            HKAuthorizationStatus state =  [self.hkStore authorizationStatusForType:val];
            resolve(@(state));
        } else {
            resolve(@(-1));
            return;
        }
    } else {
        reject(@"HealthDataAvailable checking fail", @"isHealthDataAvailable fail", nil);
        return;
    }
}


// Characteristic
RCT_REMAP_METHOD(getBiologicalSex, getBiologicalSex:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
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
    
    if(!value) {
        NSLog(@"error getting biological sex: %@", error);
        reject(@"no_datas", @"There were no datas", error);
        return;
    }
    resolve(value);
}

RCT_REMAP_METHOD(getDateOfBirth, getDateOfBirth:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
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

RCT_REMAP_METHOD(getBloodType, getBloodType:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
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
    if(!value) {
        NSLog(@"error getting blood type: %@", error);
        reject(@"no_datas", @"error getting blood type", error);
        return;
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
RCT_REMAP_METHOD(getFitzpatrickSkin, getFitzpatrickSkin:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
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
    if(!value) {
        NSLog(@"error getting FitzpatrickSkin: %@", error);
        reject(@"no_datas", @"There were no datas", error);
        return;
    } else {
        resolve(value);
    }
}

RCT_REMAP_METHOD(getWheelchairUse, getWheelchairUse:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSError *error;
    HKWheelchairUseObject *object = [self.hkStore wheelchairUseWithError:&error];
    NSString *value = nil;
    switch (object.wheelchairUse) {
        case HKWheelchairUseNotSet: value = @"NotSet";  break;
        case HKWheelchairUseNo:     value = @"No";      break;
        case HKWheelchairUseYes:    value = @"Yes";     break;
    }
    if(!value) {
        NSLog(@"error getting WheelchairUse: %@", error);
        reject(@"no_datas", @"There were no datas", error);
        return;
    } else {
        resolve(value);
    }
}

// Lastst
RCT_REMAP_METHOD(getLatestHeight, getLatestHeight:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKUnit *unit = [HKUnit meterUnit];
    [self fetchMostRecentQuantitySampleOfType:heightType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (error) {
                                           NSLog(@"error getting latest height: %@", error);
                                           reject(@"getLatestHeight", @"error getting latest height", error);
                                           return;
                                       }
                                       if (!mostRecentQuantity) {
                                           resolve(@[]);
                                       } else {
                                           // Determine the height in the required unit.
                                           double height = [mostRecentQuantity doubleValueForUnit:unit];
                                           NSDictionary *response = @{
                                                                      @"value" : @(height),
                                                                      @"startDate" : [self buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [self buildISO8601StringFromDate:endDate],
                                                                      };
                                           resolve(@[response]);
                                       }
                                   }];
}

RCT_REMAP_METHOD(getLatestWeight, getLatestWeight:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKUnit *unit = [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo];
    [self fetchMostRecentQuantitySampleOfType:weightType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (error) {
                                           NSLog(@"error getting latest Weight: %@", error);
                                           reject(@"getLatestWeight", @"error getting latest Weight", error);
                                           return;
                                       }
                                       if (!mostRecentQuantity) {
                                           resolve(@[]);
                                       } else {
                                           // Determine the weight in the required unit.
                                           double usersWeight = [mostRecentQuantity doubleValueForUnit:unit];
                                           NSDictionary *response = @{
                                                                      @"value" : @(usersWeight),
                                                                      @"startDate" : [self buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [self buildISO8601StringFromDate:endDate],
                                                                      };
                                           resolve(@[response]);
                                       }
                                   }];
}

RCT_REMAP_METHOD(getLatestBodyMassIndex, getLatestBodyMassIndex:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *bmiType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    HKUnit *unit = [HKUnit countUnit];
    [self fetchMostRecentQuantitySampleOfType:bmiType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (error) {
                                           NSLog(@"error getting latest BMI: %@", error);
                                           reject(@"getLatestBodyMassIndex", @"error getting latest BMI", error);
                                           return;
                                       }
                                       if (!mostRecentQuantity) {
                                           resolve(@[]);
                                       } else {
                                           // Determine the bmi in the required unit.
                                           double bmi = [mostRecentQuantity doubleValueForUnit:unit];
                                           NSDictionary *response = @{
                                                                      @"value" : @(bmi),
                                                                      @"startDate" : [self buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [self buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           resolve(@[response]);
                                       }
                                   }];
}

RCT_REMAP_METHOD(getLatestLeanBodyMass, getLatestLeanBodyMass:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *leanBodyMassType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass];
    HKUnit *unit = [HKUnit poundUnit];
    [self fetchMostRecentQuantitySampleOfType:leanBodyMassType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (error) {
                                           NSLog(@"error getting latest lean body mass: %@", error);
                                           reject(@"getLatestLeanBodyMass", @"error getting latest lean body mass", error);
                                           return;
                                       }
                                       if (!mostRecentQuantity) {
                                           resolve(@[]);
                                       } else {
                                           double leanBodyMass = [mostRecentQuantity doubleValueForUnit:unit];
                                           NSDictionary *response = @{
                                                                      @"value" : @(leanBodyMass),
                                                                      @"startDate" : [self buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [self buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           resolve(@[response]);
                                       }
                                   }];
}

RCT_REMAP_METHOD(getLatestBodyFatPercentage, getLatestBodyFatPercentage:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *bodyFatPercentType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    HKUnit *unit = [HKUnit percentUnit];
    [self fetchMostRecentQuantitySampleOfType:bodyFatPercentType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (error) {
                                           NSLog(@"error getting latest body fat percentage: %@", error);
                                           reject(@"getLatestBodyFatPercentage", @"error getting latest body fat percentage", error);
                                           return;
                                       }
                                       if (!mostRecentQuantity) {
                                           resolve(@[]);
                                       } else {
                                           // Determine the weight in the required unit.
                                           double percentage = [mostRecentQuantity doubleValueForUnit:unit];
                                           percentage = percentage * 100;
                                           NSDictionary *response = @{
                                                                      @"value" : @(percentage),
                                                                      @"startDate" : [self buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [self buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           resolve(@[response]);
                                       }
                                   }];
}

RCT_REMAP_METHOD(getDistanceWalkingRunningOnDay, getDistanceWalkingRunningOnDay:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKUnit *unit = [HKUnit meterUnit];
    NSString *strDate = [input objectForKey:@"date"];
    NSDate *date = strDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strDate.doubleValue)] : [NSDate date];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double distance, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (error) {
            NSLog(@"ERROR getting DistanceWalkingRunning: %@", error);
            reject(@"getDistanceWalkingRunningOnDay", @"ERROR getting DistanceWalkingRunning", error);
            return;
        }
        if (!distance) {
            resolve(@[]);
        }
        NSDictionary *response = @{
                                   @"value" : @(distance),
                                   @"startDate" : [self buildISO8601StringFromDate:startDate],
                                   @"endDate" : [self buildISO8601StringFromDate:endDate],
                                   };
        resolve(@[response]);
    }];
}

RCT_REMAP_METHOD(getDistanceCyclingOnDay, getDistanceCyclingOnDay:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
    HKUnit *unit = [HKUnit meterUnit];
    NSString *strDate = [input objectForKey:@"date"];
    NSDate *date = strDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strDate.doubleValue)] : [NSDate date];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double distance, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (error) {
            NSLog(@"ERROR getting DistanceCycling: %@", error);
            reject(@"getDistanceCyclingOnDay", @"ERROR getting DistanceCycling", error);
            return;
        }
        if (!distance) {
            resolve(@[]);
        }
        NSDictionary *response = @{
                                   @"value" : @(distance),
                                   @"startDate" : [self buildISO8601StringFromDate:startDate],
                                   @"endDate" : [self buildISO8601StringFromDate:endDate],
                                   };
        resolve(@[response]);
    }];
}

RCT_REMAP_METHOD(getFlightsClimbedOnDay, getFlightsClimbedOnDay:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    HKUnit *unit = [HKUnit countUnit];
    NSString *strDate = [input objectForKey:@"date"];
    NSDate *date = strDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strDate.doubleValue)] : [NSDate date];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double count, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (error) {
            NSLog(@"ERROR getting FlightsClimbed: %@", error);
            reject(@"getFlightsClimbedOnDay", @"ERROR getting FlightsClimbed", error);
            return;
        }
        if (!count) {
            resolve(@[]);
        }
        NSDictionary *response = @{
                                   @"value" : @(count),
                                   @"startDate" : [self buildISO8601StringFromDate:startDate],
                                   @"endDate" : [self buildISO8601StringFromDate:endDate],
                                   };
        resolve(@[response]);
    }];
}

RCT_REMAP_METHOD(getStepCountOnDay, getStepCountOnDay:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKUnit *stepsUnit = [HKUnit countUnit];
    NSString *strDate = [input objectForKey:@"date"];
    NSDate *date = strDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strDate.doubleValue)] : [NSDate date];
    
    [self fetchSumOfSamplesOnDayForType:stepCountType
                                   unit:stepsUnit
                                    day:date
                             completion:^(double value, NSDate *startDate, NSDate *endDate, NSError *error) {
                                 if (error) {
                                     NSLog(@"could not fetch step count for day: %@", error);
                                     reject(@"getStepCountOnDay", @"could not fetch step count for day", error);
                                     return;
                                 }
                                 if (!value) {
                                     resolve(@[]);
                                 }
                                 NSDictionary *response = @{
                                                            @"value" : @(value),
                                                            @"startDate" : [self buildISO8601StringFromDate:startDate],
                                                            @"endDate" : [self buildISO8601StringFromDate:endDate],
                                                            };
                                 resolve(@[response]);
                             }];
}

// normal
RCT_REMAP_METHOD(getHeightSamples, getHeightSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    NSString *strUnit = [input objectForKey:@"unit"];
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSNumber *numBool = [input objectForKey:@"ascending"];
    
    HKUnit *unit = strUnit != nil ? [HKUnit unitFromString:strUnit] : [HKUnit meterUnit];
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    BOOL ascending = numBool != nil ? [numBool boolValue] : false;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"getHeightSamples fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:heightType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(error){
                                  NSLog(@"error getting height samples: %@", error);
                                  reject(@"getHeightSamples", @"error getting height samples", error);
                                  return;
                              }
                              resolve(results);
                          }];
}

RCT_REMAP_METHOD(getWeightSamples, getWeightSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    NSString *strUnit = [input objectForKey:@"unit"];
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSNumber *numBool = [input objectForKey:@"ascending"];
    
    HKUnit *unit = strUnit != nil ? [HKUnit unitFromString:strUnit] : [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo];
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    BOOL ascending = numBool != nil ? [numBool boolValue] : false;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"getWeightSamples fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:weightType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(error){
                                  NSLog(@"error getting weight samples: %@", error);
                                  reject(@"getWeightSamples", @"error getting weight samples", nil);
                                  return;
                              }
                              resolve(results);
                          }];
}

RCT_REMAP_METHOD(getSleepSamples, getSleepSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"getSleepSamples fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchSleepCategorySamplesForPredicate:predicate
                                          limit:limit
                                     completion:^(NSArray *results, NSError *error) {
                                         if(error){
                                             NSLog(@"error getting sleep samples: %@", error);
                                             reject(@"getSleepSamples", @"error getting sleep samples", error);
                                             return;
                                         }
                                         resolve(results);
                                     }];
}

RCT_REMAP_METHOD(getDailyStepSamples, getDailyStepSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString *strUnit = [input objectForKey:@"unit"];
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSNumber *numBool = [input objectForKey:@"ascending"];
    
    HKUnit *unit = strUnit != nil ? [HKUnit unitFromString:strUnit] : [HKUnit countUnit];
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    BOOL ascending = numBool != nil ? [numBool boolValue] : false;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"getDailyStepSamples fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    NSLog(@"date: %@ ~ %@", startDate, endDate);
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    [self fetchCumulativeSumStatisticsCollection:stepCountType
                                            unit:unit
                                       startDate:startDate
                                         endDate:endDate
                                       ascending:ascending
                                           limit:limit
                                      completion:^(NSArray *result, NSError *error){
                                          if (error) {
                                              NSLog(@"error with fetchCumulativeSumStatisticsCollection: %@", error);
                                              reject(@"getDailyStepSamples", @"error with fetchCumulativeSumStatisticsCollection", error);
                                              return;
                                          }
                                          resolve(result);
                                      }];
}

RCT_REMAP_METHOD(getHeartRateSamples, getHeartRateSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    NSString *strUnit = [input objectForKey:@"unit"];
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSNumber *numBool = [input objectForKey:@"ascending"];
    
    HKUnit *unit = strUnit != nil ? [HKUnit unitFromString:strUnit] : [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    BOOL ascending = numBool != nil ? [numBool boolValue] : false;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"getHeartRateSamples fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:heartRateType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(error){
                                  NSLog(@"error getting heart rate samples: %@", error);
                                  reject(@"getHeartRateSamples", @"error getting heart rate samples", error);
                                  return;
                              }
                              resolve(results);
                          }];
}

// other
RCT_REMAP_METHOD(getBloodGlucoseSamples, getBloodGlucoseSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    HKUnit *mmoLPerL = [[HKUnit moleUnitWithMetricPrefix:HKMetricPrefixMilli molarMass:HKUnitMolarMassBloodGlucose] unitDividedByUnit:[HKUnit literUnit]];
    
    NSString *strUnit = [input objectForKey:@"unit"];
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSNumber *numBool = [input objectForKey:@"ascending"];
    
    HKUnit *unit = strUnit != nil ? [HKUnit unitFromString:strUnit] : mmoLPerL;
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    BOOL ascending = numBool != nil ? [numBool boolValue] : false;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"get blood glucose fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:bloodGlucoseType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(error) {
                                  NSLog(@"error getting blood glucose samples: %@", error);
                                  reject(@"get blood glucose fail", @"error getting blood glucose samples", error);
                                  return;
                              }
                              resolve(results);
                          }];
}

RCT_REMAP_METHOD(getBloodPressureSamples, getBloodPressureSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *bodyTemperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    
    NSString *strUnit = [input objectForKey:@"unit"];
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSNumber *numBool = [input objectForKey:@"ascending"];
    
    HKUnit *unit = strUnit != nil ? [HKUnit unitFromString:strUnit] : [HKUnit degreeCelsiusUnit];
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    BOOL ascending = numBool != nil ? [numBool boolValue] : false;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"getBloodPressureSamples fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:bodyTemperatureType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(error){
                                  NSLog(@"error getting body temperature samples: %@", error);
                                  reject(@"getBodyTemperatureSamples", @"error getting body temperature samples", error);
                                  return;
                              }
                              resolve(results);
                          }];
}

RCT_REMAP_METHOD(getRespiratoryRateSamples, getRespiratoryRateSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *bloodPressureCorrelationType = [HKQuantityType quantityTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    HKQuantityType *systolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantityType *diastolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    
    NSString *strUnit = [input objectForKey:@"unit"];
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSNumber *numBool = [input objectForKey:@"ascending"];
    
    HKUnit *unit = strUnit != nil ? [HKUnit unitFromString:strUnit] : [HKUnit millimeterOfMercuryUnit];
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    BOOL ascending = numBool != nil ? [numBool boolValue] : false;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"getRespiratoryRateSamples fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchCorrelationSamplesOfType:bloodPressureCorrelationType
                                   unit:unit
                              predicate:predicate
                              ascending:ascending
                                  limit:limit
                             completion:^(NSArray *results, NSError *error) {
                                 if(error){
                                     NSLog(@"error getting blood pressure samples: %@", error);
                                     reject(@"getBloodPressureSamples", @"error getting blood pressure samples", error);
                                     return;
                                 }
                                 NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
                                 for (NSDictionary *sample in results) {
                                     HKCorrelation *bloodPressureValues = [sample valueForKey:@"correlation"];
                                     
                                     HKQuantitySample *bloodPressureSystolicValue = [bloodPressureValues objectsForType:systolicType].anyObject;
                                     HKQuantitySample *bloodPressureDiastolicValue = [bloodPressureValues objectsForType:diastolicType].anyObject;
                                     
                                     NSDictionary *elem = @{
                                                            @"value": @{
                                                                    @"bloodPressureSystolicValue" : @([bloodPressureSystolicValue.quantity doubleValueForUnit:unit]),
                                                                    @"bloodPressureDiastolicValue" : @([bloodPressureDiastolicValue.quantity doubleValueForUnit:unit])
                                                                    },
                                                            @"startDate" : [sample valueForKey:@"startDate"],
                                                            @"endDate" : [sample valueForKey:@"endDate"],
                                                            };
                                     [data addObject:elem];
                                 }
                                 resolve(data);
                             }];
}

RCT_REMAP_METHOD(getBodyTemperatureSamples, getBodyTemperatureSamples:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    HKQuantityType *respiratoryRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
    
    NSString *strUnit = [input objectForKey:@"unit"];
    NSNumber *numLimit = [input objectForKey:@"limit"];
    NSNumber *numBool = [input objectForKey:@"ascending"];
    
    HKUnit *unit = strUnit != nil ? [HKUnit unitFromString:strUnit] : [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
    NSUInteger limit = numLimit != nil ? [numLimit unsignedIntValue] : HKObjectQueryNoLimit;
    BOOL ascending = numBool != nil ? [numBool boolValue] : false;
    
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    if(startDate == nil) {
        reject(@"getBodyTemperatureSamples fail", @"startDate is required in options", nil);
        return;
    }
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:respiratoryRateType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(error){
                                  NSLog(@"error getting respiratory rate samples: %@", error);
                                  reject(@"getRespiratoryRateSamples", @"error getting respiratory rate samples", error);
                                  return;
                              }
                              resolve(results);
                          }];
}


// save
RCT_REMAP_METHOD(saveHeight, saveHeight:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    double value = [[input objectForKey:@"value"] doubleValue];
    NSString *strDate = [input objectForKey:@"date"];
    NSDate *date = strDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strDate.doubleValue)] : [NSDate new];
    
    HKUnit *heightUnit = [HKUnit meterUnit];
    HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:heightUnit doubleValue:value];
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:heightQuantity startDate:date endDate:date];
    
    [self.hkStore saveObject:heightSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"error saving height sample: %@", error);
            reject(@"saveHeight", @"error saveHeight", error);
            return;
        }
        resolve(@(value));
    }];
}

RCT_REMAP_METHOD(saveWeight, saveWeight:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    double value = [[input objectForKey:@"value"] doubleValue];
    NSString *strDate = [input objectForKey:@"date"];
    NSDate *date = strDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strDate.doubleValue)] : [NSDate new];
    
    HKUnit *unit = [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo];
    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:date endDate:date];
    
    [self.hkStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"error saving the weight sample: %@", error);
            reject(@"saveWeight", @"error saveWeight", error);
            return;
        }
        resolve(@(value));
    }];
}

RCT_REMAP_METHOD(saveBodyMassIndex, saveBodyMassIndex:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    double value = [[input objectForKey:@"value"] doubleValue];
    NSString *strDate = [input objectForKey:@"date"];
    NSDate *date = strDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strDate.doubleValue)] : [NSDate new];
    
    HKUnit *unit = [HKUnit countUnit];
    HKQuantity *bmiQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *bmiType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    HKQuantitySample *bmiSample = [HKQuantitySample quantitySampleWithType:bmiType quantity:bmiQuantity startDate:date endDate:date];
    
    [self.hkStore saveObject:bmiSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"error saving BMI sample: %@.", error);
            reject(@"saveBodyMassIndex", @"error saveBodyMassIndex", error);
            return;
        }
        resolve(@(value));
    }];
}

RCT_REMAP_METHOD(saveSteps, saveSteps:(NSDictionary *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    double value = [[input objectForKey:@"value"] doubleValue];
    NSString *strStartDate = [input objectForKey:@"startDate"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(strStartDate.doubleValue)];
    NSString *strEndDate = [input objectForKey:@"endDate"];
    NSDate *endDate = strEndDate != nil ? [NSDate dateWithTimeIntervalSince1970:(strEndDate.doubleValue)] : [NSDate new];
    
    if(startDate == nil || endDate == nil){
        reject(@"saveSteps", @"startDate and endDate are required in options", nil);
        return;
    }
    
    HKUnit *unit = [HKUnit countUnit];
    HKQuantity *quantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
    
    [self.hkStore saveObject:sample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the step count sample %@. The error was: %@.", sample, error);
            reject(@"saveSteps", @"error saveSteps", error);
            return;
        }
        resolve(@(value));
    }];
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

// Date Utils
- (NSDate *)parseISO8601DateFromString:(NSString *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSLocale *posix = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = posix;
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ";
    return [dateFormatter dateFromString:date];
}

- (NSString *)buildISO8601StringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSLocale *posix = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = posix;
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ";
    return [dateFormatter stringFromDate:date];
}

@end
