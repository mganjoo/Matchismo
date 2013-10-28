//
//  SetCardView.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/27/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setShading:(SetCardShading)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(SetCardColor)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShape:(SetCardShape)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

// "Standard" (by our book) card width and height
// (See note about scaling below)
#define STANDARD_CARD_WIDTH  120.0
#define STANDARD_CARD_HEIGHT 180.0
#define HMARGIN 10.0

// These container sizes were hand-calculated
// based on a standard card size of 120x180
// (See note about scaling below)
#define SHAPE_CONTAINER_WIDTH   100.0
#define SHAPE_CONTAINER_HEIGHT   48.0
#define SHAPE_HORIZONTAL_MARGIN  25.0
#define SHAPE_VERTICAL_MARGIN    15.0

// Vertical offsets for cards
// Again, calculated based on standard card width and height
#define ODD_LAYOUT_OFFSET_1    9.0
#define ODD_LAYOUT_OFFSET_2   66.0
#define ODD_LAYOUT_OFFSET_3  123.0
#define EVEN_LAYOUT_OFFSET_1  37.5
#define EVEN_LAYOUT_OFFSET_2  94.5

// Squiggle drawing constants
// All these constants are unscaled, defined with
// respect to a default container size of w=100, h=48 (above)
#define SQUIGGLE_XOFFSET             8.0
#define SQUIGGLE_YOFFSET             4.0
#define SQUIGGLE_BEZIER1_ANGLE_DEG  45.0
#define SQUIGGLE_BEZIER2_ANGLE_DEG  35.0
#define SQUIGGLE_BEZIER3_ANGLE_DEG  60.0
#define SQUIGGLE_BEZIER1_LENGTH     20.0
#define SQUIGGLE_BEZIER2_LENGTH     15.0
#define SQUIGGLE_BEZIER3_LENGTH     10.0

// Note about scaling
// ------------------
// The following drawing methods will scale drawing by _width_ of the provided bounding
// rectangle, and will keep proportions consistent with respective WIDTH and HEIGHT constants.
// The caller must ensure that the _height_ of the provided bounding rectangle is sufficient
// (and ideally, in the same proportion to the respective HEIGHT constant as the width is to
// the WIDTH constant).

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    switch (self.number) {
        case 1:
            [self drawShapeInRect:rect atVertOffset:ODD_LAYOUT_OFFSET_2];
            break;
        case 2:
            [self drawShapeInRect:rect atVertOffset:EVEN_LAYOUT_OFFSET_1];
            [self drawShapeInRect:rect atVertOffset:EVEN_LAYOUT_OFFSET_2];
            break;
        case 3:
            [self drawShapeInRect:rect atVertOffset:ODD_LAYOUT_OFFSET_1];
            [self drawShapeInRect:rect atVertOffset:ODD_LAYOUT_OFFSET_2];
            [self drawShapeInRect:rect atVertOffset:ODD_LAYOUT_OFFSET_3];
            break;
        default:
            return;
    }

}

#pragma Mark - Shape drawing methods

// Find the scale factor (wrt the default shape dimensions)
- (CGFloat)shapeScaleFactor:(CGRect)boundingRect
{
    // Scale by _width_ only (see comments above)
    return boundingRect.size.width / SHAPE_CONTAINER_WIDTH;
}

- (void)drawShapeInRect:(CGRect)rect atVertOffset:(CGFloat)vOffset
{
    CGFloat scaleFactor = rect.size.width / STANDARD_CARD_WIDTH;
    CGRect shapeContainer = CGRectMake(10 * scaleFactor, vOffset * scaleFactor,
                                       SHAPE_CONTAINER_WIDTH * scaleFactor, SHAPE_CONTAINER_HEIGHT * scaleFactor);
    
    UIBezierPath *shape;
    switch (self.shape) {
        case SquiggleShape:
            shape = [self makeSquiggle:shapeContainer];
            break;
        case DiamondShape:
            shape = [self makeDiamond:shapeContainer];
            break;
        case OvalShape:
            shape = [self makeOval:shapeContainer];
            break;
        default:
            return;
    }
    
    [[self makeStrokeColor] setStroke];
    [shape stroke];
}

- (UIColor *)makeStrokeColor
{
    CGFloat red, green, blue;
    
    // These color values are custom (and made slightly easier on the eye)
    switch (self.color) {
        case PurpleColor:
            red = 0.5;
            green = 0.0;
            blue = 0.5;
            break;
        case RedColor:
            red = 1.0;
            green = 0.0;
            blue = 0.0;
            break;
        case GreenColor:
            red = 0.25;
            green = 0.65;
            blue = 0.35;
            break;
        default:
            return nil; // should never happen
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (UIBezierPath *)makeOval:(CGRect)boundingRect
{
    CGFloat scaleFactor = [self shapeScaleFactor:boundingRect];
    CGRect innerRect = CGRectMake(boundingRect.origin.x + SHAPE_HORIZONTAL_MARGIN * scaleFactor,
                                  boundingRect.origin.y + SHAPE_VERTICAL_MARGIN * scaleFactor,
                                  (SHAPE_CONTAINER_WIDTH - 2 * SHAPE_HORIZONTAL_MARGIN) * scaleFactor,
                                  (SHAPE_CONTAINER_HEIGHT - 2 * SHAPE_VERTICAL_MARGIN) * scaleFactor);
    return [UIBezierPath bezierPathWithRoundedRect:innerRect cornerRadius:innerRect.size.height / 2];
}

- (UIBezierPath *)makeDiamond:(CGRect)boundingRect
{
    CGFloat scaleFactor = [self shapeScaleFactor:boundingRect];
    
    // Scale default dimensions
    CGFloat left = boundingRect.origin.x + SHAPE_HORIZONTAL_MARGIN * scaleFactor;
    CGFloat right = left + (SHAPE_CONTAINER_WIDTH - 2 * SHAPE_HORIZONTAL_MARGIN) * scaleFactor;
    CGFloat hmiddle = (left + right) / 2;
    CGFloat top = boundingRect.origin.y + SHAPE_VERTICAL_MARGIN * scaleFactor;
    CGFloat bottom = top + (SHAPE_CONTAINER_HEIGHT - 2 * SHAPE_VERTICAL_MARGIN) * scaleFactor;
    CGFloat vmiddle = (top + bottom) / 2;
    
    // Draw
    UIBezierPath *diamond = [UIBezierPath bezierPath];
    [diamond moveToPoint:CGPointMake(left, vmiddle)];
    [diamond addLineToPoint:CGPointMake(hmiddle, top)];
    [diamond addLineToPoint:CGPointMake(right, vmiddle)];
    [diamond addLineToPoint:CGPointMake(hmiddle, bottom)];
    [diamond closePath];
    
    return diamond;
}

static inline CGFloat degreesToRadians(CGFloat degrees)
{
    return M_PI / 180 * degrees;
}

- (UIBezierPath *)makeSquiggle:(CGRect)boundingRect
{
    CGFloat scaleFactor = [self shapeScaleFactor:boundingRect];
    
    // Scale default dimensions
    CGFloat xLeft = boundingRect.origin.x + SHAPE_HORIZONTAL_MARGIN * scaleFactor;
    CGFloat xRight = xLeft + (SHAPE_CONTAINER_WIDTH - 2 * SHAPE_HORIZONTAL_MARGIN) * scaleFactor;
    CGFloat yTop   = boundingRect.origin.y + SHAPE_VERTICAL_MARGIN * scaleFactor;
    CGFloat yBottom = yTop + (SHAPE_CONTAINER_HEIGHT - 2 * SHAPE_VERTICAL_MARGIN) * scaleFactor;
    CGFloat xoffset = SQUIGGLE_XOFFSET * scaleFactor;
    CGFloat yoffset = SQUIGGLE_YOFFSET * scaleFactor;
    
    CGFloat bezier1HandleLength = SQUIGGLE_BEZIER1_LENGTH * scaleFactor;
    CGFloat bezier2HandleLength = SQUIGGLE_BEZIER2_LENGTH * scaleFactor;
    CGFloat bezier3HandleLength = SQUIGGLE_BEZIER3_LENGTH * scaleFactor;

    CGFloat bezier1Angle = degreesToRadians(SQUIGGLE_BEZIER1_ANGLE_DEG);
    CGFloat bezier2Angle = degreesToRadians(SQUIGGLE_BEZIER2_ANGLE_DEG);
    CGFloat bezier3Angle = degreesToRadians(SQUIGGLE_BEZIER3_ANGLE_DEG);
    CGFloat bezier4Angle = atan(xoffset - bezier2HandleLength * cos(bezier3Angle) /
                                yoffset + bezier2HandleLength * cos(bezier3Angle));
    
    // Draw
    UIBezierPath *squiggle = [UIBezierPath bezierPath];
    [squiggle moveToPoint:CGPointMake(xLeft, yTop)];
    [squiggle addCurveToPoint:CGPointMake(xRight, yTop)
                controlPoint1:CGPointMake(xLeft + bezier1HandleLength * cos(bezier2Angle),
                                          yTop - bezier1HandleLength * sin(bezier2Angle))
                controlPoint2:CGPointMake(xRight - bezier1HandleLength * cos(bezier1Angle),
                                           yTop + bezier1HandleLength * sin(bezier1Angle))];
    [squiggle addQuadCurveToPoint:CGPointMake(xRight + xoffset, yTop + yoffset)
                     controlPoint:CGPointMake(xRight + bezier2HandleLength * cos(bezier3Angle),
                                              yTop - bezier2HandleLength * cos(bezier3Angle))];
    [squiggle addQuadCurveToPoint:CGPointMake(xRight, yBottom)
                     controlPoint:CGPointMake(xRight + xoffset + bezier3HandleLength * cos(bezier4Angle),
                                              yTop + bezier3HandleLength * sin(bezier4Angle))];
    [squiggle addCurveToPoint:CGPointMake(xLeft, yBottom)
                controlPoint1:CGPointMake(xRight - bezier1HandleLength * cos(bezier2Angle),
                                          yBottom + bezier1HandleLength * sin(bezier2Angle))
                controlPoint2:CGPointMake(xLeft + bezier1HandleLength * cos(bezier1Angle),
                                          yBottom - bezier1HandleLength * sin(bezier1Angle))];
    [squiggle addQuadCurveToPoint:CGPointMake(xLeft - xoffset, yBottom - yoffset)
                     controlPoint:CGPointMake(xLeft - bezier2HandleLength * cos(bezier3Angle),
                                              yBottom + bezier2HandleLength * cos(bezier3Angle))];
    [squiggle addQuadCurveToPoint:CGPointMake(xLeft, yTop)
                     controlPoint:CGPointMake(xLeft - xoffset - bezier3HandleLength * cos(bezier4Angle),
                                              yBottom - bezier3HandleLength * sin(bezier4Angle))];
    [squiggle closePath];
    return squiggle;
}

@end