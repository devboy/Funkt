#import "NSArray+Funkt.h"
#import "Option.h"
#import "Funkt.h"
#import "None.h"
#import "Lambda.h"
#import "EXTScope.h"

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
    @weakify(self);
    return ^(void (^eachBlock)(id))
    {
        @strongify(self);
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            eachBlock(obj);
        }];
    };
}

- (NSArray * (^)(id (^)(id)))map
{
    @weakify(self);
    return ^NSArray *(id (^mapBlock)(id))
    {
        @strongify(self);
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
    @weakify(self);
    return ^id(id accumulator, id (^reduceBlock)(id, id) )
    {
        @strongify(self);
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
    @weakify(self);
    return ^NSObject <Option> *(BOOL (^findBlock)(id value))
    {
        @strongify(self);
        for(id obj in self) if(findBlock(obj)) return Funkt.option(obj);
        return None.none;
    };
}

- (BOOL (^)(BOOL (^)(id)))any
{
    @weakify(self);
    return ^BOOL(BOOL (^anyBlock)(id) )
    {
        @strongify(self);
        return self.find(anyBlock) != None.none;
    };
}

- (BOOL)isEmpty
{
    return !self.count;
}

- (BOOL (^)(BOOL (^)(id)))all
{
    @weakify(self);
    return ^BOOL(BOOL (^allBlock)(id) )
    {
        @strongify(self);
        if(self.isEmpty) return NO;
        for(id obj in self) if(!allBlock(obj)) return NO;
        return YES;
    };
}

- (NSArray * (^)(BOOL (^)(id)))filter
{
    @weakify(self);
    return ^NSArray *(BOOL (^filterBlock)(id))
    {
        @strongify(self);
        NSMutableArray *array = NSMutableArray.array;
        for(id obj in self) if(filterBlock(obj)) [array addObject:obj];
        return array;
    };
}

- (NSArray * (^)(BOOL (^)(id)))reject
{
    @weakify(self);
    return ^NSArray *(BOOL (^rejectBlock)(id) )
    {
        @strongify(self);
        NSMutableArray *array = NSMutableArray.array;
        for(id obj in self) if(!rejectBlock(obj)) [array addObject:obj];
        return array;
    };
}

- (void (^)(SEL, NSArray *))invoke
{
    @weakify(self);
    return ^(SEL selector, NSArray *array)
    {
        @strongify(self);
        [self makeObjectsPerformSelector:selector];
    };
}

- (NSArray * (^)(NSString *))pluck
{
    @weakify(self);
    return ^NSArray *(NSString *keyPath)
    {
        @strongify(self);
        return [self valueForKeyPath:keyPath];
    };
}

- (NSArray * (^)(NSDictionary *))where
{
    @weakify(self);
    return ^NSArray *(NSDictionary *properties)
    {
        @strongify(self);
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
    @weakify(self);
    return ^NSArray *(NSUInteger n)
    {
        @strongify(self);
        return [self subarrayWithRange:NSMakeRange(0, MIN(n, self.count))];
    };
}

- (NSArray * (^)(NSUInteger))takeRight
{
    @weakify(self);
    return ^NSArray *(NSUInteger n)
    {
        @strongify(self);
        n = MIN(n, self.count);
        return [self subarrayWithRange:NSMakeRange(self.count-n, n)];
    };
}

- (BOOL (^)(id))contains
{
    @weakify(self);
    return ^BOOL(id o)
    {
        return [self containsObject:o];
    };
}

- (NSArray * (^)(NSComparator))sortBy
{
    @weakify(self);
    return ^NSArray *(NSComparator comparator)
    {
        @strongify(self);
        return [self sortedArrayUsingComparator:comparator];
    };
}

- (NSDictionary * (^)(id (^)(id)))countBy
{
    @weakify(self);
    return ^NSDictionary *(id (^countByBlock)(id))
    {
        @strongify(self);
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
    @weakify(self);
    return ^NSDictionary *(id (^countByBlock)(id))
    {
        @strongify(self);
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
    @weakify(self);
    return ^NSArray *(NSArray *without)
    {
        @strongify(self);
        return self.reduce(@[], ^id(NSArray *array, id value)
        {
            return without.contains(value) ? array : [array arrayByAddingObject:value];
        });
    };
}

- (NSArray * (^)(NSArray *, ...))unionOf
{
    @weakify(self);
    return ^NSArray *(NSArray *first, ...)
    {
        @strongify(self);

        va_list args;
        va_start(args, first);
        NSMutableArray *others = [NSMutableArray arrayWithObject:first];
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

- (NSArray * (^)(NSArray *, ...))intersectionOf
{
    @weakify(self);
    return ^NSArray *(NSArray *array, ...)
    {
        @strongify(self);

        va_list args;
        va_start(args, array);
        NSMutableArray *arrays = [NSMutableArray arrayWithObjects:array,self,nil];
        NSArray *value;
        while( value = va_arg( args, NSArray * ) ) [arrays addObject:value];
        va_end(args);

        return arrays.reduce(@[], ^NSArray *(NSArray *intersections, NSArray *other)
        {
            return [intersections arrayByAddingObjectsFromArray:other.filter(^BOOL(id o)
            {
                return !intersections.contains(o) && arrays.all(^BOOL(NSArray *otherArray)
                            {
                                return otherArray.contains(o);
                            });
            })];
        });
    };
}

- (NSArray * (^)(NSArray *, ...))differenceOf
{
    @weakify(self);
    return ^NSArray *(NSArray *array, ...)
    {
        @strongify(self);

        va_list args;
        va_start(args, array);
        NSMutableArray *arrays = [NSMutableArray arrayWithObjects:array,self,nil];
        NSArray *value;
        while( value = va_arg( args, NSArray * ) ) [arrays addObject:value];
        va_end(args);

        return arrays.reduce(@[], ^NSArray *(NSArray *intersections, NSArray *other)
        {
            return [intersections arrayByAddingObjectsFromArray:other.filter(^BOOL(id o)
            {
                return !intersections.contains(o) && arrays.filter(^BOOL(NSArray *otherArray)
                {
                    return otherArray.contains(o);
                }).count == 1;
            })];
        });
    };
}

- (NSArray *)reverse
{
    return self.reverseObjectEnumerator.allObjects;
}

- (NSArray * (^)(NSArray *, ...))zipWith
{
    @weakify(self);
    return ^NSArray *(NSArray *array, ...)
    {
        @strongify(self);

        va_list args;
        va_start(args, array);
        NSMutableArray *arrays = [NSMutableArray arrayWithObjects:self,array,nil];
        NSArray *value;
        while( value = va_arg( args, NSArray * ) )
        {
            [arrays addObject:value];
        }
        va_end(args);

        NSNumber *max = arrays.reduce(@0, ^NSNumber *(NSNumber *acc, NSArray *array)
        {
            return acc.unsignedIntegerValue >= array.count ? acc : @(array.count);
        });
        NSMutableArray *zipped = [NSMutableArray array];
        for (uint i = 0; i < max.unsignedIntegerValue; i++)
        {
            [zipped addObject:arrays.map(^NSObject <Option>*(NSArray *array)
            {
                return array.nth(i);
            })
            .compact
            .pluck(@"get")];
        }
        return zipped;
    };
}

- (NSObject <Option> * (^)(NSUInteger))nth
{
    @weakify(self);
    return ^NSObject <Option> *(NSUInteger i)
    {
        @strongify(self);
        return self.count >= i+1 ? Funkt.option([self objectAtIndex:i]) : [None none];
    };
}

- (NSArray *)compact
{
    return self.reject(^BOOL(id o)
    {
        return Funkt.isNull(o);
    });
}
@end