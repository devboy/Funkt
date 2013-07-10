#import "NSArray+Funkt.h"
#import "Option.h"
#import "Funkt.h"
#import "None.h"
#import "Lambda.h"

@implementation NSArray (Funkt)

- (NSObject <Option> *)first
{
    return self.count < 1 ? [None none] : Funkt.option([self objectAtIndex:0]);
}

- (NSObject <Option> *)last
{
    return Funkt.option(self.lastObject);
}

- (NSObject <Option> *)head
{
    return self.first;
}

- (NSArray *)tail
{
    return self.count < 1 ? @[] : [self subarrayWithRange:NSMakeRange(1, self.count-1)];
}

- (NSArray *)flatten
{
    NSMutableArray *array = NSMutableArray.array;
    for(id obj in self)
    {
        if([obj isKindOfClass:NSArray.class])
            [array addObjectsFromArray:((NSArray *)obj).flatten];
        else
            [array addObject:obj];
    }
    return array;
}

- (void (^)(void (^)(id)))each
{
    return ^(void (^eachBlock)(id))
    {
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            eachBlock(obj);
        }];
    };
}

@end