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
static const int TWO_CARD_RANK_MATCH = 5;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1 &&
        [otherCards[0] isKindOfClass:[PlayingCard class]]) {
        
        PlayingCard *otherCard = (PlayingCard *)otherCards[0];
        if (otherCard.rank == self.rank) {
            score = TWO_CARD_RANK_MATCH;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = TWO_CARD_SUIT_MATCH;
        }
    }
    
    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
        _rank = rank;
}

+ (NSArray *)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

@end
