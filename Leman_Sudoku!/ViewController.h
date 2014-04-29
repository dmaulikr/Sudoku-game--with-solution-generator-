//
//  ViewController.h
//  Leman_Sudoku!
//
//  Created by Zleman on 12/4/13.
//  Copyright (c) 2013 Zleman. All rights reserved.
// This game allows the user to play sudoku and a intuitive fasion,
// preventing impossible mistaken moves while providing the oportunity
// for help by giving a hint.
//The program will also solve any sudoku puzzle that is displayed.

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "sudoku.h"
#import "Board.h"
#import "Stack.h"
@interface ViewController : UIViewController <sudokuDelegate>
/*The instance of the Board Class to store the board that
*is displayed to the user,
//to solve it, and to check the user's moves.*/
@property (strong, nonatomic) Board *board;
//The display of the board visible to the user
@property (weak, nonatomic) IBOutlet sudoku *sudokuview;
//Property to keep track of the tapped location
@property (nonatomic) CGPoint squareSelected;
//Keeps track of number selected by user to enter at a location
@property (nonatomic) int numberSelected;
//Allows multiple games to be taken from a single file
@property (nonatomic) int idexOfCurrentGame;
//Stores the time taken for the computer to solve the game
@property (nonatomic) double solveTime;
//Stores all the puzzles extracted from the board
@property (nonatomic) NSArray *puzzles;
//Stores the solution while the user is playing to give hints
@property (nonatomic,strong) NSMutableString *solvedBoard;
/*Indicates the computer is solving a board,
 * and unable to give hints or show the solution*/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *solving;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToSolve;
//Provides user a hint
- (IBAction)hint:(UIButton *)sender;
//Randomly selects and creates a new game from the  file
- (IBAction)newGame:(UIButton *)sender;
//Resets current game
- (IBAction)resetGame:(UIButton *)sender;
//Displayes solution and time to solve to the user
- (IBAction)autoSolve:(UIButton *)sender;
//Undoes the a move by the user
- (IBAction)undo:(UIButton *)sender;
//Takes a Col and Row and returns the number at that position
-(NSString*)getContentAtRow:(int)row Col:(int)col;
// the number the user selected to place at a location
- (void)numberSelected:(int)number;
/*Takes a Col and Row and returns and sets the value at that
 * location to the last user selected number*/
- (void)squareSelectedAtRow:(int)row Col:(int)col;
@end
