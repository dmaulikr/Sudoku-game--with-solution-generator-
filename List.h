
//Sets up the list data structure



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
