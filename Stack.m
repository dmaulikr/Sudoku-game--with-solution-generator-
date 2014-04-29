

#import "Stack.h"

@implementation Stack

- (id)init
{
    if (self = [super init]) {
        self.stack = [[List alloc] init];
    }
    return self;
}


- (void)push:(NSMutableString*)anObject {
    [self.stack addToHead:anObject];
}
- (NSMutableString*)pop {
    return [self.stack removeFromHead];
}
- (NSMutableString*)peek {
    return [self.stack getHeadData];
}
- (BOOL)isEmpty {
    return [self.stack isEmpty];
}
- (int)size {
    return [self.stack size];
}

@end
