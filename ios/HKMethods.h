//
//  HKMethods.h
//  ReactNativeHealthkit
//
//  Created by HoJun Lee on 2018. 4. 4..
//  Copyright © 2018년 Facebook. All rights reserved.
//

#import "RNHkit.h"

@interface RNHkit (HKMethods)

// Characteristic
/*
 FitzpatrickSkin
 TypeI 햇볕에 항상 쉽게 화상을 입히고 볕에 타지 않는 하얀 피부.
 TypeII 쉽게 화상을 입으며 최소한의 탄력있는 흰색 피부.
 TypeIII 적당히 화상을 입히고 균일하게 태우는 밝은 갈색 피부.
 TypeIV Beige-olive, 가볍게 태닝 한 피부. 최소한의 화상과 적당히 탄.
 TypeV 거의 화상을 입지 않고 무미건조 한 갈색 피부.
 TypeVI 결코 화상을 입지 않고 검은 색 피부에 검은 갈색의 피부.
 */
// - (void)getFitzpatrickSkinWithCallback:(RCTResponseSenderBlock)callback;


// Total
- (void)getAllActivityDatas:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;

// Results
- (void)getBloodGlucoseSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;


// Vitals
//- (void)vitals_getHeartRateSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)vitals_getBodyTemperatureSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)vitals_getBloodPressureSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)vitals_getRespiratoryRateSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;

// Body
//- (void)body_getLatestWeight:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)body_getWeightSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)body_getLatestBodyMassIndex:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)body_getLatestHeight:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)body_getHeightSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)body_getLatestBodyFatPercentage:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)body_getLatestLeanBodyMass:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;

// Fitness
//- (void)fitness_getStepCountOnDay:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)fitness_getDailyStepSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)fitness_getDistanceWalkingRunningOnDay:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)fitness_getDistanceCyclingOnDay:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//- (void)fitness_getFlightsClimbedOnDay:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;

// Sleep
//- (void)sleep_getSleepSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
//


@end
