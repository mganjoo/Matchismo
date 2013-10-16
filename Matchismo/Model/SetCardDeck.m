//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/13/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (int color = 1; color <= NUMBER_OF_SET_FEATURES_PER_TYPE; color++) {
            for (int shading = 1; shading <= NUMBER_OF_SET_FEATURES_PER_TYPE; shading++) {
                for (int shape = 1; shape <= NUMBER_OF_SET_FEATURES_PER_TYPE; shape++) {
                    for (int number = 1; number <= NUMBER_OF_SET_FEATURES_PER_TYPE; number++) {
                        
                        SetCard *card = [[SetCard alloc] init];
                        card.color = color;
                        card.shading = shading;
                        card.shape = shape;
                        card.number = number;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
