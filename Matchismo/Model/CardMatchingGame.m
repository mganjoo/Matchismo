//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/6/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic) NSUInteger numberOfCardsInChoice;
@property (nonatomic, strong, readwrite) NSArray *lastFaceUpCards;
@property (nonatomic, readwrite) ChoiceOutcome lastChoiceOutcome;
@property (nonatomic, readwrite) int lastScoreChange;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
              numberOfCardsInChoice:(NSUInteger)numberOfCardsInChoice
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        self.numberOfCardsInChoice = numberOfCardsInChoice;
    }
    
    return self;
}

- (instancetype)init
{
    return nil;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (NSArray *)lastFaceUpCards
{
    if (!_lastFaceUpCards) _lastFaceUpCards = [[NSArray alloc] init];
    return _lastFaceUpCards;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.lastFaceUpCards = nil;
            self.lastChoiceOutcome = NoOutcome;
            self.lastScoreChange = 0;
        } else {
            NSMutableArray *faceUpCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [faceUpCards addObject:otherCard];
                }
            }
            
            int matchScore = [card match:faceUpCards];
            if ([faceUpCards count] == self.numberOfCardsInChoice - 1) {
                if (matchScore > 0) {
                    self.lastScoreChange = matchScore * MATCH_BONUS;
                    self.score += self.lastScoreChange;
                    self.lastChoiceOutcome = MatchOutcome;
                    card.matched = YES;
                    for (Card *otherCard in faceUpCards) {
                        otherCard.matched = YES;
                    }
                } else {
                    self.lastScoreChange = MISMATCH_PENALTY;
                    self.score -= self.lastScoreChange;
                    self.lastChoiceOutcome = MismatchOutcome;
                    for (Card *otherCard in faceUpCards) {
                        otherCard.chosen = NO;
                    }
                }
            } else {
                self.lastChoiceOutcome = NoOutcome;
                self.lastScoreChange = 0;
            }
            
            [faceUpCards addObject:card];
            self.lastFaceUpCards = [faceUpCards copy];

            // Note: we don't count this in lastScoreChange
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
