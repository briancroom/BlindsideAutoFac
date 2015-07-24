#import <Cedar/Cedar.h>
#import "BSAutoFacProvider.h"
#import "TestHelpers.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BSAutoFacProviderSpec)

describe(@"BSAutoFacProvider", ^{
    __block BSAutoFacProvider *provider;
    __block id<BSInjector> injector;
    __block Foo *foo;

    beforeEach(^{
        foo = [[Foo alloc] init];
        injector = [Blindside injectorWithModules:@[]];
        [(id<BSBinder>)injector bind:[Foo class] toInstance:foo];

        BSProtocolBinding *binding = [BSProtocolBinding bindingForProtocol:@protocol(TestAbstractFactory)];
        [binding bindSelector:@selector(foo) toKey:[Foo class]];
        provider = [BSAutoFacProvider providerWithProtocolBinding:binding];
    });

    it(@"should provide a functional factory", ^{
        id<TestAbstractFactory> factory = [provider provide:@[] injector:injector];
        [factory foo] should be_same_instance_as(foo);
    });
});

SPEC_END
