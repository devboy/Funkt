#import "Kiwi.h"
#import "NSDictionary+Funkt.h"

SPEC_BEGIN(NSDictionary_FunktSpec)

        describe(@"NSDictionary+Funkt", ^
        {

            describe(@"isEmpty", ^
            {

                it(@"should be YES for an empty dictionary", ^
                {
                    [[theValue(@{}.isEmpty) should] beTrue];
                });

                it(@"should be NO for a non-empty dictionary", ^
                {
                    [[theValue(@{@"a":@"1"}.isEmpty) should] beFalse];
                });

            });

            describe(@"pair", ^
            {
                it(@"should create an array with key and value subarrays", ^
                {
                    NSDictionary *dictionary = @{@"a":@1,@"b":@2,@"c":@3};
                    NSArray *expected = @[@[@"a",@1],@[@"b",@2],@[@"c",@3]];
                    [[dictionary.pair should] equal:expected];
                });
            });

            describe(@"invert", ^
            {
                it(@"should swap keys and values", ^
                {
                    NSDictionary *dictionary = @{@"a":@1,@"b":@2,@"c":@3};
                    NSDictionary *expected = @{@1:@"a",@2:@"b",@3:@"c"};
                    [[dictionary.invert should] equal:expected];
                });
            });

            describe(@"pick", ^
            {
                it(@"should create a new dictionary containing only the pairs for the given keys", ^
                {
                    NSDictionary *dictionary = @{@"a":@1,@"b":@2,@"c":@3};
                    NSDictionary *expected = @{@"a":@1,@"c":@3};
                    [[dictionary.pick(@[@"a",@"c"]) should] equal:expected];
                });
            });

            describe(@"omit", ^
            {
                it(@"should create a new dictionary omitting the pairs for the given keys", ^
                {
                    NSDictionary *dictionary = @{@"a":@1,@"b":@2,@"c":@3};
                    NSDictionary *expected = @{@"a":@1,@"c":@3};
                    [[dictionary.omit(@[@"b"]) should] equal:expected];
                });
            });

            describe(@"defaults", ^
            {
                it(@"should create a new dictionary setting the default values", ^
                {
                    NSDictionary *dictionary = @{@"a":@1,@"b":@2,@"c":@3};
                    NSDictionary *defaults = @{@"d":@4, @"e":@5};
                    NSDictionary *expected = @{@"a":@1,@"b":@2,@"c":@3,@"d":@4, @"e":@5};
                    [[dictionary.defaults(defaults) should] equal:expected];
                });

                it(@"should create a new dictionary but not override existing pairs", ^
                {
                    NSDictionary *dictionary = @{@"a":@1,@"b":@2,@"c":@3};
                    NSDictionary *defaults = @{@"a":@5};
                    NSDictionary *expected = @{@"a":@1,@"b":@2,@"c":@3};
                    [[dictionary.defaults(defaults) should] equal:expected];
                });
            });

        });

SPEC_END
