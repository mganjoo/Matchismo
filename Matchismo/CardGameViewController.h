//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Milind Ganjoo on 9/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.

#import <UIKit/UIKit.h>
#import "Deck.h"

// Abstract class
@interface CardGameViewController : UIViewController

- (Deck *)createDeck; // abstract

- (NSUInteger)numberOfCardsInChoice;

- (NSAttributedString *)faceUpTitleForCard:(Card *)card;
- (NSAttributedString *)faceDownTitleForCard:(Card *)card;
- (NSString *)faceUpBackgroundImageNameForCard:(Card *)card;
- (NSString *)faceDownBackgroundImageNameForCard:(Card *)card;

@end
