#import "NSNumber+Funkt.h"


@implementation NSNumber (Funkt)

- (void (^)(void (^)()))times
{
    return ^(void (^block)())
    {
        for (int i = 0; i < self.unsignedIntegerValue; i++)
            block();
    };
}


@end