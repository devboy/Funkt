#import <Foundation/Foundation.h>
#import "Option.h"

@interface Some : NSObject <Option>
+ (Some *)some:(id)value;
@end