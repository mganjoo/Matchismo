//
//  SetCard.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/13/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

// Declared as public constant
const int NUMBER_OF_SET_FEATURES_PER_TYPE = 3;

static const int MATCH_SCORE = 3;

- (int)match:(NSArray *)otherCards
{
    int score = 0;

    if ([otherCards count] == 2 &&
        [otherCards[0] isKindOfClass:[SetCard class]] &&
        [otherCards[1] isKindOfClass:[SetCard class]]) {
            
        SetCard *firstCard = (SetCard *)otherCards[0];
        SetCard *secondCard = (SetCard *)otherCards[1];

        int numColorMatches = ((self.color == firstCard.color) +
                               (self.color == secondCard.color) +
                               (firstCard.color == secondCard.color));
        
        int numShadingMatches = ((self.shading == firstCard.shading) +
                                 (self.shading == secondCard.shading) +
                                 (firstCard.shading == secondCard.shading));
        
        int numShapeMatches = ((self.shape == firstCard.shape) +
                               (self.shape == secondCard.shape) +
                               (firstCard.shape == secondCard.shape));
        
        int numNumberMatches = ((self.number == firstCard.number) +
                               (self.number == secondCard.number) +
                               (firstCard.number == secondCard.number));
        
        NSLog(@"num_color: %d, num_shade: %d, num_shape: %d, num_number: %d", numColorMatches, numShadingMatches, numShapeMatches, numNumberMatches);

        if ((numColorMatches == 3 || numColorMatches == 0) &&
            (numShadingMatches == 3 || numShadingMatches == 0) &&
            (numShapeMatches == 3 || numShapeMatches == 0) &&
            (numNumberMatches == 3 || numNumberMatches == 0)) {
            
            int numIdenticalFeatures = ((numColorMatches == 3) +
                                        (numShadingMatches == 3) +
                                        (numShapeMatches == 3) +
                                        (numNumberMatches == 3));
            
            score = MATCH_SCORE + numIdenticalFeatures;
        }
    }

    return score;
}

// Contents too complicated; just use nil
- (NSString *)contents
{
    return nil;
}

- (void)setColor:(SetCardColor)color
{
    if ([self isValidSetFeature:color]) _color = color;
}

- (void)setShading:(SetCardShading)shading
{
    if ([self isValidSetFeature:shading]) _shading = shading;
}

- (void)setShape:(SetCardShape)shape
{
    if ([self isValidSetFeature:shape]) _shape = shape;
}
            
- (void)setNumber:(NSUInteger)number
{
    if ([self isValidSetFeature:number]) _number = number;
}

- (BOOL)isValidSetFeature:(NSUInteger)feature
{
    return feature <= NUMBER_OF_SET_FEATURES_PER_TYPE;
}

@end
