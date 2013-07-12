#import "NSDictionary+Funkt.h"
#import "NSArray+Funkt.h"

@implementation NSDictionary (Funkt)

- (BOOL)isEmpty
{
    return !self.count;
}

- (NSArray *)pair
{
    NSMutableArray *array = NSMutableArray.array;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        [array addObject:@[key, obj]];
    }];
    return array;
}

- (NSDictionary *)invert
{
    NSMutableDictionary *dictionary = NSMutableDictionary.dictionary;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        [dictionary setObject:key forKey:obj];
    }];
    return dictionary;
}

- (NSDictionary * (^)(NSArray *))pick
{
    return ^NSDictionary *(NSArray *keys)
    {
        NSMutableDictionary *dictionary = NSMutableDictionary.dictionary;
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            if(keys.contains(key)) [dictionary setObject:obj forKey:key];
        }];
        return dictionary;
    };
}

- (NSDictionary * (^)(NSArray *))omit
{
    return ^NSDictionary *(NSArray *keys)
    {
        NSMutableDictionary *dictionary = NSMutableDictionary.dictionary;
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            if(!keys.contains(key)) [dictionary setObject:obj forKey:key];
        }];
        return dictionary;
    };
}

- (NSDictionary * (^)(NSDictionary *))defaults
{
    return ^NSDictionary *(NSDictionary *defaults)
    {
        NSMutableDictionary *dictionary = [self mutableCopy];
        [defaults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            if(!dictionary[key]) dictionary[key] = obj;
        }];
        return dictionary;
    };
}


@end