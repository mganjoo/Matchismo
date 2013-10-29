//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/12/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

#define NUMBER_OF_CARDS 28

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)numberOfInitialCardsInPlay
{
    return NUMBER_OF_CARDS;
}

- (CardView *)createViewForCard:(Card *)card
{
    PlayingCard *pCard = (PlayingCard *)card;
    PlayingCardView *pCardView = [[PlayingCardView alloc] init];
    if (pCardView) {
        pCardView.rank = pCard.rank;
        pCardView.suit = pCard.suit;
    }
    return pCardView;
}

- (void)updateTappedCardView:(CardView *)cardView forOutcome:(ChoiceOutcome)outcome
{
    PlayingCardView *playingCardView = (PlayingCardView *)cardView;
    [playingCardView flip];
    if (outcome == MatchOutcome) [playingCardView dim];
}

- (void)updateOpenCardView:(CardView *)cardView forOutcome:(ChoiceOutcome)outcome
{
    PlayingCardView *playingCardView = (PlayingCardView *)cardView;
    if (outcome == MismatchOutcome)
        [playingCardView flip];
    else if (outcome == MatchOutcome)
        [playingCardView dim];
}

@end
