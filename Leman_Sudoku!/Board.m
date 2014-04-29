//
//  Board.m
//  Leman_Sudoku
//
//  Created by Zleman on 12/4/13.
//  Copyright (c) 2013 Zleman. All rights reserved.
//  Copyright (c) 2013 Eric Chown. Contributed a few method Skeletons.
//This class holds the current state of a sudoku game and allows both a user to play and
//for the computer to solve the board.
//The class can also help the user by giving hints and preventing the user from making invalid moves.

// This program can solve the most difficult puzzles in a reasonable amount of time(<30seconds).
//The ""world's hardest" sudoku puzzle was solved in 24.5 seconds by this algorithm.
//http://www.telegraph.co.uk/science/science-news/9359579/Worlds-hardest-sudoku-can-you-crack-it.html
//8..........36......7..9.2...5...7.......457.....1...3...1....68..85...1..9....4..

#import "Board.h"
@interface Board() //private methods
/*makes sure the human's move is legal*/
-(BOOL)isLegal:(int)row
           Col:(int)col
        number:(int)num;

/*Returns YES if it found the number to be entered already in the same 3x3 block area*/
-(BOOL)checkBlocks:(int)i andCol:(int)j withNumber:(int)number withString:(NSMutableString *)current;

//Takes the current board state and identifies and returns the position with the least number of possible numbers
- (CGPoint)findNextSpotwithFewestPossibilities:(NSMutableString *)toTest;

//Takes a string and a location in the string and returns the value at that location
- (NSString *)specificGetCharAtRow:(int)row Col:(int)col withString:(NSMutableString*) current;

//Takes a string, a value, and a location in the string and replaces the value at that location in the string
- (NSMutableString *)specificSetSquareAtRow:(int)row Col:(int)col WithNumber:(int)num withPuzzle:(NSMutableString *)current;

//Searches the board in a single row, column, and 3x3 block
-(BOOL)searchRow:(int)staticRow Column:(int)staticCol withString:(NSMutableString *) tentativeBoardState andNumber:(int)number;

/*Takes the compressed board state information from the stack and
*in combination with the most recent dead-end state, reforms the next successor state.*/
-(NSMutableString *)creatStateFromStack:(int)currentRowOfPosition
                                   andJ:(int) currentColOfPosition
                           currentBoard:(NSMutableString *) tentativeBoardState
                                andPath:(Stack *)path;
-(NSMutableString*)successors:(CGPoint)next
                      inBoard:(NSMutableString*)tentativeBoardState;
@end

@implementation Board
/* Designated Initializer that initializes a board*/
- (id) initWithString:(NSString *)start{
    
    if (self = [super init])
    {
        self.currentPuzzle=[start mutableCopy];
        self.undoStack=[[Stack alloc] init];
        self.stateStack=[[Stack alloc] init];
        self.finishedPuzzle=[start mutableCopy];
    }
    return self;
    
}
//See above method descriptions for all of the following methods
- (NSString *)getCharAtRow:(int)row
                       Col:(int)col{
    NSRange substring={(col+(row*BOARD_WIDTH)),1};
    NSString *returnString=[self.currentPuzzle substringWithRange:substring];
    return returnString;
}
- (NSString *)specificGetCharAtRow:(int)row
                               Col:(int)col
                        withString:(NSMutableString*) current{
    
    NSRange substring={(col+(row*BOARD_WIDTH)),1};
    NSString *returnString=[current substringWithRange:substring];
    return returnString;
    
}
- (void)setSquareAtRow:(int)row
                   Col:(int)col
            WithNumber:(int)num{
    if ([self isLegal:row Col:col number:num]) {
        
        [self.undoStack push:[self.currentPuzzle copy]];
        NSRange substring={(col+(row*BOARD_WIDTH)),1};
        [self.currentPuzzle replaceCharactersInRange:substring
                                          withString:[NSMutableString stringWithFormat:@"%d",num]];
    }
}

- (NSMutableString *)specificSetSquareAtRow:(int)row
                                        Col:(int)col
                                 WithNumber:(int)num
                                 withPuzzle:(NSMutableString *)current{
    
    NSMutableString *temp=[NSMutableString stringWithFormat:@"%d",num];
    NSRange substring={(col+(row*BOARD_WIDTH)),1};
    NSMutableString *currentTemp=[current mutableCopy];
    [currentTemp replaceCharactersInRange:substring withString:temp];
    return currentTemp;
    
}
/* Prevents any numbers on board from being over written
 and prevents duplication of number*/
-(BOOL)isLegal:(int)row
           Col:(int)col
        number:(int)num{
    //First checks that the spot is blank. If not it can proceed
    //checking if it is a possible move
    if ([[self getCharAtRow:row Col:col] isEqualToString:@"."]) {
        if([self searchRow:row Column:col withString:self.currentPuzzle andNumber:num]){
            return NO;
        }
    } else {return NO;}
    return YES;
}

-(BOOL)searchRow:(int)staticRow
          Column:(int)staticCol
      withString:(NSMutableString *) tentativeBoardState
       andNumber:(int)number{
    
    int foundNumber=NO;
    //Checks the Column for an occurrence of the number
    for (int row=0; row<9; row++) {
        if([[self specificGetCharAtRow:row
                                   Col:staticCol
                            withString:tentativeBoardState] isEqual:[NSString stringWithFormat:@"%d",number]]){
            foundNumber=YES;
        }
    }
    //Checks the Row for an occurrence of the number
    for (int col=0; col<9 && !foundNumber; col++) {
        if([[self specificGetCharAtRow:staticRow
                                   Col:col
                            withString:tentativeBoardState]
            isEqual:[NSString stringWithFormat:@"%d",number]]){
            foundNumber=YES;
        }
    }
    //Searches the box of 3x3 for an occurrence of the number
    if (!foundNumber) {
        foundNumber=[self checkBlocks:staticRow
                               andCol:staticCol
                           withNumber:number
                           withString:tentativeBoardState];
    }
    
    if(foundNumber==YES){
        return YES;
    }
    return NO;
}



-(void)undo{
    self.currentPuzzle=[[self.undoStack pop] mutableCopy];
}


- (void)solve{
    //Keeps track of the order of generation of sucessors
    Stack *path=[[Stack alloc] init];
    //The string representing the board state to be manipulated
    NSMutableString *tentativeBoardState = [self.currentPuzzle copy];
    //Ends the loop if all spaces are filled and the program has reached the last  open spot
    BOOL done=NO;
    //Keep going while there is another possible state available and while not on the last square
    while (!done) {
        //Stores the current location for comparison in the future
        int currentRowOfPosition;
        int currentColOfPosition;
        // While the board is still solvable and not finished, continue filling in boxes
        //This infinite loop is broken when no moves are left.
        while (YES) {
            //Grabs the next spot to fill in. Chooses the one with the fewest possibilities
            CGPoint next=[self findNextSpotwithFewestPossibilities:tentativeBoardState];
            //If there is no move either from current board state
            //leading to a dead end or due to full  solved board...
            if (next.x== NO_POSSIBLE_SOLUTION_FROM_POINT || next.x== NO_MORE_SPOTS) {
                //When board is full and complete
                if(next.x==NO_MORE_SPOTS){
                    //Stops loops from from continuing
                    done=YES;
                    //Updates Board to the final state
                    self.finishedPuzzle=tentativeBoardState;
                }
                break;
            }
            //Add the current position to the stack keeping track of the order of solution
            currentRowOfPosition=next.x;
            currentColOfPosition=next.y;
            NSMutableString *temp=[NSMutableString stringWithFormat:@"%i%i",(int)next.x, (int)next.y];
            [path push:temp];
            //Adds all possible successors to stack and takes
            //one from the stack and makes it the current board state.
            tentativeBoardState = [self successors:next inBoard:tentativeBoardState];
        }
        //If the game is not over then get the next state from the stack.
        if (!done){
            tentativeBoardState =[self creatStateFromStack:currentRowOfPosition
                                                      andJ:currentColOfPosition
                                              currentBoard:tentativeBoardState
                                                   andPath:path];
        }
    }
    //Update the final board
    self.finishedPuzzle=tentativeBoardState;
}



//Returns YES if it found it in the same 3x3 block
-(BOOL)checkBlocks:(int)i
            andCol:(int)j
        withNumber:(int)number
        withString:(NSMutableString *)current{
    int cornerI, cornerJ, across,down;
    //Determines what 3x3 block to look in based on the
    //position parameters
    if     (i>=0 && i<3){cornerI=0;}
    else if(i>=3 && i<6){cornerI=3;}
    else                {cornerI=6;}
    
    if     (j>=0 && j<3){cornerJ=0;}
    else if(j>=3 && j<6){cornerJ=3;}
    else                {cornerJ=6;}
    
    //Searches a single 3x3 block
    for (int rows=0; rows<3; rows++) {
        down= cornerI+rows;
        for (int cols=0; cols<3; cols++) {
            across= cornerJ+cols;
            if([[self specificGetCharAtRow:down Col:across withString:current]
                isEqual:[NSString stringWithFormat:@"%d",number]]){
                return YES;
            }
        }
    }
    
    return NO;
}

/* Determines the best position to add the next value.
 * Also determines when the board is finished being solved or impossible to solve*/
- (CGPoint)findNextSpotwithFewestPossibilities:(NSMutableString *)toTest{
    
    CGPoint goHereNext;
    goHereNext.x=NO_POSSIBLE_SOLUTION_FROM_POINT;
    goHereNext.y=NO_POSSIBLE_SOLUTION_FROM_POINT;
    NSMutableString *tentativeBoardState = [toTest mutableCopy];
    //This string keeps track of number of possibilities per open square.
    NSString *count=@".................................................................................";
    NSMutableString * countstring=[ count mutableCopy];
    //Searches the board at all locations
    while (YES) {
        for (int i=0; i<9; i++) {
            for (int j=0; j<9; j++) {
                //Only looks further at the spot to determine how many numbers coukd legally go there if there is not
                //already a number there
                if ([[self specificGetCharAtRow:i Col:j withString:tentativeBoardState] isEqual:@"."]) {
                    int count=0;
                    for (int number=1; number<=9; number++) {
                        if (![self searchRow:i Column:j withString:tentativeBoardState andNumber:number]) { count++;}
                    }
                    //If there is no value to fill in this  square the whole board is unsolvable
                    if (count==0){
                        //Returns the defualt value indicating that backtracking needs to begin
                        return goHereNext;
                    }
                    // If there is only one option to fill in, then fill it in.
                    if (count==1) {
                        goHereNext.x=i;
                        goHereNext.y=j;
                        return goHereNext;
                    } else {
                        // If there are multiple options add the number of options
                        // at that spot to the corresponding location in the "count" string.
                        NSRange substring={(j+(i)*BOARD_WIDTH),1};
                        [countstring replaceCharactersInRange:substring withString:[NSMutableString stringWithFormat:@"%d",count]];
                    }
                }
            }
        }
        //If there is no spot with only one possibility
        //then search the string to find the spot with the smallest possible number of possibilities
        int min=9;
        goHereNext.x=NO_MORE_SPOTS;
        goHereNext.y=NO_MORE_SPOTS;
        for (int i=0; i<9; i++) {
            for (int j=0; j<9; j++) {
                if ([[self specificGetCharAtRow:i Col:j withString:countstring] intValue]<min &&
                    ![[self specificGetCharAtRow:i Col:j withString:countstring]isEqual:@"."]){
                    min=[[self specificGetCharAtRow:i Col:j withString:countstring] intValue];
                    goHereNext.x=i;
                    goHereNext.y=j;
                }
            }
        }
    return goHereNext;
}
}

-(void)setFinalState:(NSMutableString*) lastBoard{
    
self.currentPuzzle=[lastBoard mutableCopy];
}



-(NSMutableString *)creatStateFromStack:(int)currentRowOfPosition
                                   andJ:(int)currentColOfPosition
                           currentBoard:(NSMutableString *) tentativeBoardState
                                andPath:(Stack *)path{
    
    NSMutableString *newTentativeBoardState=[tentativeBoardState mutableCopy];
    NSMutableString *temporary=[self.stateStack pop];
    //Takes the information necessary to reconstitute the board from substrings in compressed board state
    NSRange substringI={1,1},substringJ={2,1},substringNumber={0,1},resetPosition={DUMMY,1},rowAndCol={1,2};
    //If this last position where a value was attempted to be inserted
    //is the same as the postion of next modification pulled from the stack simply continue and build that state.
    //(i.e no need to reset anything else, as future change will replace the same square)
    //Else enter the if statement.
        if(!(currentRowOfPosition==[[temporary substringWithRange:substringI] intValue] &&
             currentColOfPosition==[[temporary substringWithRange:substringJ] intValue])){
            //While the position just pulled of the stack to backtrack to is different from the top
            //of the path stack, reset the topmost value of the path stack to "."
            //This cleans up any changes made along the deadend path.
            while (!([[path peek] isEqual:[temporary substringWithRange:rowAndCol]])) {
                NSMutableString *position=[path pop];
                NSRange extractRowThenCol={0,1};
                NSString *extractedRow=[position substringWithRange:extractRowThenCol];
                extractRowThenCol.location=1;
                resetPosition.location=([[position substringWithRange:extractRowThenCol]intValue]+
                                        ([extractedRow intValue]*BOARD_WIDTH));
                [newTentativeBoardState replaceCharactersInRange:resetPosition withString:@"."];
            }
        }
        //Inserts the number into the working board to create the state that was pulled from the stack
        NSString *numberToInsert=[temporary substringWithRange:substringNumber];
        NSString *positionI=[temporary substringWithRange:substringI];
        NSString *positionJ=[temporary substringWithRange:substringJ];
        resetPosition.location=([positionJ intValue] + ([positionI intValue]*BOARD_WIDTH));
        [newTentativeBoardState replaceCharactersInRange:resetPosition withString:numberToInsert];
return newTentativeBoardState;
}


-(NSMutableString*)successors:(CGPoint )next
                      inBoard:(NSMutableString*) tentativeBoardState{
//Tests numbers 1-9 to see what ones can be inserted at that spot.
for (int number=1; number<=9; number++) {
    //If the number to enter was not already found in a row, column, or 3x3 block,
    //then it is inserted into the spot and the compressed board state is added to the stack.
    if (![self searchRow:next.x Column:next.y withString:tentativeBoardState andNumber:number]) {
        [self.stateStack push:[NSMutableString stringWithFormat:@"%i%i%i",number,(int)next.x, (int)next.y]];
    }
}
//Updates the working board
NSMutableString *nextState=[self.stateStack pop];
NSRange substringNumber={0,1},substringI={1,1},substringJ={2,1},updateNumber={DUMMY,1};
NSString *numberToInsert=[nextState substringWithRange:substringNumber];
updateNumber.location=([[nextState substringWithRange:substringJ] intValue]+
                      ([[nextState substringWithRange:substringI] intValue]*BOARD_WIDTH));
NSMutableString *nextStateCopy=[tentativeBoardState mutableCopy];
[nextStateCopy replaceCharactersInRange:updateNumber withString:numberToInsert];
return  nextStateCopy;
}

@end





