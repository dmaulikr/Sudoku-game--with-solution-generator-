//
//  Board.h
//  Leman_Sudoku!
//
//  Created by Zleman on 12/4/13.
//  Copyright (c) 2013 Zleman. All rights reserved.
//This class holds the current state of a sudoku game and allows both a user to play and for the computer to solve the board.
//The class can also help the user by giving hints and preventing the user from making invalid moves.

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Stack.h"

@interface Board : NSObject
//Designated initializer
- (id) initWithString:(NSString *)start;
//Allows user to undo move
- (void)undo;
//Returns the number at a given location
- (NSString *)getCharAtRow:(int)row Col:(int)col;
//Sets the number at a given location
- (void)setSquareAtRow:(int)row Col:(int)col WithNumber:(int)num;
//This method is the computer player that solves the puzzle
- (void)solve;
/*This allows the the view controller to set the*
 final state that it received earlier when the board was solved in the background*/
-(void)setFinalState:(NSMutableString*) lastBoard;
//Represents the board that is currently displayed to the user
@property (nonatomic,strong) NSMutableString *currentPuzzle;
//Represents the board that contains the final solution
@property (nonatomic,strong) NSMutableString *finishedPuzzle;
//Stack that holds user's moves so that they can be undone.
@property (strong, nonatomic) Stack *undoStack;
//Stack to hold all possible successors to the current state of the game
@property (strong, nonatomic) Stack *stateStack;

@end
