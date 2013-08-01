#import "NSObject+Funkt.h"
#import "EXTScope.h"

@implementation NSObject (Funkt)

- (NSObject * (^)(void (^)(NSObject *)))tap
{
    @weakify(self);
    return ^NSObject *(void (^tapBlock)(NSObject *))
    {
        @strongify(self);
        tapBlock(self);
        return self;
    };
}

@end