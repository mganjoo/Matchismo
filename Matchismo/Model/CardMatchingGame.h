//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Milind Ganjoo on 10/6/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

typedef enum {
    NoOutcome = 0,
    MismatchOutcome = 1,
    MatchOutcome = 2
} LastChoiceOutcome;

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                    threeCardMode:(BOOL)threeCardMode;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic) BOOL threeCardMode;
@property (nonatomic, readonly) NSInteger score;

// Properties associated with the last card choice
@property (nonatomic, strong, readonly) NSArray *lastFaceUpCards;
@property (nonatomic, readonly) LastChoiceOutcome lastChoiceOutcome;
@property (nonatomic, readonly) int lastScoreChange;

@end
