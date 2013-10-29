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
@property (nonatomic, readwrite) NSUInteger numberOfCardsInPlay;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic) NSUInteger numberOfCardsInChoice;
@property (nonatomic, strong, readwrite) NSArray *lastFaceUpCardIndices;
@property (nonatomic, readwrite) ChoiceOutcome lastChoiceOutcome;
@property (nonatomic) int lastScoreChange;

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
        self.deck = deck;
        self.numberOfCardsInChoice = numberOfCardsInChoice;
        for (int i = 0; i < count; i++) {
            int idx = [self addCardToPlayAndGetIndex];
            if (idx < 0) return nil;
        }
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

- (NSArray *)lastFaceUpCardIndices
{
    if (!_lastFaceUpCardIndices) _lastFaceUpCardIndices = [[NSArray alloc] init];
    return _lastFaceUpCardIndices;
}

// Try adding card to play, and return index of successfully added card
- (int)addCardToPlayAndGetIndex
{
    Card *card = [self.deck drawRandomCard];
    if (!card) return -1;
    [self.cards addObject:card];
    ++self.numberOfCardsInPlay;
    return [self.cards indexOfObject:card];
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.lastFaceUpCardIndices = nil;
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
                    --self.numberOfCardsInPlay;
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
            NSMutableArray *lastFaceUpCardIndices = [[NSMutableArray alloc] init];
            for (Card *card in faceUpCards) {
                [lastFaceUpCardIndices addObject:[[NSNumber alloc] initWithInt:[self.cards indexOfObject:card]]];
            }
            self.lastFaceUpCardIndices = [lastFaceUpCardIndices copy];

            // Note: we don't count this in lastScoreChange
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
