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
- (void)getAllActivityDatas:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
//    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
//    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
//    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
//
//    NSArray *result = @[];
//    [RNHkit ]
//    [self getBloodGlucoseSamplesWithHKUnit:bloodGlucoseType startDate:startDate endDate:endDate
}

- (void)getBloodGlucoseSamplesWithHKUnit:(HKUnit *)unit startDate:(NSDate *)startDate endDate:(NSDate *)endDate completionHandler:(void (^)(NSArray *results))completionHandler {
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    if(startDate == nil){
        return;
    }
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:bloodGlucoseType
                                unit:unit
                           predicate:predicate
                           ascending:NO
                               limit:HKObjectQueryNoLimit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  completionHandler(results);
                              } else {
                                  NSLog(@"error getting blood glucose samples: %@", error);
                                  completionHandler(@[]);
                              }
                          }];
}

- (void)getBloodGlucoseSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    
    HKUnit *mmoLPerL = [[HKUnit moleUnitWithMetricPrefix:HKMetricPrefixMilli molarMass:HKUnitMolarMassBloodGlucose] unitDividedByUnit:[HKUnit literUnit]];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:mmoLPerL];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    [self getBloodGlucoseSamplesWithHKUnit:unit startDate:startDate endDate:endDate completionHandler:^(NSArray *results) {
        if(results){
            callback(@[[NSNull null], results]);
            return;
        } else {
            callback(@[RCTMakeError(@"error getting blood glucose samples", nil, nil)]);
            return;
        }
    }];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    [self fetchQuantitySamplesOfType:bloodGlucoseType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  callback(@[[NSNull null], results]);
                                  return;
                              } else {
                                  NSLog(@"error getting blood glucose samples: %@", error);
                                  callback(@[RCTMakeError(@"error getting blood glucose samples", nil, nil)]);
                                  return;
                              }
                          }];
}

- (void)vitals_getHeartRateSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    HKUnit *count = [HKUnit countUnit];
    HKUnit *minute = [HKUnit minuteUnit];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[count unitDividedByUnit:minute]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
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
                                  callback(@[[NSNull null], results]);
                                  return;
                              } else {
                                  NSLog(@"error getting heart rate samples: %@", error);
                                  callback(@[RCTMakeError(@"error getting heart rate samples", nil, nil)]);
                                  return;
                              }
                          }];
}


- (void)vitals_getBodyTemperatureSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *bodyTemperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit degreeCelsiusUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
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
                                  callback(@[[NSNull null], results]);
                                  return;
                              } else {
                                  NSLog(@"error getting body temperature samples: %@", error);
                                  callback(@[RCTMakeError(@"error getting body temperature samples", nil, nil)]);
                                  return;
                              }
                          }];
}


- (void)vitals_getBloodPressureSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *bloodPressureCorrelationType = [HKQuantityType quantityTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    HKQuantityType *systolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantityType *diastolicType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit millimeterOfMercuryUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
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
                                     
                                     callback(@[[NSNull null], data]);
                                     return;
                                 } else {
                                     NSLog(@"error getting blood pressure samples: %@", error);
                                     callback(@[RCTMakeError(@"error getting blood pressure samples", nil, nil)]);
                                     return;
                                 }
                             }];
}


- (void)vitals_getRespiratoryRateSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *respiratoryRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
    
    HKUnit *count = [HKUnit countUnit];
    HKUnit *minute = [HKUnit minuteUnit];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[count unitDividedByUnit:minute]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
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
                                  callback(@[[NSNull null], results]);
                                  return;
                              } else {
                                  NSLog(@"error getting respiratory rate samples: %@", error);
                                  callback(@[RCTMakeError(@"error getting respiratory rate samples", nil, nil)]);
                                  return;
                              }
                          }];
}


- (void)body_getLatestWeight:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
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
                                           callback(@[RCTMakeError(@"error getting latest weight", error, nil)]);
                                       }
                                       else {
                                           // Determine the weight in the required unit.
                                           double usersWeight = [mostRecentQuantity doubleValueForUnit:unit];
                                           
                                           NSDictionary *response = @{
                                                                      @"value" : @(usersWeight),
                                                                      @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           callback(@[[NSNull null], response]);
                                       }
                                   }];
}


- (void)body_getWeightSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit poundUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
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
                                  callback(@[[NSNull null], results]);
                                  return;
                              } else {
                                  NSLog(@"error getting weight samples: %@", error);
                                  callback(@[RCTMakeError(@"error getting weight samples", nil, nil)]);
                                  return;
                              }
                          }];
}


- (void)body_saveWeight:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
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


- (void)body_getLatestBodyMassIndex:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *bmiType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    
    [self fetchMostRecentQuantitySampleOfType:bmiType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (!mostRecentQuantity) {
                                           NSLog(@"error getting latest BMI: %@", error);
                                           callback(@[RCTMakeError(@"error getting latest BMI", error, nil)]);
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
                                           
                                           callback(@[[NSNull null], response]);
                                       }
                                   }];
}


- (void)body_saveBodyMassIndex:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
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


- (void)body_getLatestHeight:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
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
                                           callback(@[RCTMakeError(@"error getting latest height", error, nil)]);
                                       }
                                       else {
                                           // Determine the height in the required unit.
                                           double height = [mostRecentQuantity doubleValueForUnit:unit];
                                           
                                           NSDictionary *response = @{
                                                                      @"value" : @(height),
                                                                      @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           callback(@[[NSNull null], response]);
                                       }
                                   }];
}


- (void)body_getHeightSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit inchUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
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
                                  callback(@[[NSNull null], results]);
                                  return;
                              } else {
                                  NSLog(@"error getting height samples: %@", error);
                                  callback(@[RCTMakeError(@"error getting height samples", error, nil)]);
                                  return;
                              }
                          }];
}


- (void)body_saveHeight:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
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


- (void)body_getLatestBodyFatPercentage:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *bodyFatPercentType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    
    [self fetchMostRecentQuantitySampleOfType:bodyFatPercentType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (!mostRecentQuantity) {
                                           NSLog(@"error getting latest body fat percentage: %@", error);
                                           callback(@[RCTMakeError(@"error getting latest body fat percentage", error, nil)]);
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
                                           
                                           callback(@[[NSNull null], response]);
                                       }
                                   }];
}


- (void)body_getLatestLeanBodyMass:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKQuantityType *leanBodyMassType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass];
    
    [self fetchMostRecentQuantitySampleOfType:leanBodyMassType
                                    predicate:nil
                                   completion:^(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error) {
                                       if (!mostRecentQuantity) {
                                           NSLog(@"error getting latest lean body mass: %@", error);
                                           callback(@[RCTMakeError(@"error getting latest lean body mass", error, nil)]);
                                       }
                                       else {
                                           HKUnit *weightUnit = [HKUnit poundUnit];
                                           double leanBodyMass = [mostRecentQuantity doubleValueForUnit:weightUnit];
                                           
                                           NSDictionary *response = @{
                                                                      @"value" : @(leanBodyMass),
                                                                      @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                                      @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                                      };
                                           
                                           callback(@[[NSNull null], response]);
                                       }
                                   }];
}



- (void)fitness_getStepCountOnDay:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    NSDate *date = [RNHkit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    
    if(date == nil) {
        callback(@[RCTMakeError(@"could not parse date from options.date", nil, nil)]);
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
                                     callback(@[RCTMakeError(@"could not fetch step count for day", error, nil)]);
                                     return;
                                 }
                                 
                                 NSDictionary *response = @{
                                                            @"value" : @(value),
                                                            @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                                            @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                                            };
                                 
                                 callback(@[[NSNull null], response]);
                             }];
}


- (void)fitness_getDailyStepSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit countUnit]];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    [self fetchCumulativeSumStatisticsCollection:stepCountType
                                            unit:unit
                                       startDate:startDate
                                         endDate:endDate
                                       ascending:ascending
                                           limit:limit
                                      completion:^(NSArray *arr, NSError *err){
                                          if (err != nil) {
                                              NSLog(@"error with fetchCumulativeSumStatisticsCollection: %@", err);
                                              callback(@[RCTMakeError(@"error with fetchCumulativeSumStatisticsCollection", err, nil)]);
                                              return;
                                          }
                                          callback(@[[NSNull null], arr]);
                                      }];
}


- (void)fitness_saveSteps:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
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

- (void)fitness_getDistanceWalkingRunningOnDay:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit meterUnit]];
    NSDate *date = [RNHkit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double distance, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (!distance) {
            NSLog(@"ERROR getting DistanceWalkingRunning: %@", error);
            callback(@[RCTMakeError(@"ERROR getting DistanceWalkingRunning", error, nil)]);
            return;
        }
        
        NSDictionary *response = @{
                                   @"value" : @(distance),
                                   @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                   @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                   };
        
        
        callback(@[[NSNull null], response]);
    }];
}


- (void)fitness_getDistanceCyclingOnDay:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit meterUnit]];
    NSDate *date = [RNHkit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double distance, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (!distance) {
            NSLog(@"ERROR getting DistanceCycling: %@", error);
            callback(@[RCTMakeError(@"ERROR getting DistanceCycling", error, nil)]);
            return;
        }
        
        NSDictionary *response = @{
                                   @"value" : @(distance),
                                   @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                   @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                   };
        
        callback(@[[NSNull null], response]);
    }];
}


- (void)fitness_getFlightsClimbedOnDay:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    HKUnit *unit = [HKUnit countUnit];
    NSDate *date = [RNHkit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    [self fetchSumOfSamplesOnDayForType:quantityType unit:unit day:date completion:^(double count, NSDate *startDate, NSDate *endDate, NSError *error) {
        if (!count) {
            NSLog(@"ERROR getting FlightsClimbed: %@", error);
            callback(@[RCTMakeError(@"ERROR getting FlightsClimbed", error, nil), @(count)]);
            return;
        }
        
        NSDictionary *response = @{
                                   @"value" : @(count),
                                   @"startDate" : [RNHkit buildISO8601StringFromDate:startDate],
                                   @"endDate" : [RNHkit buildISO8601StringFromDate:endDate],
                                   };
        
        callback(@[[NSNull null], response]);
    }];
}

- (void)sleep_getSleepSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback {
    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    
    
    [self fetchSleepCategorySamplesForPredicate:predicate
                                          limit:limit
                                     completion:^(NSArray *results, NSError *error) {
                                         if(results){
                                             callback(@[[NSNull null], results]);
                                             return;
                                         } else {
                                             NSLog(@"error getting sleep samples: %@", error);
                                             callback(@[RCTMakeError(@"error getting sleep samples", nil, nil)]);
                                             return;
                                         }
                                     }];
    
}

@end
