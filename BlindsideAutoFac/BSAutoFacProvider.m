#import "BSAutoFacProvider.h"
#import "BSConcreteFactory.h"

@interface BSAutoFacProvider ()
@property (nonatomic) BSProtocolBinding *binding;
@end

@implementation BSAutoFacProvider

+ (instancetype)providerWithProtocolBinding:(BSProtocolBinding *)binding {
    return [[self alloc] initWithProtocolBinding:binding];
}

- (instancetype)initWithProtocolBinding:(BSProtocolBinding *)binding {
    if (self = [super init]) {
        _binding = binding;
    }
    return self;
}

#pragma mark - <BSProvider>

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector {
    return [BSConcreteFactory factoryWithProtocolBinding:self.binding injector:injector];
}

@end
