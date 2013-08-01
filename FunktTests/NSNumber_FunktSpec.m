#import "Kiwi.h"
#import "NSNumber+Funkt.h"

SPEC_BEGIN(NSNumber_FunktSpec)

        describe(@"NSNumber+Funkt", ^
        {
            describe(@"times", ^
            {
                it(@"should call the given block the given number of times", ^
                {

                    __block uint called = 0;
                    (@3).times(^
                    {
                        called++;
                    });
                    [[theValue(called) should] equal:theValue(3)];
                });

            });
        });

SPEC_END
