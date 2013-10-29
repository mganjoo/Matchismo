//
//  CardView.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/27/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardView.h"

@interface CardView()

@end

@implementation CardView

// Standard width, height & radius for our cards
#define STANDARD_CARD_WIDTH         120.0
#define STANDARD_CARD_HEIGHT        180.0
#define STANDARD_CARD_CORNER_RADIUS  12.0

const float CARD_ASPECT_RATIO = STANDARD_CARD_WIDTH / STANDARD_CARD_HEIGHT;

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (id)init
{
    id cardView = [super init];
    if (cardView) [self setup];
    return cardView;
}

- (void)awakeFromNib
{
    [self setup];
}

- (UIColor *)strokeColor
{
    if (!_strokeColor) _strokeColor = self.defaultStrokeColor;
    return _strokeColor;
}

- (UIColor *)fillColor
{
    if (!_fillColor) _fillColor = self.defaultFillColor;
    return _fillColor;
}

- (UIColor *)defaultStrokeColor
{
    return [UIColor blackColor];
}

- (UIColor *)defaultFillColor
{
    return [UIColor whiteColor];
}

- (CGFloat)cornerRadius
{
    return STANDARD_CARD_CORNER_RADIUS * self.bounds.size.width / STANDARD_CARD_WIDTH;
}

// The standard way to draw a card, with rounded corners.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *cardPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               cornerRadius:[self cornerRadius]];
    
    [self.fillColor setFill];
    [cardPath fill];

    [self.strokeColor setStroke];
    [cardPath stroke];

    [cardPath addClip];
    [self drawContents:rect];
}

// Subclasses can override the drawing of contents.
- (void)drawContents:(CGRect)rect
{
}

@end
