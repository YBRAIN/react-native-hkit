//
//  HKMethods.m
//  RNHkit
//
//  Created by HoJun Lee on 2018. 4. 4..
//  Copyright © 2018년 Facebook. All rights reserved.
//

#import "HKMethods.h"
#import "Utils.h"
#import "Queries.h"

@implementation RNHkit (HKMethods)

// Results
- (void)getBloodGlucoseSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    
    HKUnit *mmoLPerL = [[HKUnit moleUnitWithMetricPrefix:HKMetricPrefixMilli molarMass:HKUnitMolarMassBloodGlucose] unitDividedByUnit:[HKUnit literUnit]];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:mmoLPerL];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil) {
        reject(@"get blood glucose fail", @"startDate is required in options", nil);
        return;
    }
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:bloodGlucoseType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(results) {
                                  resolve(results);
                                  return;
                              } else {
                                  NSLog(@"error getting blood glucose samples: %@", error);
                                  reject(@"get blood glucose fail", @"error getting blood glucose samples", error);
                                  return;
                              }
                          }];
}

- (void)getHeartRateSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    HKUnit *count = [HKUnit countUnit];
    HKUnit *minute = [HKUnit minuteUnit];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[count unitDividedByUnit:minute]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        reject(@"getHeartRateSamples", @"startDate is required in options", nil);
        return;
    }
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:heartRateType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  resolve(results);
                                  return;
                              } else {
                                  NSLog(@"error getting heart rate samples: %@", error);
                                  reject(@"getHeartRateSamples", @"error getting heart rate samples", error);
                                  
                                  return;
                              }
                          }];
}

- (void)getBodyTemperatureSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *bodyTemperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit degreeCelsiusUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        reject(@"getBodyTemperatureSamples", @"startDate is required in options", nil);
        return;
    }
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:bodyTemperatureType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  resolve(results);
                                  return;
                              } else {
                                  NSLog(@"error getting body temperature samples: %@", error);
                                  reject(@"getBodyTemperatureSamples", @"error getting body temperature samples", error);
                                  return;
                              }
                          }];
}

- (void)getBloodPressureSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *bloodPressureCorrelationType = [HKQuantityType quantityTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    HKQuantityType *systolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantityType *diastolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit millimeterOfMercuryUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        reject(@"getBloodPressureSamples", @"startDate is required in options", nil);
        return;
    }
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchCorrelationSamplesOfType:bloodPressureCorrelationType
                                   unit:unit
                              predicate:predicate
                              ascending:ascending
                                  limit:limit
                             completion:^(NSArray *results, NSError *error) {
                                 if(results){
                                     NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
                                     
                                     for (NSDictionary *sample in results) {
                                         HKCorrelation *bloodPressureValues = [sample valueForKey:@"correlation"];
                                         
                                         HKQuantitySample *bloodPressureSystolicValue = [bloodPressureValues objectsForType:systolicType].anyObject;
                                         HKQuantitySample *bloodPressureDiastolicValue = [bloodPressureValues objectsForType:diastolicType].anyObject;
                                         
                                         NSDictionary *elem = @{
                                                                @"bloodPressureSystolicValue" : @([bloodPressureSystolicValue.quantity doubleValueForUnit:unit]),
                                                                @"bloodPressureDiastolicValue" : @([bloodPressureDiastolicValue.quantity doubleValueForUnit:unit]),
                                                                @"startDate" : [sample valueForKey:@"startDate"],
                                                                @"endDate" : [sample valueForKey:@"endDate"],
                                                                };
                                         
                                         [data addObject:elem];
                                     }
                                     
                                     resolve(data);
                                     return;
                                 } else {
                                     NSLog(@"error getting blood pressure samples: %@", error);
                                     reject(@"getBloodPressureSamples", @"error getting blood pressure samples", error);
                                     return;
                                 }
                             }];
}

- (void)getRespiratoryRateSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *respiratoryRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
    
    HKUnit *count = [HKUnit countUnit];
    HKUnit *minute = [HKUnit minuteUnit];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[count unitDividedByUnit:minute]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        reject(@"getRespiratoryRateSamples", @"startDate is required in options", nil);
        return;
    }
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:respiratoryRateType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  resolve(results);
                                  return;
                              } else {
                                  NSLog(@"error getting respiratory rate samples: %@", error);
                                  reject(@"getRespiratoryRateSamples", @"error getting respiratory rate samples", error);
                                  return;
                              }
                          }];
}


- (void)getLatestWeight:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input];
    if(unit == nil){
        unit = [HKUnit poundUnit];
    }
    
    [self fetchMostRecentQuantitySampleOfType:weightType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (!mostRecentQuantity) {
                                           NSLog(@"error getting latest weight: %@", error);
                                           reject(@"getLatestWeight", @"error getting latest weight", error);
                                       }
                                       else {
                                           // Determine the weight in the required unit.
                                           double usersWeight = [mostRecentQuantity doubleValueForUnit:unit];
                                           
                                           NSDictionary *response = @{
                                                                      @"value" : @(usersWeight),
                                                                      @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           resolve(response);
                                       }
                                   }];
}


- (void)getWeightSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit poundUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        reject(@"getRespiratoryRateSamples", @"startDate is required in options", nil);
        return;
    }
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:weightType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  resolve(results);
                                  return;
                              } else {
                                  NSLog(@"error getting weight samples: %@", error);
                                  reject(@"getWeightSamples", @"error getting weight samples", nil);
                                  return;
                              }
                          }];
}





- (void)getLatestBodyMassIndex:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *bmiType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    
    [self fetchMostRecentQuantitySampleOfType:bmiType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (!mostRecentQuantity) {
                                           NSLog(@"error getting latest BMI: %@", error);
                                           reject(@"getLatestBodyMassIndex", @"error getting latest BM", nil);
                                       }
                                       else {
                                           // Determine the bmi in the required unit.
                                           HKUnit *countUnit = [HKUnit countUnit];
                                           double bmi = [mostRecentQuantity doubleValueForUnit:countUnit];
                                           
                                           NSDictionary *response = @{
                                                                      @"value" : @(bmi),
                                                                      @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           resolve(response);
                                       }
                                   }];
}

- (void)getLatestHeight:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input];
    if(unit == nil){
        unit = [HKUnit inchUnit];
    }
    
    [self fetchMostRecentQuantitySampleOfType:heightType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (!mostRecentQuantity) {
                                           NSLog(@"error getting latest height: %@", error);
                                           reject(@"getLatestHeight", @"error getting latest height", error);
                                       }
                                       else {
                                           // Determine the height in the required unit.
                                           double height = [mostRecentQuantity doubleValueForUnit:unit];
                                           
                                           NSDictionary *response = @{
                                                                      @"value" : @(height),
                                                                      @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           resolve(response);
                                       }
                                   }];
}


- (void)getHeightSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit inchUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        reject(@"getHeightSamples", @"startDate is required in options", nil);
        return;
    }
    NSPredicate * predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:heightType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  resolve(results);
                                  return;
                              } else {
                                  NSLog(@"error getting height samples: %@", error);
                                  reject(@"getHeightSamples", @"error getting height samples", error);
                                  return;
                              }
                          }];
}

- (void)getLatestBodyFatPercentage:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *bodyFatPercentType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    
    [self fetchMostRecentQuantitySampleOfType:bodyFatPercentType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (!mostRecentQuantity) {
                                           NSLog(@"error getting latest body fat percentage: %@", error);
                                           reject(@"getLatestBodyFatPercentage", @"error getting latest body fat percentage", error);
                                       }
                                       else {
                                           // Determine the weight in the required unit.
                                           HKUnit *percentUnit = [HKUnit percentUnit];
                                           double percentage = [mostRecentQuantity doubleValueForUnit:percentUnit];
                                           
                                           percentage = percentage * 100;
                                           
                                           NSDictionary *response = @{
                                                                      @"value" : @(percentage),
                                                                      @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           resolve(response);
                                       }
                                   }];
}


- (void)getLatestLeanBodyMass:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKQuantityType *leanBodyMassType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass];
    
    [self fetchMostRecentQuantitySampleOfType:leanBodyMassType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (!mostRecentQuantity) {
                                           NSLog(@"error getting latest lean body mass: %@", error);
                                           reject(@"getLatestLeanBodyMass", @"error getting latest lean body mass", error);
                                       }
                                       else {
                                           HKUnit *weightUnit = [HKUnit poundUnit];
                                           double leanBodyMass = [mostRecentQuantity doubleValueForUnit:weightUnit];
                                           
                                           NSDictionary *response = @{
                                                                      @"value" : @(leanBodyMass),
                                                                      @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           resolve(response);
                                       }
                                   }];
}



- (void)getStepCountOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    NSDate *date = [RNHkit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    
    if(date == nil) {
        reject(@"getStepCountOnDay", @"startDate is required in options", nil);
        return;
    }
    
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKUnit *stepsUnit = [HKUnit countUnit];
    
    [self fetchSumOfSamplesOnDayForType:stepCountType
                                   unit:stepsUnit
                                    day:date
                             completion:^(double value, NSDate *startDate, NSDate *endDate, NSError *error) {
                                 if (!value) {
                                     NSLog(@"could not fetch step count for day: %@", error);
                                     reject(@"getStepCountOnDay", @"could not fetch step count for day", error);
                                     return;
                                 }
                                 
                                 NSDictionary *response = @{
                                                            @"value" : @(value),
                                                            @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                            @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                            };
                                 
                                 resolve(response);
                             }];
}


- (void)getDailyStepSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit countUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        reject(@"getDailyStepSamples", @"startDate is required in options", nil);
        return;
    }
    
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    [self fetchCumulativeSumStatisticsCollection:stepCountType
                                            unit:unit
                                       startDate:startDate
                                         endDate:endDate
                                       ascending:ascending
                                           limit:limit
                                      completion:^(NSArray *arr, NSError *error){
                                          if (error != nil) {
                                              NSLog(@"error with fetchCumulativeSumStatisticsCollection: %@", error);
                                              reject(@"getDailyStepSamples", @"error with fetchCumulativeSumStatisticsCollection", error);
                                              return;
                                          }
                                          resolve(arr);
                                      }];
}

- (void)getDistanceWalkingRunningOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit meterUnit]];
    NSDate *date = [RNHkit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double distance, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (!distance) {
            NSLog(@"ERROR getting DistanceWalkingRunning: %@", error);
            reject(@"getDistanceWalkingRunningOnDay", @"ERROR getting DistanceWalkingRunning", error);
            return;
        }
        
        NSDictionary *response = @{
                                   @"value" : @(distance),
                                   @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                   @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                   };
        resolve(response);
    }];
}

- (void)getDistanceCyclingOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit meterUnit]];
    NSDate *date = [RNHkit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double distance, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (!distance) {
            NSLog(@"ERROR getting DistanceCycling: %@", error);
            reject(@"getDistanceCyclingOnDay", @"ERROR getting DistanceCycling", error);
            return;
        }
        
        NSDictionary *response = @{
                                   @"value" : @(distance),
                                   @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                   @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                   };
        
        resolve(response);
    }];
}


- (void)getFlightsClimbedOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    HKUnit *unit = [HKUnit countUnit];
    NSDate *date = [RNHkit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double count, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (!count) {
            NSLog(@"ERROR getting FlightsClimbed: %@", error);
            reject(@"getFlightsClimbedOnDay", @"ERROR getting FlightsClimbed", error);
            return;
        }
        
        NSDictionary *response = @{
                                   @"value" : @(count),
                                   @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                   @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                   };
        resolve(response);
    }];
}

- (void)getSleepSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        reject(@"getSleepSamples", @"startDate is required in options", nil);
        return;
    }
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    
    
    [self fetchSleepCategorySamplesForPredicate:predicate
                                          limit:limit
                                     completion:^(NSArray *results, NSError *error) {
                                         if(results){
                                             resolve(results);
                                             return;
                                         } else {
                                             NSLog(@"error getting sleep samples: %@", error);
                                             reject(@"getSleepSamples", @"error getting sleep samples", error);
                                             return;
                                         }
                                     }];
}

// save
- (void)saveWeight:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    double weight = [RNHkit doubleValueFromOptions:input];
    NSDate *sampleDate = [RNHkit dateFromOptionsDefaultNow:input];
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit poundUnit]];
    
    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:unit doubleValue:weight];
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:sampleDate endDate:sampleDate];
    
    [self.hkStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"error saving the weight sample: %@", error);
            callback(@[RCTMakeError(@"error saving the weight sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(weight)]);
    }];
}

- (void)saveBodyMassIndex:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    double bmi = [RNHkit doubleValueFromOptions:input];
    NSDate *sampleDate = [RNHkit dateFromOptionsDefaultNow:input];
    HKUnit *unit = [HKUnit countUnit];
    
    HKQuantity *bmiQuantity = [HKQuantity quantityWithUnit:unit doubleValue:bmi];
    HKQuantityType *bmiType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    HKQuantitySample *bmiSample = [HKQuantitySample quantitySampleWithType:bmiType quantity:bmiQuantity startDate:sampleDate endDate:sampleDate];
    
    [self.hkStore saveObject:bmiSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"error saving BMI sample: %@.", error);
            callback(@[RCTMakeError(@"error saving BMI sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(bmi)]);
    }];
}

- (void)saveHeight:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    double height = [RNHkit doubleValueFromOptions:input];
    NSDate *sampleDate = [RNHkit dateFromOptionsDefaultNow:input];
    
    HKUnit *heightUnit = [RNHkit hkUnitFromOptions:input];
    if(heightUnit == nil){
        heightUnit = [HKUnit inchUnit];
    }
    
    HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:heightUnit doubleValue:height];
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:heightQuantity startDate:sampleDate endDate:sampleDate];
    
    [self.hkStore saveObject:heightSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"error saving height sample: %@", error);
            callback(@[RCTMakeError(@"error saving height sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(height)]);
    }];
}

- (void)saveSteps:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    double value = [RNHkit doubleFromOptions:input key:@"value" withDefault:(double)0];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    
    if(startDate == nil || endDate == nil){
        callback(@[RCTMakeError(@"startDate and endDate are required in options", nil, nil)]);
        return;
    }
    
    HKUnit *unit = [HKUnit countUnit];
    HKQuantity *quantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
    
    [self.hkStore saveObject:sample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the step count sample %@. The error was: %@.", sample, error);
            callback(@[RCTMakeError(@"An error occured saving the step count sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(value)]);
    }];
}

@end
