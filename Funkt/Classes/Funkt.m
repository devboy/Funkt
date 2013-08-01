#import "Funkt.h"
#import "None.h"
#import "Some.h"

@implementation Funkt

+ (BOOL (^)(id value))isNull
{
    return ^ BOOL (id value)
    {
        return value == nil || [value isKindOfClass:[NSNull class]] || value == [None none];
    };
}

+ (NSObject <Option> * (^)(id))option
{
    return ^NSObject <Option> *(id value)
    {
        return Funkt.isNull(value) ? [None none] : [Some some:value];
    };
}
@end