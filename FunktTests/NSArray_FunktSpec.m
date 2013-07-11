#import "Kiwi.h"
#import "NSArray+Funkt.h"
#import "Option.h"
#import "Some.h"
#import "None.h"
#import "Lambda.h"

SPEC_BEGIN(NSArray_FunktSpec)

        describe(@"NSArray+Funkt", ^
        {

            describe(@"first", ^
            {

                it(@"should return the first value as some", ^
                {
                    NSNumber *firstValue = @5;
                    NSArray *array = @[firstValue];
                    [[array.first should] beKindOfClass:Some.class];
                    [[array.first.get should] equal:firstValue];
                });

                it(@"should return none when empty", ^
                {
                    [[@[].first should] equal:None.none];
                });

            });

            describe(@"head", ^
            {

                it(@"should return the first value as some", ^
                {
                    NSNumber *firstValue = @5;
                    NSArray *array = @[firstValue];
                    [[array.head should] beKindOfClass:Some.class];
                    [[array.head.get should] equal:firstValue];
                });

                it(@"should return none when empty", ^
                {
                    [[@[].head should] equal:None.none];
                });

            });

            describe(@"last", ^
            {

                it(@"should return the last value as some", ^
                {
                    NSNumber *lastValue = @5;
                    NSArray *array = @[@0,lastValue];
                    [[array.last should] beKindOfClass:Some.class];
                    [[array.last.get should] equal:lastValue];
                });

                it(@"should return none when empty", ^
                {
                    [[@[].last should] equal:None.none];
                });

            });

            describe(@"tail", ^
            {

                it(@"should return the values except first as array", ^
                {
                    NSArray *lastValues = @[@5,@6,@7];
                    NSArray *array = [@[@0] arrayByAddingObjectsFromArray:lastValues];
                    [[array.tail should] beKindOfClass:NSArray.class];
                    [[array.tail should] containObjectsInArray:lastValues];
                });

                it(@"should return empty array when empty", ^
                {
                    [[@[].tail should] beEmpty];
                });

            });

            describe(@"flatten", ^
            {

                it(@"should return the same values if flat already", ^
                {
                    NSArray *array = @[@1,@2,@3];
                    [array.flatten shouldNotBeNil];
                    [[array.flatten should] containObjectsInArray:array];
                });

                it(@"should flatten nested arrays", ^
                {
                    NSArray *array = @[@1,@[@2,@[@3]],@4];
                    [array.flatten shouldNotBeNil];
                    [[array.flatten should] containObjectsInArray:@[@1,@2,@3,@4]];
                });

            });

            describe(@"each", ^
            {
                it(@"should iterate each value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *eached = NSMutableArray.array;
                    array.each(^(id o)
                    {
                        [eached addObject:o];
                    });
                    [eached shouldNotBeNil];
                    [[eached should] containObjectsInArray:array];
                });

            });

            describe(@"map", ^
            {

                it(@"should iterate each value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *mapped = NSMutableArray.array;
                    array.map(^id(id o)
                    {
                        [mapped addObject:o];
                        return o;
                    });
                    [mapped shouldNotBeNil];
                    [[mapped should] containObjectsInArray:array];
                });

                it(@"should return a new array with the results of the mapBlock", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *expected = NSMutableArray.array;
                    for(NSNumber *number in array) [expected addObject:[number stringValue]];
                    NSArray *mapped = array.map(lambda(o, [o stringValue]));
                    [mapped shouldNotBeNil];
                    [[mapped should] containObjectsInArray:expected];
                });

            });

            describe(@"reduce", ^
            {

                it(@"should iterate each value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *reduced = NSMutableArray.array;
                    array.reduce(@0, ^id(id accumulator, id value)
                    {
                        [reduced addObject:value];
                        return accumulator;
//                        return @([accumulator intValue] + [value intValue]);
                    });
                    [reduced shouldNotBeNil];
                    [[reduced should] containObjectsInArray:array];
                });

                it(@"should return a reduced value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSNumber *expected = @15;
                    NSNumber *reduced = array.reduce(@0, ^id(id accumulator, id value)
                    {
                        return @([accumulator intValue] + [value intValue]);
                    });
                    [reduced shouldNotBeNil];
                    [[reduced should] equal:expected];
                });

            });

            describe(@"find", ^
            {

                it(@"should iterate each value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *iterated = NSMutableArray.array;
                    array.find(^BOOL(id o)
                    {
                        [iterated addObject:o];
                        return NO;
                    });
                    [iterated shouldNotBeNil];
                    [[iterated should] containObjectsInArray:array];
                });

                it(@"should return the first occurence of the value as some", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSNumber *expected = @3;
                    NSObject <Option> *found =  array.find(^BOOL(id o)
                    {
                        return o == expected;
                    });
                    [found shouldNotBeNil];
                    [[found should] beKindOfClass:Some.class];
                    [[found.get should] equal:expected];
                });

                it(@"should return none if the value is not found", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSNumber *expected = @6;
                    NSObject <Option> *found =  array.find(^BOOL(id o)
                    {
                        return o == expected;
                    });
                    [found shouldNotBeNil];
                    [[found should] equal:None.none];
                });

            });

            describe(@"any", ^
            {

                it(@"should iterate each value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *iterated = NSMutableArray.array;
                    BOOL (^any1)(BOOL (^)(id)) = array.any;
                    any1(^BOOL(id o)
                    {
                        [iterated addObject:o];
                        return NO;
                    });
                    [iterated shouldNotBeNil];
                    [[iterated should] containObjectsInArray:array];
                });

                it(@"should return yes if the value is found", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    BOOL (^any1)(BOOL (^)(id)) = array.any;
                    [[theValue(any1(^BOOL(id o)
                    {
                        return [o isEqualToNumber:@1];
                    })) should] beYes];
                });

                it(@"should return no if the value is not found", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    BOOL (^any1)(BOOL (^)(id)) = array.any;
                    [[theValue(any1(^BOOL(id o)
                    {
                        return [o isEqualToNumber:@6];
                    })) should] beNo];
                });

                it(@"should return no for an empty array", ^
                {
                    BOOL (^any1)(BOOL (^)(id)) = @[].any;
                    [[theValue(any1(^BOOL(id o)
                    {
                        return [o isKindOfClass:NSNumber.class];
                    })) should] beNo];
                });

            });

            describe(@"isEmpty", ^
            {

                it(@"should be empty when array is empty", ^
                {
                    [[theValue(@[].isEmpty) should] beTrue];
                });

                it(@"should not be empty when array is not empty", ^
                {
                    [[theValue((@[@1,@2]).isEmpty) should] beFalse];
                });

            });

            describe(@"all", ^
            {

                it(@"should iterate each value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *iterated = NSMutableArray.array;
                    array.all(^BOOL(id o)
                    {
                        [iterated addObject:o];
                        return YES;
                    });
                    [iterated shouldNotBeNil];
                    [[iterated should] containObjectsInArray:array];
                });

                it(@"should return yes if all values are matching", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    [[theValue(array.all(^BOOL(id o)
                    {
                        return [o isKindOfClass:NSNumber.class];
                    })) should] beYes];
                });

                it(@"should return no if one or more of values is not matching", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5, @"6"];
                    [[theValue(array.all(^BOOL(id o)
                    {
                        return [o isKindOfClass:NSNumber.class];
                    })) should] beNo];
                });

                it(@"should return no for an empty array", ^
                {
                    [[theValue(@[].all(^BOOL(id o)
                    {
                        return [o isKindOfClass:NSNumber.class];
                    })) should] beNo];
                });

            });

            describe(@"filter", ^
            {
                it(@"should iterate each value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *iterated = NSMutableArray.array;
                    array.filter(^BOOL(id o)
                    {
                        [iterated addObject:o];
                        return YES;
                    });
                    [iterated shouldNotBeNil];
                    [[iterated should] containObjectsInArray:array];
                });

                it(@"should filter out the values which do not match", ^
                {
                    NSArray *array = @[@1,@2,@3,@"4",@"5"];
                    NSArray *expected = @[@1,@2,@3];
                    NSArray *filtered = array.filter(^BOOL(id o)
                    {
                        return [o isKindOfClass:NSNumber.class];
                    });
                    [filtered shouldNotBeNil];
                    [[filtered should] containObjectsInArray:expected];
                });
            });

            describe(@"reject", ^
            {
                it(@"should iterate each value", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *iterated = NSMutableArray.array;
                    array.reject(^BOOL(id o)
                    {
                        [iterated addObject:o];
                        return YES;
                    });
                    [iterated shouldNotBeNil];
                    [[iterated should] containObjectsInArray:array];
                });

                it(@"should reject(filter out) the values which do match", ^
                {
                    NSArray *array = @[@1,@2,@3,@"4",@"5"];
                    NSArray *expected = @[@"4",@"5"];
                    NSArray *filtered = array.reject(^BOOL(id o)
                    {
                        return [o isKindOfClass:NSNumber.class];
                    });
                    [filtered shouldNotBeNil];
                    [[filtered should] containObjectsInArray:expected];
                });
            });

            describe(@"invoke", ^
            {
                it(@"should execute selector on each value", ^
                {
                    NSArray *array = @[[NSNumber mock],[NSNumber mock],[NSNumber mock],[NSNumber mock],[NSNumber mock]];
                    array.each(^(id o)
                    {
                        [[[o should] receive] stringValue];
                    });
                    array.invoke(@selector(stringValue),@[]);
                });
            });

            describe(@"pluck", ^
            {
                 it(@"should return a new array with the results of the plucked values as some", ^
                {
                    NSArray *array = @[@1,@2,@3,@4,@5];
                    NSMutableArray *expected = NSMutableArray.array;
                    for(NSNumber *number in array) [expected addObject:[number stringValue]];
                    NSArray *plucked = array.pluck(@"stringValue");
                    [plucked shouldNotBeNil];
                    [[plucked should] containObjectsInArray:expected];
                });
            });

        });

SPEC_END
