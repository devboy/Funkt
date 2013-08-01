#import <Foundation/Foundation.h>

@interface NSObject (Funkt)
@property (readonly) NSObject *(^tap)(void (^tapBlock)(NSObject *));
@end