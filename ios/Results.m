//
//  Results.m
//  RNHkit
//
//  Created by HoJun Lee on 2018. 4. 27..
//  Copyright © 2018년 Facebook. All rights reserved.
//

#import "Results.h"
#import "Utils.h"
#import "Queries.h"

@implementation RNHkit (Results)
//- (void)get_data:(NSString *)size completionHandler:(void (^)(NSArray *array))completionHandler {
//    // ...
//    [NSURLConnection sendAsynchronousRequest:url_request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        // ...
//        completionHandler(array);
//        // ...
//    }];
//}

- (void)getBloodGlucoseSamplesWithHKUnit:(HKUnit *)unit startDate:(NSDate *)startDate endDate:(NSDate *)endDate completionHandler:(void (^)(NSArray *array))completionHandler {
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
//    HKUnit *unit = [RNHkit hkUnitFromOptions:input key:@"unit" withDefault:mmoLPerL];
//    NSUInteger limit = [RNHkit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
//    BOOL ascending = [RNHkit boolFromOptions:input key:@"ascending" withDefault:false];
//    NSDate *startDate = [RNHkit dateFromOptions:input key:@"startDate" withDefault:nil];
//    NSDate *endDate = [RNHkit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
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

@end
