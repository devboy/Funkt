#import <Foundation/Foundation.h>
#import "Option.h"

@interface None : NSObject <Option>
+ (None *)none;
@end