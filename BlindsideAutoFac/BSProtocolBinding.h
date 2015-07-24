#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSProtocolBinding : NSObject

@property (nonatomic, readonly) Protocol *protocol;

+ (instancetype)bindingForProtocol:(Protocol *)protocol;

- (void)bindSelector:(SEL)selector toKey:(id)key;
- (nullable id)injectionKeyForSelector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
