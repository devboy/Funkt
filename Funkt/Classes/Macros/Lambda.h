#import "metamacros.h"

#define _lambda_param(index, ARG) id ARG,
#define _lambda_last_param(arg) id arg
#define _lambda_1_(statement) ^(){ return statement; }
#define _lambda_2_(arg, statement) ^(id arg){ return statement; }
#define _lambda_gt2_(...) ^( metamacro_foreach( \
    _lambda_param,,metamacro_take(metamacro_dec(metamacro_dec(metamacro_argcount(__VA_ARGS__))), __VA_ARGS__)) \
    _lambda_last_param(metamacro_at(metamacro_dec(metamacro_dec(metamacro_argcount(__VA_ARGS__))), __VA_ARGS__)) \
){ return metamacro_at(metamacro_dec(metamacro_argcount(__VA_ARGS__)), __VA_ARGS__); }

#define lambda(...) \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(_lambda_1_(__VA_ARGS__))\
        (metamacro_if_eq(2, metamacro_argcount(__VA_ARGS__))(_lambda_2_(__VA_ARGS__))(_lambda_gt2_(__VA_ARGS__)))