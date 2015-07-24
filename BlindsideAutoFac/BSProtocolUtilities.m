#include "BSProtocolUtilities.h"

SelectorInclusionType BSSelectorInclusionTypeForProtocol(Protocol *protocol, SEL sel) {
    struct objc_method_description requiredDescription = protocol_getMethodDescription(protocol, sel, YES, YES);
    struct objc_method_description optionalDescription = protocol_getMethodDescription(protocol, sel, NO, YES);

    if (requiredDescription.name != NULL) {
        return SelectorInclusionTypeRequired;
    }
    else if (optionalDescription.name != NULL) {
        return SelectorInclusionTypeOptional;
    }
    else {
        return SelectorInclusionTypeMissing;
    }
}

NSMethodSignature *BSMethodSignatureForSelectorInProtocol(Protocol *protocol, SEL sel) {
    struct objc_method_description description = protocol_getMethodDescription(protocol, sel, YES, YES);
    if (description.types) {
        return [NSMethodSignature signatureWithObjCTypes:description.types];
    }

    description = protocol_getMethodDescription(protocol, sel, NO, YES);
    if (description.types) {
        return [NSMethodSignature signatureWithObjCTypes:description.types];
    }

    return nil;
}