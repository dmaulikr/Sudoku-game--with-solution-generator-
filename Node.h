//
//  Node.h
//  
//
//  Created by Eric Chown on 4/4/13.
// Modified by Zackery Leman on 11/20/13
//  Copyright (c) 2013 edu.bowdoin.cs210.chown. All rights reserved.
//Sets up a node object for the list
//The only change from what you provided with us was forcing the data to be a NSMutableString

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (nonatomic) NSMutableString* data;
@property (nonatomic, strong) Node *next;

@end
