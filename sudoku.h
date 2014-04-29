//
//  sudoku.h
//  Leman_Sudoku!
//
//  Created by Zleman on 12/4/13.
//  Copyright (c) 2013 Zleman. All rights reserved.
// This view draws the  initial sudoku board  and refreshes it when
// a user makes a move or the computer solution is shown.
//This also creates a row of numbers to select before choosing a location to put the number

#import <UIKit/UIKit.h>
#import "Constants.h"


@class sudoku;

@protocol sudokuDelegate
//Decribed in viewController.h
-(NSString*)getContentAtRow:(int)row Col:(int)col;
- (void)numberSelected:(int)number;
- (void)squareSelectedAtRow:(int)row Col:(int)col;
@end

@interface sudoku : UIView
@property (nonatomic) id <sudokuDelegate> delegate;
- (void)tap:(UITapGestureRecognizer *)gesture;
@end
