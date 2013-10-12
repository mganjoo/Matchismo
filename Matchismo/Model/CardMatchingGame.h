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
    TwoCardGameType,
    ThreeCardGameType
} CardGameType;

typedef enum {
    NoOutcome,
    MismatchOutcome,
    MatchOutcome
} ChoiceOutcome;

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                         gameType:(CardGameType)gameType;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic) CardGameType gameType;
@property (nonatomic, readonly) NSInteger score;

// Properties associated with the last card choice
@property (nonatomic, strong, readonly) NSArray *lastFaceUpCards;
@property (nonatomic, readonly) ChoiceOutcome lastChoiceOutcome;
@property (nonatomic, readonly) int lastScoreChange;

@end
