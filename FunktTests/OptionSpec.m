#import "Kiwi.h"
#import "Option.h"
#import "None.h"
#import "Some.h"
#import "Funkt.h"
#import "Lambda.h"

SPEC_BEGIN(OptionSpec)

        describe(@"Option", ^
        {

            context(@"when not given a value", ^
            {
                it(@"should return 'None'", ^
                {
                    NSObject <Option> * value = Funkt.option(nil);
                    [value shouldNotBeNil];
                    [[value should] beKindOfClass:[None class]];
                });

                it(@"should return 'None' for a NSNull value", ^
                {
                    NSObject <Option> * value = Funkt.option([NSNull null]);
                    [value shouldNotBeNil];
                    [[value should] beKindOfClass:[None class]];
                });

            });

            context(@"when given a value", ^
            {
                it(@"should return 'Some'", ^
                {
                    NSObject <Option> * value = Funkt.option(@(5));
                    [value shouldNotBeNil];
                    [[value should] beKindOfClass:[Some class]];
                });

                it(@"should get given the value", ^
                {
                    NSNumber *value = @(5);
                    NSObject <Option> * option = Funkt.option(value);
                    id getValue = [option get];
                    [getValue shouldNotBeNil];
                    [[getValue should] equal:value];
                });
            });

        });

        describe(@"Some", ^
        {
            it(@"should raise an exception when initialized with a nil value", ^
            {
                [[theBlock(^
                {
                    [Some some:nil];
                }) should] raise];
                [[theBlock(^
                {
                    [Some some:[NSNull null]];
                }) should] raise];
                [[theBlock(^
                {
                    [Some some:[None none]];
                }) should] raise];
            });

            it(@"should get the given value", ^
            {
                NSNumber *value = @5;
                Some *some = [Some some:value];
                [[[some get] should] equal:value];
            });

            it(@"should get the given value not the default", ^
            {
                NSNumber *value = @5;
                Some *some = [Some some:value];
                [[some.getOrElse(@7) should] equal:value];
            });

            it(@"should return some with the mapped value", ^
            {
                NSNumber *value = @5;
                Some *some = [Some some:value];
                NSObject <Option>*mappedValue = some.map(^id(id value)
                {
                    return [value stringValue];
                });
                [mappedValue shouldNotBeNil];
                [[mappedValue should] beKindOfClass:[Some class]];
                [[[mappedValue get] should] equal:[value stringValue]];
            });

            it(@"should return none if the mapped value is nil", ^
            {
                NSNumber *value = @5;
                Some *some = [Some some:value];
                NSObject <Option>*mappedValue = some.map(^id(id value)
                {
                    return nil;
                });
                [mappedValue shouldNotBeNil];
                [[mappedValue should] equal:[None none]];
            });

            it(@"should return self when no flattening is possible", ^
            {
                NSNumber *value = @5;
                Some *some = [Some some:value];
                NSObject <Option>*flattened = some.flatten;
                [flattened shouldNotBeNil];
                [[flattened should] equal:some];
            });

            it(@"should return last some when flattening is possible", ^
            {
                Some *innerSome = [Some some:@5];
                Some *outerSome = [Some some:innerSome];
                NSObject <Option>*flattened = outerSome.flatten;
                [flattened shouldNotBeNil];
                [[flattened should] equal:innerSome];
            });

            it(@"should return some with value of inner some when flatMapped", ^
            {
                NSNumber *value = @5;
                Some *innerSome = [Some some:value];
                Some *outerSome = [Some some:innerSome];
                NSObject <Option>*flatMappedValue = outerSome.flatMap(lambda(x,[x stringValue]));
                [flatMappedValue shouldNotBeNil];
                [[[flatMappedValue get] should] equal:[value stringValue]];
            });

            it(@"should return self when filter applies", ^
            {
                Some *some = [Some some:@5];
                NSObject <Option>*filtered = some.filter(^BOOL(id value)
                {
                    return YES;
                });
                [filtered shouldNotBeNil];
                [[filtered should] equal:some];
            });

            it(@"should return none when filter doesn't apply", ^
            {
                Some *some = [Some some:@5];
                NSObject <Option>*filtered = some.filter(^BOOL(id value)
                {
                    return NO;
                });
                [filtered shouldNotBeNil];
                [[filtered should] equal:[None none]];
            });

            it(@"should not be empty", ^
            {
                [[theValue([Some some:@1].isEmpty) should] beFalse];
            });

        });

        describe(@"None", ^
        {
            it(@"should throw an exception when trying to get a value", ^
            {
                [[theBlock(^{[[None none] get];}) should] raise];
            });

            it(@"should get the default value", ^
            {
                NSNumber *defaultValue = @5;
                None *none = [None none];
                id orElse = none.getOrElse(defaultValue);
                [orElse shouldNotBeNil];
                [[orElse should] equal:defaultValue];
            });

            it(@"should return none when mapped", ^
            {
                NSObject <Option>* mappedValue = None.none.map(^id(id o)
                {
                    return @5;
                });
                [mappedValue shouldNotBeNil];
                [[mappedValue should] equal:[None none]];
            });

            it(@"should return none when flattened", ^
            {
                NSObject <Option>*flattened = None.none.flatten;
                [flattened shouldNotBeNil];
                [[flattened should] equal:[None none]];
            });

            it(@"should return none when flatMapped", ^
            {
                NSObject <Option>*flatMapped = None.none.flatMap(^id(id value) { return @5; });
                [flatMapped shouldNotBeNil];
                [[flatMapped should] equal:[None none]];
            });

            it(@"should return none when filtered", ^
            {
                NSObject <Option>*filtered = None.none.filter(^BOOL(id value) { return YES; });
                [filtered shouldNotBeNil];
                [[filtered should] equal:[None none]];
            });

            it(@"should be empty", ^
            {
                [[theValue(None.none.isEmpty) should] beTrue];
            });
        });

SPEC_END