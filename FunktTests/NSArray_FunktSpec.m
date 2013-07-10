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

        });

SPEC_END