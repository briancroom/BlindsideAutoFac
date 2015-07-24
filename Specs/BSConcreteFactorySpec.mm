#import <Cedar/Cedar.h>
#import "BlindsideAutoFac.h"
#import "BSConcreteFactory.h"
#import "TestHelpers.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BSConcreteFactorySpec)

describe(@"BSConcreteFactory", ^{
    __block id factory;
    __block id<BSInjector> injector;

    beforeEach(^{
        injector = [Blindside injectorWithModules:@[]];

        BSProtocolBinding *protocolBinding = [BSProtocolBinding bindingForProtocol:@protocol(TestAbstractFactory)];
        [protocolBinding bindSelector:@selector(foo) toKey:[Foo class]];
        [protocolBinding bindSelector:@selector(barWithArg1:arg2:) toKey:[Bar class]];
        [protocolBinding bindSelector:@selector(baz) toKey:[Baz class]];
        [protocolBinding bindSelector:@selector(optionalFoo) toKey:[Foo class]];

        factory = [BSConcreteFactory factoryWithProtocolBinding:protocolBinding injector:injector];
    });

    describe(@"indicating whether the factory conforms to protocols", ^{
        it(@"should conform to the protocol specified in the protocol binding", ^{
            [factory conformsToProtocol:@protocol(TestAbstractFactory)] should be_truthy;
        });

        it(@"should conform to an inherited protocol", ^{
            [factory conformsToProtocol:@protocol(TestParentProtocol)] should be_truthy;
        });

        it(@"should not conform to another random protocol", ^{
            [factory conformsToProtocol:@protocol(NSCopying)] should be_falsy;
        });
    });

    context(@"when calling a parameterless method", ^{
        context(@"that is bound to an injection key", ^{
            context(@"for a class that has no dependencies", ^{
                it(@"should return an object of the expected class", ^{
                    Foo *foo = [factory foo];
                    foo should be_instance_of([Foo class]);
                });
            });

            context(@"for a class that has a dependency", ^{
                it(@"should return an object of the expected class", ^{
                    Baz *baz = [factory baz];
                    baz should be_instance_of([Baz class]);
                });
            });
        });

        context(@"that is not bound", ^{
            it(@"should throw an exception", ^{
                ^{ [factory foo2]; } should raise_exception.with_name(NSInternalInconsistencyException);
            });
        });
    });

    context(@"when calling a method with parameters", ^{
        __block Bar *bar;

        beforeEach(^{
            bar = [factory barWithArg1:@"1" arg2:@2];
        });

        it(@"should return an object of the expected class", ^{
            bar should be_instance_of([Bar class]);
        });

        it(@"should return an object initialized with the provided arguments", ^{
            bar.arg1 should equal(@"1");
            bar.arg2 should equal(@2);
        });
    });

    describe(@"handling an optional method", ^{
        context(@"that is bound to an injection key", ^{
            it(@"should create an object of the expected class", ^{
                [factory optionalFoo] should be_instance_of([Foo class]);
            });
        });

        context(@"that is not bound", ^{
            it(@"should throw an exception", ^{
                ^{ [factory optionalFoo2]; } should raise_exception.with_name(NSInvalidArgumentException);
            });
        });
    });

    describe(@"indicating whether the factory responds to a selector ", ^{
        context(@"that is a required method in the protocol", ^{
            it(@"should respond to the selector", ^{
                [factory respondsToSelector:@selector(foo)] should be_truthy;
            });
        });

        context(@"that is an optional method in the protocol and is bound to an injection key", ^{
            it(@"should respond to the selector", ^{
                [factory respondsToSelector:@selector(optionalFoo)] should be_truthy;
            });
        });

        context(@"that is an optional method in the protocol and is not bound", ^{
            it(@"should not respond to the selector", ^{
                [factory respondsToSelector:@selector(optionalFoo2)] should be_falsy;
            });
        });
    });
});

SPEC_END

// TODOs?
// validation?
// block factory
