#import "None.h"
#import "Lambda.h"

@implementation None

+ (None *)none
{
    static None *_none = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _none = [[None alloc] init];
    });
    return _none;
}

- (id)get
{
    [NSException raise:@"Not supported." format:@"Not supported."];
}

- (id (^)(id))getOrElse
{
    return lambda(defaultValue, defaultValue);
}

- (NSObject <Option> * (^)(id (^mapBlock)(id)))map
{
    return ^NSObject <Option> *(id (^mapBlock)(id))
    {
        return [None none];
    };
}

- (NSObject <Option> *)flatten
{
    return [None none];
}

- (NSObject <Option> * (^)(id (^flatMapBlock)(id)))flatMap
{
    return ^NSObject <Option> *(id (^flatMapBlock)(id))
    {
        return [None none];
    };
}

- (NSObject <Option> * (^)(BOOL (^filterBlock)(id)))filter
{
    return ^NSObject <Option> *(BOOL (^filterBlock)(id))
    {
        return [None none];
    };
}

- (BOOL)isEmpty
{
    return YES;
}


@end