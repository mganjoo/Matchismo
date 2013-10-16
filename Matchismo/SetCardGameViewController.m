//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/13/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

// This is a three-card game
- (NSUInteger)numberOfCardsInChoice
{
    return 3;
}

- (NSAttributedString *)faceUpTitleForCard:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        
        NSString *shape;
        switch (setCard.shape) {
            case TriangleShape:
                shape = @"▲";
                break;
            case CircleShape:
                shape = @"●";
                break;
            case SquareShape:
                shape = @"■";
                break;
            default:
                return nil; // should never happen
        }
        
        if (!(1 <= setCard.number && setCard.number <= NUMBER_OF_SET_FEATURES_PER_TYPE))
            return nil; // should never happen
        
        NSString *title = [NSString stringWithFormat:@"%d%@", setCard.number, shape];
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]
                                                      initWithString:title];
        NSRange shapeRange = NSMakeRange(1, 1);
        
        CGFloat red, green, blue;
        // These color values are custom (and made slightly easier for the eye)
        switch (setCard.color) {
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
        
        CGFloat alpha;
        switch (setCard.shading) {
            case SolidShading:
                alpha = 1.0;
                break;
            case StripedShading:
                alpha = 0.25;
                break;
            case OpenShading:
                alpha = 0.0;
                break;
            default:
                return nil; // should never happen
        }
        
        UIColor *strokeColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        UIColor *fillColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        NSDictionary *colorAttributes = @{NSStrokeColorAttributeName : strokeColor,
                                          NSForegroundColorAttributeName : fillColor,
                                          NSStrokeWidthAttributeName : @-5};
        [attributedTitle addAttributes:colorAttributes range:shapeRange];

        return attributedTitle;
    }
    return nil;
}

- (NSAttributedString *)faceDownTitleForCard:(Card *)card
{
    // same as face up
    return [self faceUpTitleForCard:card];
}

- (NSString *)faceUpBackgroundImageNameForCard:(Card *)card
{
    return @"SelectedCardFront";
}

- (NSString *)faceDownBackgroundImageNameForCard:(Card *)card
{
    return @"UnselectedCardFront";
}

@end
