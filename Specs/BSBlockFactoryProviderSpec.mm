#import <Cedar/Cedar.h>
#import "BSBlockFactoryProvider.h"
#import "TestHelpers.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BSBlockFactoryProviderSpec)

describe(@"BSBlockFactoryProvider", ^{
    __block id<BSInjector> injector;
    __block Foo *foo;
    __block BSBlockFactoryProvider *provider;

    beforeEach(^{
        foo = [[Foo alloc] init];
        injector = [Blindside injectorWithModules:@[]];
        [(id<BSBinder>)injector bind:[Foo class] toInstance:foo];
    });

    describe(@"using an injection key", ^{
        beforeEach(^{
            provider = [BSBlockFactoryProvider providerWithInjectionKey:[Foo class]];
        });

        it(@"should provide a functional factory block", ^{
            Foo *(^factory)(void) = [provider provide:@[] injector:injector];
            factory() should be_same_instance_as(foo);
        });
    });

});

SPEC_END
