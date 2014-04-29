
#import <Foundation/Foundation.h>
#import "List.h"

@interface Stack : NSObject

@property (nonatomic, strong) List *stack;

- (void)push:(NSMutableString*)anObject;
- (NSMutableString*)pop;
- (NSMutableString*)peek;
- (BOOL)isEmpty;
- (int)size;
@end
