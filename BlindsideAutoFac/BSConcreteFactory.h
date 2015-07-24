#import <Foundation/Foundation.h>

@class BSProtocolBinding;

@interface BSConcreteFactory : NSObject

+ (id)factoryWithProtocolBinding:(BSProtocolBinding *)protocolBinding injector:(id<BSInjector>)injector;

@end
