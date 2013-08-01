#import <Foundation/Foundation.h>

@interface NSNumber (Funkt)
@property (readonly) void (^times)(void (^block)(void));
@end