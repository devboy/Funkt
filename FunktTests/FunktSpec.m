#import "Kiwi.h"
#import "Funkt.h"

SPEC_BEGIN(FunktSpec)

        describe(@"Funkt", ^
        {

            describe(@"isNull", ^
            {

                it(@"should be null for a nil value", ^
                {
                    BOOL isNull = Funkt.isNull(nil);
                    [[theValue(isNull) should] beTrue];
                });

                it(@"should be null for a NSNull value", ^
                {
                    BOOL isNull = Funkt.isNull([NSNull null]);
                    [[theValue(isNull) should] beTrue];
                });

                it(@"should not be null for a value", ^
                {
                    BOOL isNull = Funkt.isNull(@(5));
                    [[theValue(isNull) should] beFalse];
                });

            });

        });

SPEC_END