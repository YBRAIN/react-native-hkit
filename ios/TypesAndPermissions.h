//
//  TypesAndPermissions.h
//  ReactNativeHealthkit
//
//  Created by HoJun Lee on 2018. 4. 4..
//  Copyright © 2018년 Facebook. All rights reserved.
//

#import "RNHkit.h"

@interface RNHkit (TypesAndPermissions)

+ (NSDictionary *)intervalDict;
+ (NSDictionary *)readPermissionsDict;
+ (NSDictionary *)writePermissionsDict;
- (NSSet *)getReadPermsFromOptions:(NSArray *)options;
- (NSSet *)getWritePermsFromOptions:(NSArray *)options;
- (NSDateComponents *)getIntervalFromString:(NSString *)intervalStr;

@end
