#import "NSObject+Funkt.h"


@implementation NSObject (Funkt)

- (NSObject * (^)(void (^)(NSObject *)))tap
{
    return ^NSObject *(void (^tapBlock)(NSObject *))
    {
        tapBlock(self);
        return self;
    };
}

@end