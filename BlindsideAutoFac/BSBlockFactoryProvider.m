#import "BSBlockFactoryProvider.h"

@interface BSBlockFactoryProvider ()
@property (nonatomic) id injectionKey;
@end

@implementation BSBlockFactoryProvider

+ (instancetype)providerWithInjectionKey:(id)injectionKey {
    return [[self alloc] initWithInjectionKey:injectionKey];
}

- (instancetype)initWithInjectionKey:(id)injectionKey {
    if (self = [super init]) {
        _injectionKey = injectionKey;
    }
    return self;
}

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector {
    return ^{
        return [injector getInstance:self.injectionKey];
    };
}

@end
