
//Sets up a node object for the list


#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (nonatomic) NSMutableString* data;
@property (nonatomic, strong) Node *next;

@end
