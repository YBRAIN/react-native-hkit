//
//  Results.h
//  RNHkit
//
//  Created by HoJun Lee on 2018. 4. 27..
//  Copyright © 2018년 Facebook. All rights reserved.
//

#import "RNHkit.h"

@interface RNHkit (Results)

- (void)getBloodGlucoseSamplesWithHKUnit:(HKUnit *)unit startDate:(NSDate *)startDate endDate:(NSDate *)endDate completionHandler:(void (^)(NSArray *array))completionHandler;

@end
