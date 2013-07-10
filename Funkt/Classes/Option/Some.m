#import <Kiwi/KWBlock.h>
#import "Some.h"
#import "None.h"
#import "Funkt.h"
#import "Lambda.h"

@interface Some ()
@property(nonatomic, strong) id value;
@end

@implementation Some

+ (Some *)some:(id)value
{
    return [[Some alloc] initWithValue:value];
}

- (id)initWithValue:(id)value
{
    self = [super init];
    if (self)
    {
        _value = value;
    }

    return self;
}

- (id)get
{
    return self.value;
}

- (id (^)(id))getOrElse
{
    return lambda(_, self.value);
}

- (NSObject <Option> * (^)(id (^mapBlock)(id)))map
{
    return ^NSObject <Option> *(id (^mapBlock)(id))
    {
        return Funkt.option(mapBlock(self.value));
    };
}

- (NSObject <Option> *)flatten
{
    return [self.value isKindOfClass:[Some class]] ? [self.value flatten] : self;
}

- (NSObject <Option> * (^)(id (^flatMapBlock)(id)))flatMap
{
    return ^NSObject <Option> *(id (^flatMapBlock)(id))
    {
        return [self flatten].map(flatMapBlock);
    };
}

- (NSObject <Option> * (^)(BOOL (^filterBlock)(id)))filter
{
    return ^NSObject <Option> *(BOOL (^filterBlock)(id))
    {
        return filterBlock(self.value) ? self : [None none];
    };
}

- (BOOL)isEmpty
{
    return NO;
}

@end