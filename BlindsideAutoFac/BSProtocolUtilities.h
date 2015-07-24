#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SelectorInclusionType) {
    SelectorInclusionTypeMissing,
    SelectorInclusionTypeRequired,
    SelectorInclusionTypeOptional
};

SelectorInclusionType BSSelectorInclusionTypeForProtocol(Protocol *protocol, SEL sel);
 NSMethodSignature * __nullable BSMethodSignatureForSelectorInProtocol(Protocol *protocol, SEL sel);

NS_ASSUME_NONNULL_END
