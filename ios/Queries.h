//
//  Queries.h
//  ReactNativeHealthkit
//
//  Created by HoJun Lee on 2018. 4. 4..
//  Copyright © 2018년 Facebook. All rights reserved.
//

#import "RNHkit.h"

@interface RNHkit (Queries)

- (void)fetchMostRecentQuantitySampleOfType:(HKQuantityType *)quantityType
                                  predicate:(NSPredicate *)predicate
                                 completion:(void (^)(HKQuantity *mostRecentQuantity, NSString *startDateTimestamp, NSString *endDateTimestamp, NSError *error))completion;

- (void)fetchSumOfSamplesTodayForType:(HKQuantityType *)quantityType
                                 unit:(HKUnit *)unit
                           completion:(void (^)(double, NSError *))completionHandler;

- (void)fetchSumOfSamplesOnDayForType:(HKQuantityType *)quantityType
                                 unit:(HKUnit *)unit
                                  day:(NSDate *)day
                           completion:(void (^)(double, NSString *, NSString *, NSError *))completionHandler;

- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                    completion:(void (^)(NSArray *, NSError *))completionHandler;

- (void)fetchQuantitySamplesOfType:(HKQuantityType *)quantityType
                              unit:(HKUnit *)unit
                         predicate:(NSPredicate *)predicate
                         ascending:(BOOL)asc
                             limit:(NSUInteger)lim
                        completion:(void (^)(NSArray *, NSError *))completion;

- (void)fetchCorrelationSamplesOfType:(HKQuantityType *)quantityType
                                 unit:(HKUnit *)unit
                            predicate:(NSPredicate *)predicate
                            ascending:(BOOL)asc
                                limit:(NSUInteger)lim
                           completion:(void (^)(NSArray *, NSError *))completion;

- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                     ascending:(BOOL)asc
                                         limit:(NSUInteger)lim
                                    completion:(void (^)(NSArray *, NSError *))completionHandler;

- (void)fetchStatisticsCollectionForQuantityType:(HKQuantityType *)qauntityType
                                            unit:(HKUnit *)unit
                                       startDate:(NSDate *)startDate
                                         endDate:(NSDate *)endDate
                                        interval:(NSDateComponents *)interval
                                      completion:(void (^)(NSArray *, NSError *))completionHandler;

- (void)fetchSleepCategorySamplesForPredicate:(NSPredicate *)predicate
                                        limit:(NSUInteger)lim
                                   completion:(void (^)(NSArray *, NSError *))completion;

@end
