#import "TestHelpers.h"
#import <Blindside/Blindside.h>

@implementation Foo @end

@implementation Bar

+ (BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithArg1:arg2:)
                                  argumentKeys:BS_DYNAMIC, BS_DYNAMIC, nil];
}

- (instancetype)initWithArg1:(id)arg1 arg2:(id)arg2 {
    if (self = [super init]) {
        _arg1 = arg1;
        _arg2 = arg2;
    }
    return self;
}

@end


@implementation Baz

- (instancetype)initWithDependency:(Foo *)foo {
    if (self = [super init]) {
        _foo = foo;
    }
    return self;
}

@end
