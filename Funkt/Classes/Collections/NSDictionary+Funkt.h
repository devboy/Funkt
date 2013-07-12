#import <Foundation/Foundation.h>

@interface NSDictionary (Funkt)
@property (readonly) BOOL isEmpty;
@property (readonly) NSArray *pair;
@property (readonly) NSDictionary *invert;
@property (readonly) NSDictionary *(^pick)(NSArray *);
@property (readonly) NSDictionary *(^omit)(NSArray *);
@property (readonly) NSDictionary *(^defaults)(NSDictionary *);
@end