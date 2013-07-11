#import "NSArray+Funkt.h"
#import "Option.h"
#import "Funkt.h"
#import "None.h"
#import "Lambda.h"

@implementation NSArray (Funkt)

- (NSObject <Option> *)first
{
    return self.isEmpty ? [None none] : Funkt.option([self objectAtIndex:0]);
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
    return self.isEmpty ? @[] : [self subarrayWithRange:NSMakeRange(1, self.count-1)];
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

- (NSArray * (^)(id (^)(id)))map
{
    return ^NSArray *(id (^mapBlock)(id))
    {
        NSMutableArray *array = NSMutableArray.array;
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            [array addObject:mapBlock(obj)];
        }];
        return array;
    };
}

- (id (^)(id, id (^)(id, id)))reduce
{
    return ^id(id accumulator, id (^reduceBlock)(id, id) )
    {
        __block id acc = accumulator;
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            acc = reduceBlock(acc, obj);
        }];
        return acc;
    };
}

- (NSObject <Option> * (^)(BOOL (^)(id)))find
{
    return ^NSObject <Option> *(BOOL (^findBlock)(id value))
    {
        for(id obj in self) if(findBlock(obj)) return Funkt.option(obj);
        return None.none;
    };
}

- (BOOL (^)(BOOL (^)(id)))any
{
    return ^BOOL(BOOL (^anyBlock)(id) )
    {
        return self.find(anyBlock) != None.none;
    };
}

- (BOOL)isEmpty
{
    return !self.count;
}

- (BOOL (^)(BOOL (^)(id)))all
{
    return ^BOOL(BOOL (^allBlock)(id) )
    {
        if(self.isEmpty) return NO;
        for(id obj in self) if(!allBlock(obj)) return NO;
        return YES;
    };
}

- (NSArray * (^)(BOOL (^)(id)))filter
{
    return ^NSArray *(BOOL (^filterBlock)(id))
    {
        NSMutableArray *array = NSMutableArray.array;
        for(id obj in self) if(filterBlock(obj)) [array addObject:obj];
        return array;
    };
}

- (NSArray * (^)(BOOL (^)(id)))reject
{
    return ^NSArray *(BOOL (^rejectBlock)(id) )
    {
        NSMutableArray *array = NSMutableArray.array;
        for(id obj in self) if(!rejectBlock(obj)) [array addObject:obj];
        return array;
    };
}

- (void (^)(SEL, NSArray *))invoke
{
    return ^(SEL selector, NSArray *array)
    {
        for(id obj in self)
        {
            [(NSObject *)obj performSelector:selector];
        }
    };
}


@end