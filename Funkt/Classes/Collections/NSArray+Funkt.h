#import <Foundation/Foundation.h>

@protocol Option;

@interface NSArray (Funkt)
@property (readonly) NSObject <Option>* first;
@property (readonly) NSObject <Option>* last;
@property (readonly) NSObject <Option>* head;
@property (readonly) NSArray *tail;
@property (readonly) NSArray *flatten;
@property (readonly) void (^each)(void (^eachBlock)(id));
@end