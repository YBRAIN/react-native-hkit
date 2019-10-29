#import "Queries.h"
@import Foundation;

@implementation RNHkit (Queries)

// utils
+ (NSString*)jsonStringFromDictionary:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (NSString*)jsonStringFromArray:(NSArray *)array {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

// Date Utils
- (NSString *)parseUnixTimestampStringFromDate:(NSDate *)date {
    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    return [NSString stringWithFormat:@"%lld", milliseconds];
}

- (NSNumber *)parseUnixTimestampFromDate:(NSDate *)date {
    return [NSNumber numberWithLongLong:(long long)([date timeIntervalSince1970] * 1000.0)];
}

- (NSDate *)parseISO8601DateFromString:(NSString *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSLocale *posix = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = posix;
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ";
    return [dateFormatter dateFromString:date];
}

- (NSString *)buildISO8601StringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSLocale *posix = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = posix;
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ";
    return [dateFormatter stringFromDate:date];
}

- (NSPredicate *)predicateForSamplesOnDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [calendar startOfDayForDate:date];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
}


// implementation

- (void)fetchMostRecentQuantitySampleOfType:(HKQuantityType *)quantityType
                                  predicate:(NSPredicate *)predicate
                                 completion:(void (^)(HKQuantity *, NSString *, NSString *, NSError *))completion {
    if (!completion) {
        return;
    }
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc]
                            initWithSampleType:quantityType
                            predicate:predicate
                            limit:1
                            sortDescriptors:@[timeSortDescriptor]
                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                // If quantity isn't in the database, return nil in the completion block.
                                if (!results) {
                                    completion(nil, nil, nil, error);
                                    return;
                                } else {
                                    HKQuantitySample *quantitySample = results.firstObject;
                                    HKQuantity *quantity = quantitySample.quantity;
                                    NSString *startDate = [self parseUnixTimestampStringFromDate:quantitySample.startDate];
                                    NSString *endDate = [self parseUnixTimestampStringFromDate:quantitySample.endDate];
                                    completion(quantity, startDate, endDate, error);
                                }
                            }
                            ];
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}

- (void)fetchCumulativeDurationForQuantitySamplesOfType:(HKQuantityType *)quantityType
                                              startDate:(NSDate *)startDate
                                                endDate:(NSDate *)endDate
                                             completion:(void (^)(double, NSError *))completionHandler {
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType
                                                           predicate:predicate
                                                               limit:HKObjectQueryNoLimit
                                                     sortDescriptors:nil
                                                      resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                                          double totalDuration = 0;
                                                          if (results != nil) {
                                                              NSSet *sampleSet = [NSSet setWithArray:results];
                                                              for (HKQuantitySample *sample in sampleSet) {
                                                                  NSDate *startDate = sample.startDate;
                                                                  NSDate *endDate = sample.endDate;
                                                                  totalDuration += [endDate timeIntervalSinceDate:startDate];
                                                              }
                                                          }
                                                          completionHandler(totalDuration, error);
                                                      }];
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}


- (void)fetchQuantitySamplesOfType:(HKQuantityType *)quantityType
                              unit:(HKUnit *)unit
                         predicate:(NSPredicate *)predicate
                         ascending:(BOOL)asc
                             limit:(NSUInteger)lim
                        completion:(void (^)(NSArray *, NSError *))completion {
    
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:asc];
    
    // declare the block
    void (^handlerBlock)(HKSampleQuery *query, NSArray *results, NSError *error);
    // create and assign the block
    handlerBlock = ^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        if (completion) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (HKQuantitySample *sample in results) {
                    HKQuantity *quantity = sample.quantity;
                    double value = [quantity doubleValueForUnit:unit];
                    
                    NSString *startDateString = [self parseUnixTimestampStringFromDate:sample.startDate];
                    NSString *endDateString = [self parseUnixTimestampStringFromDate:sample.endDate];
                    
                    NSDictionary *elem = @{
                                           @"value" : @(value),
                                           @"startDate" : startDateString,
                                           @"endDate" : endDateString,
                                           };
                    
                    [data addObject:elem];
                }
                
                completion(data, error);
            });
        }
    };
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType
                                                           predicate:predicate
                                                               limit:lim
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:handlerBlock];
    
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}

- (void)fetchSleepCategorySamplesForPredicate:(NSPredicate *)predicate
                                        limit:(NSUInteger)lim
                                   completion:(void (^)(NSArray *, NSError *))completion {
    
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:false];
    
    
    // declare the block
    void (^handlerBlock)(HKSampleQuery *query, NSArray *results, NSError *error);
    // create and assign the block
    handlerBlock = ^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        if (completion) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (HKCategorySample *sample in results) {
                    
                    // HKCategoryType *catType = sample.categoryType;
                    NSInteger val = sample.value;
                    
                    // HKQuantity *quantity = sample.quantity;
                    // double value = [quantity doubleValueForUnit:unit];
                    
                    NSString *startDateString = [self parseUnixTimestampStringFromDate:sample.startDate];
                    NSString *endDateString = [self parseUnixTimestampStringFromDate:sample.endDate];
                    
                    NSString *valueString;
                    
                    switch (val) {
                        case HKCategoryValueSleepAnalysisAwake:
                            valueString = @"AWAKE";
                            break;
                        case HKCategoryValueSleepAnalysisInBed:
                            valueString = @"INBED";
                            break;
                        case HKCategoryValueSleepAnalysisAsleep:
                            valueString = @"ASLEEP";
                            break;
                        default:
                            valueString = @"UNKNOWN";
                            break;
                    }
                    
                    NSDictionary *elem = @{
                                           @"value" : valueString,
                                           @"startDate" : startDateString,
                                           @"endDate" : endDateString,
                                           };
                    
                    [data addObject:elem];
                }
                
                completion(data, error);
            });
        }
    };
    
    // HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType
    //                                                        predicate:predicate
    //                                                            limit:lim
    //                                                  sortDescriptors:@[timeSortDescriptor]
    //                                                   resultsHandler:handlerBlock];
    
    HKCategoryType *categoryType = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    // HKCategorySample *categorySample =
    // [HKCategorySample categorySampleWithType:categoryType
    //                                    value:value
    //                                startDate:startDate
    //                                  endDate:endDate];
    
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:categoryType
                                                           predicate:predicate
                                                               limit:lim
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:handlerBlock];
    
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}

- (void)fetchCorrelationSamplesOfType:(HKQuantityType *)quantityType
                                 unit:(HKUnit *)unit
                            predicate:(NSPredicate *)predicate
                            ascending:(BOOL)asc
                                limit:(NSUInteger)lim
                           completion:(void (^)(NSArray *, NSError *))completion {
    
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate
                                                                       ascending:asc];
    
    // declare the block
    void (^handlerBlock)(HKSampleQuery *query, NSArray *results, NSError *error);
    // create and assign the block
    handlerBlock = ^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        if (completion) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (HKCorrelation *sample in results) {
                    NSString *startDateString = [self parseUnixTimestampStringFromDate:sample.startDate];
                    NSString *endDateString = [self parseUnixTimestampStringFromDate:sample.endDate];
                    
                    NSDictionary *elem = @{
                                           @"correlation" : sample,
                                           @"startDate" : startDateString,
                                           @"endDate" : endDateString,
                                           };
                    [data addObject:elem];
                }
                
                completion(data, error);
            });
        }
    };
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType
                                                           predicate:predicate
                                                               limit:lim
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:handlerBlock];
    
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}


- (void)fetchSumOfSamplesTodayForType:(HKQuantityType *)quantityType
                                 unit:(HKUnit *)unit
                           completion:(void (^)(double, NSError *))completionHandler {
    
    NSPredicate *predicate = [self predicateForSamplesOnDay:[NSDate date]];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType
                                                       quantitySamplePredicate:predicate
                                                                       options:HKStatisticsOptionCumulativeSum
                                                             completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
                                                                 HKQuantity *sum = [result sumQuantity];
                                                                 if (completionHandler) {
                                                                     double value = [sum doubleValueForUnit:unit];
                                                                     completionHandler(value, error);
                                                                 }
                                                             }];
    
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}


- (void)fetchSumOfSamplesOnDayForType:(HKQuantityType *)quantityType
                                 unit:(HKUnit *)unit
                                  day:(NSDate *)day
                           completion:(void (^)(double, NSString *, NSString *, NSError *))completionHandler {
    
    NSPredicate *predicate = [self predicateForSamplesOnDay:day];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType
                                                       quantitySamplePredicate:predicate
                                                                       options:HKStatisticsOptionCumulativeSum
                                                             completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
                                                                 HKQuantity *sum = [result sumQuantity];
                                                                 NSString *startDate = [self parseUnixTimestampStringFromDate:result.startDate];
                                                                 NSString *endDate = [self parseUnixTimestampStringFromDate:result.endDate];
                                                                 if (completionHandler) {
                                                                     double value = [sum doubleValueForUnit:unit];
                                                                     completionHandler(value, startDate, endDate, error);
                                                                 }
                                                             }];
    
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}


- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                    completion:(void (^)(NSArray *, NSError *))completionHandler {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                     fromDate:[NSDate date]];
    anchorComponents.hour = 0;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    // Create the query
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                           quantitySamplePredicate:nil
                                                                                           options:HKStatisticsOptionCumulativeSum
                                                                                        anchorDate:anchorDate
                                                                                intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",error.localizedDescription);
        }
        
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
        [results enumerateStatisticsFromDate:startDate
                                      toDate:endDate
                                   withBlock:^(HKStatistics *result, BOOL *stop) {
                                       
                                       HKQuantity *quantity = result.sumQuantity;
                                       if (quantity) {
                                           NSDate *date = result.startDate;
                                           double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                                           NSLog(@"%@: %f", date, value);
                                           double timestamp = [date timeIntervalSince1970];
                                           NSArray *elem = @[@{
                                                                 @"timestamp": @(timestamp),
                                                                 @"value": @(value)
                                                                 }];
                                           [data addObject:elem];
                                       }
                                   }];
        NSError *err;
        completionHandler(data, err);
    };
    
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}

- (void)fetchStatisticsCollectionForQuantityType:(HKQuantityType *)qauntityType
                                            unit:(HKUnit *)unit
                                       startDate:(NSDate *)startDate
                                         endDate:(NSDate *)endDate
                                        interval:(NSDateComponents *)interval
                                      completion:(void (^)(NSArray *, NSError *))completionHandler {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
    anchorComponents.minute = 0;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:qauntityType
                                                                           quantitySamplePredicate:nil
                                                                                           options:HKStatisticsOptionCumulativeSum
                                                                                        anchorDate:anchorDate
                                                                                intervalComponents:interval];
    
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***", error.localizedDescription);
        }
        
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
        
        [result enumerateStatisticsFromDate:startDate toDate:endDate withBlock:^(HKStatistics * _Nonnull result, BOOL * _Nonnull stop) {
            HKQuantity *quantity = result.sumQuantity;
            if (quantity) {
                NSDate *startDate = result.startDate;
                NSDate *endDate = result.endDate;
                double value = [quantity doubleValueForUnit:unit];
                
                NSString *startDateString = [self parseUnixTimestampStringFromDate:startDate];
                NSString *endDateString = [self parseUnixTimestampStringFromDate:endDate];
                
                NSDictionary *elem = @{
                                       @"value" : @(value),
                                       @"startDate" : startDateString,
                                       @"endDate" : endDateString,
                                       };
                [data addObject:elem];
            }
        }];
        
        completionHandler(data, error);
    };
    
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}


- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                     ascending:(BOOL)asc
                                         limit:(NSUInteger)lim
                                    completion:(void (^)(NSArray *, NSError *))completionHandler {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                     fromDate:[NSDate date]];
    anchorComponents.hour = 0;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    // Create the query
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                           quantitySamplePredicate:nil
                                                                                           options:HKStatisticsOptionCumulativeSum
                                                                                        anchorDate:anchorDate
                                                                                intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***", error.localizedDescription);
        }
        
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
        
        [results enumerateStatisticsFromDate:startDate
                                      toDate:endDate
                                   withBlock:^(HKStatistics *result, BOOL *stop) {
                                       
                                       HKQuantity *quantity = result.sumQuantity;
                                       if (quantity) {
                                           NSDate *startDate = result.startDate;
                                           NSDate *endDate = result.endDate;
                                           double value = [quantity doubleValueForUnit:unit];
                                           
                                           NSString *startDateString = [self parseUnixTimestampStringFromDate:startDate];
                                           NSString *endDateString = [self parseUnixTimestampStringFromDate:endDate];
                                           
                                           NSDictionary *elem = @{
                                                                  @"value" : @(value),
                                                                  @"startDate" : startDateString,
                                                                  @"endDate" : endDateString,
                                                                  };
                                           [data addObject:elem];
                                       }
                                   }];
        // is ascending by default
        if(asc == false) {
            data = [[[data reverseObjectEnumerator] allObjects] mutableCopy];
        }
        
        if((lim > 0) && ([data count] > lim)) {
            NSArray* slicedArray = [data subarrayWithRange:NSMakeRange(0, lim)];
            NSError *err;
            completionHandler(slicedArray, err);
        } else {
            NSError *err;
            completionHandler(data, err);
        }
    };
    
    if (self.hkStore == nil) {
        self.hkStore = [[HKHealthStore alloc] init];
    }
    [self.hkStore executeQuery:query];
}

@end
