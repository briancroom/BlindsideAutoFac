#import <Blindside/Blindside.h>
#import "BSProtocolBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSAutoFacProvider : NSObject <BSProvider>

+ (instancetype)providerWithProtocolBinding:(BSProtocolBinding *)binding;

@end

NS_ASSUME_NONNULL_END
