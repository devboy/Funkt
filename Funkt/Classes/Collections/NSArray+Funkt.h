#import <Foundation/Foundation.h>

@protocol Option;

@interface NSArray (Funkt)
@property (readonly) NSObject <Option>* first;
@property (readonly) NSObject <Option>* last;
@property (readonly) NSObject <Option>* head;
@property (readonly) NSArray *tail;
@property (readonly) NSArray *flatten;
@property (readonly) void (^each)(void (^eachBlock)(id));
@property (readonly) NSArray *(^map)(id (^mapBlock)(id));
@property (readonly) id (^reduce)(id accumulator, id (^reduceBlock)(id accumulator, id value));
@property (readonly) NSObject <Option>* (^find)(BOOL (^findBlock)(id));
@property (readonly) BOOL (^any)(BOOL (^anyBlock)(id));
@property (readonly) BOOL (^all)(BOOL (^allBlock)(id));
@property (readonly) BOOL isEmpty;
@property (readonly) NSArray * (^filter)(BOOL (^filterBlock)(id));
@property (readonly) NSArray * (^reject)(BOOL (^rejectBlock)(id));
@property (readonly) void (^invoke)(SEL, NSArray *);
@end