#import <Blindside/Blindside.h>

@interface BSBlockFactoryProvider : NSObject <BSProvider>

+ (instancetype)providerWithInjectionKey:(id)injectionKey;

@end
