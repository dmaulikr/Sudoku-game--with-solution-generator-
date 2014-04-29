//
//  ViewController.m
//  Leman_Sudoku
//
//  Created by Zleman on 12/4/13.
//  Copyright (c) 2013 Zleman. All rights reserved.
// This game allows the user to play sudoku and a intuitive fashion,
// preventing impossible mistaken moves while providing the opportunity
// for help by giving a hint.
//The program will also solve any sudoku puzzle that is displayed.

#import "ViewController.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //sets self as the view's delegate
    self.sudokuview.delegate = self;
    //Creates a tap location detector
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.sudokuview
                                                                          action:@selector(tap:)];
    //Assigns detector to the view
    [self.sudokuview addGestureRecognizer:tap];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"msk_009"
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    self.puzzles= [content componentsSeparatedByString:@"\n"];
    self.board = [[Board alloc] initWithString:[self.puzzles objectAtIndex:0]];
    self.solveTime =0;
     [self.solving startAnimating];
    [self.view setNeedsDisplay];
    
    // Start solving the puzzle upon launch in a separate thread
    //so user can play the puzzle in main thread.
    [NSThread detachNewThreadSelector:@selector(preSolve) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*Provides user a hint to place a number at a specific location
 * with the origin being the upper left hand corner*/
- (IBAction)hint:(UIButton *)sender {
    //Prevents crash if user wants hint before the computer has solved the game
    if (self.solveTime!=0) {
        BOOL nextNumber=YES;
        //Generates random number for location of hint
        while (nextNumber) {
            int row=arc4random_uniform(BOARD_WIDTH);
            int col=arc4random_uniform(BOARD_WIDTH);
            if ([[self getContentAtRow:row+1 Col:col] isEqual:@"."]) {
                NSRange substring={(col+(row)*BOARD_WIDTH),1};
                NSString *holder=[self.solvedBoard substringWithRange:substring];
                NSString *holder2=[NSString stringWithFormat:@"Place a %@ at (%d,%d)", holder,col+1, row+1];
                [self.hintLabel setText:holder2];
                nextNumber=NO;
            }
        }
        [self.view setNeedsDisplay];
    } else {
        [self.hintLabel setText:@"Currently solving"];
    }
}

//Randomly selects and creates a new game from the  file
- (IBAction)newGame:(UIButton *)sender {
    [self.solving startAnimating];
    //Generates random numbers
    self.idexOfCurrentGame=arc4random_uniform(INPUT_SIZE);
    self.board = [[Board alloc] initWithString:[self.puzzles objectAtIndex:self.idexOfCurrentGame]];
    NSString *reset=[ NSString stringWithFormat:@" Solve time:"];
    [self.timeToSolve setText:reset];
    [self.sudokuview setNeedsDisplay];
    self.solvedBoard=[self.board currentPuzzle];
    self.solveTime=0;
    // Start auto solve multi threading
    [NSThread detachNewThreadSelector:@selector(preSolve) toTarget:self withObject:nil];
    
}
//Resets current game
- (IBAction)resetGame:(UIButton *)sender {
    self.board = [[Board alloc] initWithString:[self.puzzles objectAtIndex:self.idexOfCurrentGame]];
    NSString *reset=[ NSString stringWithFormat:@" Solve time:"];
    [self.timeToSolve setText:reset];
    [self.sudokuview setNeedsDisplay];
    self.solveTime=0;
    // Start auto solve multi threading
    [NSThread detachNewThreadSelector:@selector(preSolve) toTarget:self withObject:nil];
    
}
//Displays solution and time to solve to the user
- (IBAction)autoSolve:(UIButton *)sender {
    if (self.solveTime!=0) {
        [self.board setFinalState: self.solvedBoard];
        NSString *difference =[ NSString stringWithFormat:@" %f s",self.solveTime];
        [self.timeToSolve setText:[[self.timeToSolve text] stringByAppendingString:difference]];
        [self.hintLabel setText:@"DONE"];
        [self.sudokuview setNeedsDisplay];
    }else {
        [self.hintLabel setText:@"Currently solving: Press again when not spinning."];
    }
    
}
// This solves the board and stops and starts the timer
-(void)preSolve{
    double start,end;
    //start time is recorded.
    start = clock();
    [self.board solve];
    //The board is solved and the property is set equal to the solution
    self.solvedBoard=[self.board finishedPuzzle];
    //end time is recorded
    end = clock();
    //Difference in time is determined.
    self.solveTime = (end - start)/CLOCKS_PER_SEC;
    NSLog(@"Solve time: %f s", self.solveTime);
    //Indicates it is done solving
   [self.solving stopAnimating];
    
}
//Undoes the a move by the user
- (IBAction)undo:(UIButton *)sender {
    [self.board undo];
    [self.sudokuview setNeedsDisplay];
}

//Takes a Col and Row and returns the number at that position
-(NSString*)getContentAtRow:(int)row Col:(int)col{
    return [self.board getCharAtRow:row-1 Col:col];
}
// the number the user selected to place at a location
- (void)numberSelected:(int)number{
    self.numberSelected=number;
    NSLog(@"NUMBER selected %d ", self.numberSelected);
}

/*Takes a Col and Row and returns and sets the value at that
 * location to the last user selected number*/
- (void)squareSelectedAtRow:(int)row Col:(int)col{
    //makes the hint disappear
    [self.hintLabel setText:@"."];
    CGPoint temp;
    temp.x=col;
    temp.x=row;
    self.squareSelected=temp;
    NSLog(@"Point(%f, %f) ", self.squareSelected.x, self.squareSelected.y);
    [self.board setSquareAtRow:row Col:col WithNumber:self.numberSelected];
    [self.sudokuview setNeedsDisplay];
}

@end
