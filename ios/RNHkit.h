
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <React/RCTUtils.h>
#import <React/RCTLog.h>
#import <React/RCTEventDispatcher.h>

@import HealthKit;

@interface RNHkit : NSObject <RCTBridgeModule>
@property (nonatomic) HKHealthStore *hkStore;
@end
  
