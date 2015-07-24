#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Foo : NSObject @end

@interface Bar : NSObject
@property (nonatomic) id arg1, arg2;
@end

@interface Baz : NSObject
@property (nonatomic) Foo *foo;
- (instancetype)initWithDependency:(Foo *)foo;
@end

@protocol TestParentProtocol <NSObject>
@end

@protocol TestAbstractFactory <TestParentProtocol>
- (Foo *)foo;
- (Foo *)foo2;
- (Bar *)barWithArg1:(id)arg1 arg2:(id)arg2;
- (Baz *)baz;
@optional
- (Foo *)optionalFoo;
- (Foo *)optionalFoo2;
@end

typedef NSInteger (^BlockType)(NSInteger);
@protocol ValidTypesProtocol
- (BlockType)blockReturn;
- (id)blockArgument:(BlockType)arg;

@end

@protocol InvalidTypesProtocol
- (void)voidReturn;
- (NSInteger)integerReturn;
- (id)integerArgument:(NSInteger)arg;
@end

NS_ASSUME_NONNULL_END
