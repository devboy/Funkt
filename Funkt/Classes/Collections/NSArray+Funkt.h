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
@property (readonly) NSArray * (^pluck)(NSString *);
@property (readonly) NSArray * (^where)(NSDictionary *);
@property (readonly) NSArray *uniq;
@property (readonly) NSArray * (^take)(NSUInteger);
@property (readonly) NSArray * (^takeRight)(NSUInteger);
@property (readonly) BOOL (^contains)(id);
@property (readonly) NSArray *(^sortBy)(NSComparator);
@property (readonly) NSDictionary *(^countBy)(id (^countByBlock)(id));
@property (readonly) NSDictionary *(^groupBy)(id (^groupByBlock)(id));
@property (readonly) NSArray *shuffle;
@property (readonly) NSArray *(^without)(NSArray *);
@property (readonly) NSArray *(^unionOf)(NSArray *,...);
@end