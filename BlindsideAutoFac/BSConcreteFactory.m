#import <Blindside/Blindside.h>
#import "BSConcreteFactory.h"
#import "BSProtocolBinding.h"
#import "BSProtocolUtilities.h"

static id instantiateObjectForInvocation(NSInvocation *invocation, id<BSInjector> injector, id injectionKey) {
    // Because only a variadic version of this method is exposed, we have to manually pass in a long series
    // of variables to accommodate the possibility of multiple args. The first nil value will terminate the arg list.
    id args[10];

    for (NSInteger i=0, argIndex=2; argIndex<invocation.methodSignature.numberOfArguments; i++, argIndex++) {
        __unsafe_unretained id arg;
        [invocation getArgument:&arg atIndex:argIndex];
        args[i] = arg;
    }
    return [injector getInstance:injectionKey withArgs:args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], nil];
}

@interface BSConcreteFactory ()
@property (nonatomic) BSProtocolBinding *autoFacProtocolBinding;
@property (nonatomic) id<BSInjector> autoFacInjector;
@end

@implementation BSConcreteFactory

+ (id)factoryWithProtocolBinding:(BSProtocolBinding *)protocolBinding injector:(id<BSInjector>)injector {
    return [[[self class] alloc] initWithProtocolBinding:protocolBinding injector:injector];
}

- (instancetype)initWithProtocolBinding:(BSProtocolBinding *)protocolBinding injector:(id<BSInjector>)injector {
    if (self = [super init]) {
        _autoFacProtocolBinding = protocolBinding;
        _autoFacInjector = injector;
    }
    return self;
}

#pragma mark - <NSObject>

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return protocol_isEqual(self.autoFacProtocolBinding.protocol, aProtocol) || protocol_conformsToProtocol(self.autoFacProtocolBinding.protocol, aProtocol);
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) { return YES; }

    SelectorInclusionType type = BSSelectorInclusionTypeForProtocol(self.autoFacProtocolBinding.protocol, aSelector);
    return (type == SelectorInclusionTypeRequired ||
            (type == SelectorInclusionTypeOptional && [self.autoFacProtocolBinding injectionKeyForSelector:aSelector] != nil));
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return BSMethodSignatureForSelectorInProtocol(self.autoFacProtocolBinding.protocol, aSelector) ?: [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (![self respondsToSelector:anInvocation.selector]) {
        [super forwardInvocation:anInvocation];
    }

    id injectionKey = [self.autoFacProtocolBinding injectionKeyForSelector:anInvocation.selector];
    id createdObject = instantiateObjectForInvocation(anInvocation, self.autoFacInjector, injectionKey);
    [anInvocation setReturnValue:&createdObject];
}

@end
