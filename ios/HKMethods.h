//
//  HKMethods.h
//  ReactNativeHealthkit
//
//  Created by HoJun Lee on 2018. 4. 4..
//  Copyright © 2018년 Facebook. All rights reserved.
//

#import "RNHkit.h"

@interface RNHkit (HKMethods)

// Results
- (void)getBloodGlucoseSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;


// Vitals
- (void)getHeartRateSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getBodyTemperatureSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getBloodPressureSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getRespiratoryRateSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

// Body
- (void)getLatestWeight:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getWeightSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getLatestBodyMassIndex:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getLatestHeight:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getHeightSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getLatestBodyFatPercentage:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getLatestLeanBodyMass:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

// Fitness
- (void)getStepCountOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getDailyStepSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getDistanceWalkingRunningOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getDistanceCyclingOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)getFlightsClimbedOnDay:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

// Sleep
- (void)getSleepSamples:(NSDictionary *)input Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

@end
