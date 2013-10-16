//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/12/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
