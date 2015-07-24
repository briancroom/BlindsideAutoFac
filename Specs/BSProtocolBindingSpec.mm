#import <Cedar/Cedar.h>
#import "BSProtocolBinding.h"
#import "TestHelpers.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BSProtocolBindingSpec)

describe(@"BSProtocolBinding", ^{
    __block BSProtocolBinding *binding;

    context(@"for a valid protocol (only object parameters and object return values)", ^{
        beforeEach(^{
            binding = [BSProtocolBinding bindingForProtocol:@protocol(TestAbstractFactory)];
        });

        describe(@"binding an injection key to a selector", ^{
            context(@"when the selector is not a part of the protocol", ^{
                it(@"should throw an exception", ^{
                    ^{ [binding bindSelector:@selector(objectForKey:) toKey:@"123"]; } should raise_exception.with_name(NSInvalidArgumentException);
                });
            });
        });

        describe(@"looking up the injection key bound to a selector", ^{
            context(@"when the selector is not a part of the protocol", ^{
                it(@"should throw an exception", ^{
                    ^{ [binding injectionKeyForSelector:@selector(objectForKey:)]; } should raise_exception.with_name(NSInvalidArgumentException);
                });
            });

            context(@"when the selector is a required member of the protocol but has not been bound", ^{
                it(@"should throw an exception", ^{
                    ^{ [binding injectionKeyForSelector:@selector(foo)]; } should raise_exception.with_name(NSInternalInconsistencyException);
                });
            });

            context(@"when the selector is an optional member of the protocol but has not been bound", ^{
                it(@"should return nil", ^{
                    [binding injectionKeyForSelector:@selector(optionalFoo)] should be_nil;
                });
            });

            context(@"when the selector has been bound to a key", ^{
                beforeEach(^{
                    [binding bindSelector:@selector(foo) toKey:@"abc"];
                });

                it(@"should return the bound key", ^{
                    [binding injectionKeyForSelector:@selector(foo)] should equal(@"abc");
                });
            });
        });
    });

    context(@"for a valid protocol", ^{
        beforeEach(^{
            binding = [BSProtocolBinding bindingForProtocol:@protocol(ValidTypesProtocol)];
        });

        context(@"with a block return type", ^{
            it(@"should not throw an exception when binding the selector", ^{
                ^{ [binding bindSelector:@selector(blockReturn) toKey:@"abc"]; } should_not raise_exception;
            });
        });

        context(@"with a block parameter", ^{
            it(@"should not throw an exception when binding the selector", ^{
                ^{ [binding bindSelector:@selector(blockArgument:) toKey:@"abc"]; } should_not raise_exception;
            });
        });
    });

    context(@"for an invalid protocol", ^{
        beforeEach(^{
            binding = [BSProtocolBinding bindingForProtocol:@protocol(InvalidTypesProtocol)];
        });

        context(@"with a void return type", ^{
            it(@"should throw an exception when binding the selector", ^{
                ^{ [binding bindSelector:@selector(voidReturn) toKey:@"abc"]; } should raise_exception.with_name(NSInvalidArgumentException);
            });
        });

        context(@"with a non-object return type", ^{
            it(@"should throw an exception when binding the selector", ^{
                ^{ [binding bindSelector:@selector(integerReturn) toKey:@"abc"]; } should raise_exception.with_name(NSInvalidArgumentException);
            });
        });

        context(@"with a non-object parameter", ^{
            it(@"should throw an exception when binding the selector", ^{
                ^{ [binding bindSelector:@selector(integerArgument:) toKey:@"abc"]; } should raise_exception.with_name(NSInvalidArgumentException);
            });
        });
    });
});

SPEC_END
