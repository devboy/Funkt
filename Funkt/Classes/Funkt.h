#import <Foundation/Foundation.h>
#import "Option.h"

@interface Funkt : NSObject
+ (BOOL (^)(id value))isNull;
+ (NSObject <Option> * (^)(id))option;
@end