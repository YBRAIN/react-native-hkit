#import "RNHkit.h"

@interface RNHkit (TypesAndPermissions)

+ (NSDictionary *)intervalDict;
+ (NSDictionary *)readPermissionsDict;
+ (NSDictionary *)writePermissionsDict;
- (NSSet *)getReadPermsFromOptions:(NSArray *)options;
- (NSSet *)getWritePermsFromOptions:(NSArray *)options;
- (NSDateComponents *)getIntervalFromString:(NSString *)intervalStr;

@end
