//
//  Grid.h
//  Matchismo
//
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject

// required inputs (zero is not a valid value for any of these)

@property (nonatomic) CGSize size;                      // overall available space to put grid into
@property (nonatomic) CGFloat cellAspectRatio;          // width divided by height (of each cell)
@property (nonatomic) NSUInteger minimumNumberOfCells;

// optional inputs (non-positive values are ignored)

@property (nonatomic) CGFloat minCellWidth;
@property (nonatomic) CGFloat maxCellWidth;     // ignored if less than minCellWidth
@property (nonatomic) CGFloat minCellHeight;
@property (nonatomic) CGFloat maxCellHeight;    // ignored if less than minCellHeight

// calculated outputs (value of NO or 0 or CGSizeZero means "invalid inputs")

@property (nonatomic, readonly) BOOL inputsAreValid;    // cells will fit into requested size

@property (nonatomic, readonly) CGSize cellSize;        // will be made as large as possible
@property (nonatomic, readonly) NSUInteger rowCount;
@property (nonatomic, readonly) NSUInteger columnCount;

// origin row and column are zero

- (CGPoint)centerOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;
- (CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;

@end
