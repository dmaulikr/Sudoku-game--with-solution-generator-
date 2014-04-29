//
//  List.h
//
//
//  Created by Eric Chown on 4/4/13.
// Modified by Zackery Leman on 11/20/13
//  Copyright (c) 2013 edu.bowdoin.cs210.chown. All rights reserved.
//Sets up the list data structure
//The only change from what you provided with us was forcing the data to be a CGPoint


#import <Foundation/Foundation.h>
#import "Node.h"

@interface List : NSObject

@property (nonatomic, strong) Node *head;
@property (nonatomic, strong) Node *tail;
@property int count;

- (void)addToHead:(NSMutableString*)anObject;
- (void)addToTail:(NSMutableString*)anObject;
- (NSMutableString*)removeFromHead;
- (NSMutableString*)removeFromTail;
- (void) clear;
- (int) size;
- (NSMutableString*) getHeadData;
- (NSMutableString*) getTailData;
- (BOOL)isEmpty;

@end
