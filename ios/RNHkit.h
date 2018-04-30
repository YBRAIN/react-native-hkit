
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <React/RCTUtils.h>
#import <React/RCTLog.h>
#import <React/RCTEventDispatcher.h>

@import HealthKit;

// declare the block
typedef void (^handlerResponseBlock)(NSArray *results, NSError *error);

@interface RNHkit : NSObject <RCTBridgeModule>

@property (nonatomic) HKHealthStore *hkStore;
@property (nonatomic, strong) handlerResponseBlock responseBlock;

@end
  
