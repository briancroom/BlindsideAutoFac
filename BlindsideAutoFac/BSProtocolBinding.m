#import "BSProtocolBinding.h"
#import "BSProtocolUtilities.h"

@interface BSProtocolBinding ()
@property (nonatomic) Protocol *protocol;
@property (nonatomic) NSMutableDictionary *bindings;
@end

@implementation BSProtocolBinding

+ (instancetype)bindingForProtocol:(Protocol *)protocol {
    return [[self alloc] initWithProtocol:protocol];
}

+ (NSString *)validationErrorForMethodSignature:(NSMethodSignature *)signature {
    if (strstr(signature.methodReturnType, @encode(id)) == NULL) {
        return @"Methods must return an object.";
    }

    for (NSInteger i=2; i<signature.numberOfArguments; i++) {
        if (strstr([signature getArgumentTypeAtIndex:i], @encode(id)) == NULL) {
            return @"All parameters must be objects.";
        }
    }

    return nil;
}

- (instancetype)initWithProtocol:(Protocol *)protocol {
    if (self = [super init]) {
        _protocol = protocol;
        _bindings = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)bindSelector:(SEL)selector toKey:(id)key {
    if (BSSelectorInclusionTypeForProtocol(self.protocol, selector) == SelectorInclusionTypeMissing) {
        [self raiseExceptionForInvalidSelector:selector];
    }

    NSString *validationError = [BSProtocolBinding validationErrorForMethodSignature:BSMethodSignatureForSelectorInProtocol(self.protocol, selector)];
    if (validationError) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"Unable to bind '%@' from protocol '%s'. %@", NSStringFromSelector(selector), protocol_getName(self.protocol), validationError]
                                     userInfo:nil];
    }

    self.bindings[NSStringFromSelector(selector)] = key;
}

- (id)injectionKeyForSelector:(SEL)selector {
    SelectorInclusionType type = BSSelectorInclusionTypeForProtocol(self.protocol, selector);
    if (type == SelectorInclusionTypeMissing) {
        [self raiseExceptionForInvalidSelector:selector];
    }

    id key = self.bindings[NSStringFromSelector(selector)];
    if (!key && type == SelectorInclusionTypeRequired) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"Selector '%@' was not bound to an injection key", NSStringFromSelector(selector)]
                                     userInfo:NULL];
    }

    return key;
}

- (void)raiseExceptionForInvalidSelector:(SEL)selector {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:[NSString stringWithFormat:@"Protocol '%s' does not include the selector '%@'", protocol_getName(self.protocol), NSStringFromSelector(selector)]
                                 userInfo:NULL];
}

@end
