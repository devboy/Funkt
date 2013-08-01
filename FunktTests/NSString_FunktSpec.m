#import "Kiwi.h"
#import "NSString+Funkt.h"

SPEC_BEGIN(NSString_FunktSpec)

        describe(@"NSString+Funkt", ^
        {

            describe(@"capitalize", ^
            {
                it(@"should capitalize the first character", ^
                {
                    NSString *string = @"hugo";
                    NSString *expected = @"Hugo";
                    [[string.capitalize should] equal:expected];
                });
            });

        });

SPEC_END