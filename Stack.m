//
//  Stack.m
//  Cannibals
//
//  Created by Eric Chown on 4/9/13.
//  Copyright (c) 2013 edu.bowdoin.cs210.chown. All rights reserved.
//

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
