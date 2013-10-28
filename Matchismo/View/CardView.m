//
//  CardView.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/27/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardView.h"

@implementation CardView

// Standard width, height & radius for our cards
#define CARD_STANDARD_WIDTH         120.0
#define CARD_STANDARD_HEIGHT        180.0
#define CARD_STANDARD_CORNER_RADIUS 12.0

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CARD_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius      { return CARD_STANDARD_CORNER_RADIUS * [self cornerScaleFactor]; }

// The standard way to draw a card, with rounded corners.
// Subclasses can override the drawing of contents.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

@end
