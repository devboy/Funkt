#import "Kiwi.h"
#import "NSObject+Funkt.h"

SPEC_BEGIN(NSObject_FunktSpec)

        describe(@"NSObject+Funkt", ^
        {
            describe(@"tap", ^
            {
                it(@"should call the given block", ^
                {
                    NSObject *object = [[NSObject alloc] init];
                    __block BOOL called = NO;
                    object.tap(^(NSObject *o)
                    {
                        called = YES;
                    });
                    [[theValue(called) should] beTrue];
                });

                it(@"should pass itself into the given block", ^
                {
                    NSObject *object = [[NSObject alloc] init];
                    object.tap(^(NSObject *o)
                    {
                        [[o should] equal:object];
                    });
                });
            });
        });

SPEC_END
