#import <Foundation/Foundation.h>

@protocol Option <NSObject>

@property (readonly) NSObject <Option>*(^map)(id (^mapBlock)(id));
@property (readonly) NSObject <Option>*(^flatMap)(id (^flatMapBlock)(id));
@property (readonly) NSObject <Option>*(^filter)(BOOL (^filterBlock)(id));
@property (readonly) NSObject <Option>*flatten;
@property (readonly) BOOL isEmpty;
@property (readonly) id get;
@property (readonly) id (^getOrElse)(id defaultValue);

@end