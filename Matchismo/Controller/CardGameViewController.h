//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Milind Ganjoo on 9/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardView.h"
#import "CardMatchingGame.h"

// Abstract class
@interface CardGameViewController : UIViewController

// Abstract methods (must be overridden)
- (Deck *)createDeck;
- (CardView *)createViewForCard:(Card *)card;
- (void)updateTappedCardView:(CardView *)cardView forOutcome:(ChoiceOutcome)outcome;
- (void)updateOpenCardView:(CardView *)cardView forOutcome:(ChoiceOutcome)outcome;

// Methods that should only be used or _extended_ by subclasses
- (int)addCardsToPlay:(NSUInteger)numToAdd;
- (void)redeal;

// Read-only properties with getters (getters can be overridden)
@property (nonatomic, readonly) NSUInteger numberOfCardsInChoice;
@property (nonatomic, readonly) NSUInteger numberOfInitialCardsInPlay;

@end
