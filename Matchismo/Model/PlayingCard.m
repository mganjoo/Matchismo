//
//  PlayingCard.m
//  Matchismo
//
//  Created by Milind Ganjoo on 9/28/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

// Score constants for various match difficulties
static const int TWO_CARD_SUIT_MATCH = 2;
static const int TWO_CARD_RANK_MATCH = 4;
static const int THREE_CARD_PARTIAL_SUIT_MATCH = 1;
static const int THREE_CARD_SUIT_MATCH = 3;
static const int THREE_CARD_PARTIAL_RANK_MATCH = 4;
static const int THREE_CARD_PARTIAL_RANK_AND_SUIT_MATCH = 5;
static const int THREE_CARD_RANK_MATCH = 6;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = TWO_CARD_RANK_MATCH;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = TWO_CARD_SUIT_MATCH;
        }
    } else if ([otherCards count] == 2) {
        PlayingCard *firstCard = otherCards[0];
        PlayingCard *secondCard = otherCards[1];
        
        int numSuitMatches = [self suitMatchesWith:firstCard] +
                             [self suitMatchesWith:secondCard] +
                             [firstCard suitMatchesWith:secondCard];
        int numRankMatches = [self rankMatchesWith:firstCard] +
                             [self rankMatchesWith:secondCard] +
                             [firstCard rankMatchesWith:secondCard];
        
        if (numSuitMatches == 3) {
            score = THREE_CARD_SUIT_MATCH;
        } else if (numRankMatches == 3) {
            score = THREE_CARD_RANK_MATCH;
        } else if (numSuitMatches == 1) {
            if (numRankMatches == 1) {
                score = THREE_CARD_PARTIAL_RANK_AND_SUIT_MATCH;
            } else {
                score = THREE_CARD_PARTIAL_SUIT_MATCH;
            }
        } else if (numRankMatches == 1) {
            score = THREE_CARD_PARTIAL_RANK_MATCH;
        }
        
    }
    
    return score;
}

- (BOOL)suitMatchesWith:(PlayingCard *)otherCard {
    return [otherCard.suit isEqualToString:self.suit];
}

- (BOOL)rankMatchesWith:(PlayingCard *)otherCard {
    return otherCard.rank == self.rank;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
