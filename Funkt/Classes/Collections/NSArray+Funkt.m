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
        for(id obj in self) [obj performSelector:selector];
    };
}

- (NSArray * (^)(NSString *))pluck
{
    return ^NSArray *(NSString *keyPath)
    {
        return self.map(lambda(o, [o valueForKey:keyPath]));
    };
}

- (NSArray * (^)(NSDictionary *))where
{
    return ^NSArray *(NSDictionary *properties)
    {
        return self.filter(^BOOL(id o)
        {
            for(NSString *key in properties.allKeys)
            {
                id value = [o valueForKey:key];
                if(![value isEqual:properties[key]] && value != properties[key])
                    return NO;
            }
            return YES;
        });
    };
}

- (NSArray *)uniq
{
    return [[NSOrderedSet orderedSetWithArray:self] array];
}

- (NSArray * (^)(NSUInteger))take
{
    return ^NSArray *(NSUInteger n)
    {
        return [self subarrayWithRange:NSMakeRange(0, MIN(n, self.count))];
    };
}

- (NSArray * (^)(NSUInteger))takeRight
{
    return ^NSArray *(NSUInteger n)
    {
        n = MIN(n, self.count);
        return [self subarrayWithRange:NSMakeRange(self.count-n, n)];
    };
}

- (BOOL (^)(id))contains
{
    return ^BOOL(id o)
    {
        return [self containsObject:o];
    };
}

- (NSArray * (^)(NSComparator))sortBy
{
    return ^NSArray *(NSComparator comparator)
    {
        return [self sortedArrayUsingComparator:comparator];
    };
}

- (NSDictionary * (^)(id (^)(id)))countBy
{
    return ^NSDictionary *(id (^countByBlock)(id))
    {
        return self.reduce(@{}, ^id(NSDictionary *dict, id value)
        {
            id by = countByBlock(value);
            NSMutableDictionary *mutableDictionary = dict.mutableCopy;
            if(mutableDictionary[by])
                mutableDictionary[by] = @([mutableDictionary[by] unsignedIntegerValue] + 1);
            else
                mutableDictionary[by] = @1;
            return mutableDictionary;
        });
    };
}

- (NSDictionary * (^)(id (^)(id)))groupBy
{
    return ^NSDictionary *(id (^countByBlock)(id))
    {
        return self.reduce(@{}, ^id(NSDictionary *dict, id value)
        {
            id by = countByBlock(value);
            NSMutableDictionary *mutableDictionary = dict.mutableCopy;
            if(mutableDictionary[by])
                mutableDictionary[by] = [mutableDictionary[by] arrayByAddingObject:value];
            else
                mutableDictionary[by] = @[value];
            return mutableDictionary;
        });
    };
}

- (NSArray *)shuffle
{
    NSMutableArray *array = [self mutableCopy];
    for (NSUInteger i = array.count - 1; i > 0; i--) {
        [array exchangeObjectAtIndex:arc4random() % (i + 1)
                    withObjectAtIndex:i];
    }
    return array;
}

- (NSArray * (^)(NSArray *))without
{
    return ^NSArray *(NSArray *without)
    {
        return self.reduce(@[], ^id(NSArray *array, id value)
        {
            return without.contains(value) ? array : [array arrayByAddingObject:value];
        });
    };
}

- (NSArray * (^)(NSArray *, ...))unionOf
{
    return ^NSArray *(NSArray *array, ...)
    {
        va_list args;
        va_start(args, array);
        NSMutableArray *others = NSMutableArray.array;
        NSArray *value;
        while( value = va_arg( args, NSArray * ) ) [others addObject:value];
        va_end(args);

        return others.reduce(self.uniq, ^id(NSArray *unionized, NSArray *other)
        {
            return [unionized arrayByAddingObjectsFromArray:other.reject(^BOOL(id o)
            {
                return unionized.contains(o);
            })];
        });
    };
}


@end