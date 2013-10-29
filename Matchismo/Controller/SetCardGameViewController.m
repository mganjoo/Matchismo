//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/13/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCard.h"
#import "SetCardView.h"
#import "SetCardDeck.h"

#define SET_CARDS_ADD_BATCH_SIZE 3

@interface SetCardGameViewController ()

@property (weak, nonatomic) IBOutlet UIButton *moreCardsButton;

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

- (NSUInteger)numberOfInitialCardsInPlay
{
    return 12;
}

- (CardView *)createViewForCard:(Card *)card
{
    SetCard *sCard = (SetCard *)card;
    SetCardView *sCardView = [[SetCardView alloc] init];
    if (sCardView) {
        sCardView.color = sCard.color;
        sCardView.number = sCard.number;
        sCardView.shading = sCard.shading;
        sCardView.shape = sCard.shape;
    }
    return sCardView;
}

- (void)updateTappedCardView:(CardView *)cardView forOutcome:(ChoiceOutcome)outcome
{
    SetCardView *setCardView = (SetCardView *)cardView;
    [setCardView toggleChosen];
    if (outcome == MatchOutcome) setCardView.needsRemoval = YES;
}

- (void)updateOpenCardView:(CardView *)cardView forOutcome:(ChoiceOutcome)outcome
{
    SetCardView *setCardView = (SetCardView *)cardView;
    if (outcome == MatchOutcome)
        setCardView.needsRemoval = YES;
    else if (outcome == MismatchOutcome)
        [setCardView toggleChosen];
}

- (IBAction)touchMoreCardsButton:(UIButton *)sender {
    int numAdded = [super addCardsToPlay:SET_CARDS_ADD_BATCH_SIZE];
    if (numAdded < SET_CARDS_ADD_BATCH_SIZE) sender.enabled = NO;
}

- (void)redeal
{
    [super redeal];
    self.moreCardsButton.enabled = YES;
}

@end
