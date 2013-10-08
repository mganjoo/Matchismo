//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Milind Ganjoo on 9/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *previousOutcomes; // of NSString
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastChoiceOutcomeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *threeCardModeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *previousOutcomesSlider;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[[self cardButtons] count]
                                                  usingDeck:[self createDeck]
                                              threeCardMode:self.threeCardModeSwitch.on];
    }
    return _game;
}

- (NSMutableArray *)previousOutcomes
{
    if (!_previousOutcomes) _previousOutcomes = [[NSMutableArray alloc] init];
    return _previousOutcomes;
}

- (void)addPreviousOutcome:(NSString *)outcome
{
    // If the last outcome was blank, replace it
    // (we don't care about blank outcomes except the most recent one)
    if ([[self.previousOutcomes lastObject] isEqualToString:@""]) {
        [self.previousOutcomes setObject:outcome atIndexedSubscript:([self.previousOutcomes count] - 1)];
    } else {
        [self.previousOutcomes addObject:outcome];
    }
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    self.threeCardModeSwitch.enabled = NO;
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];

    // Generate string for outcome
    // Note: to use componentsJoinedByString, I added a 'description' method to Card,
    // which simply returns the result of the 'contents' method.
    NSString *faceUpCardsString = [self.game.lastFaceUpCards componentsJoinedByString:@" "];
    NSString *outcome = @"";
    if (self.game.lastChoiceOutcome == NoOutcome) {
        outcome = faceUpCardsString;
    } else if (self.game.lastChoiceOutcome == MatchOutcome) {
        outcome = [NSString stringWithFormat:@"Matched %@ for %d points.",
                   faceUpCardsString, self.game.lastScoreChange];
    } else if (self.game.lastChoiceOutcome == MismatchOutcome) {
        outcome = [NSString stringWithFormat:@"%@ don't match! %d point penalty.",
                   faceUpCardsString, self.game.lastScoreChange];
    }
    [self addPreviousOutcome:outcome];

    [self updateUI];
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    self.game = nil;
    self.previousOutcomes = nil;
    self.threeCardModeSwitch.enabled = YES;
    [self updateUI];
}

- (IBAction)toggleThreeCardModeSwitch:(UISwitch *)sender {
    self.game.threeCardMode = sender.on;
}

- (IBAction)adjustPreviousOutcomesSlider:(UISlider *)sender {
    NSUInteger index = round(sender.value);
    if (index < [self.previousOutcomes count]) {
        self.lastChoiceOutcomeLabel.text = self.previousOutcomes[index];
        self.lastChoiceOutcomeLabel.alpha = index < [self.previousOutcomes count] - 1 ? 0.6 : 1;
    }

}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    
    self.lastChoiceOutcomeLabel.text = [self.previousOutcomes lastObject];
    self.lastChoiceOutcomeLabel.alpha = 1;
    
    self.previousOutcomesSlider.maximumValue = [self.previousOutcomes count] - 1;
    [self.previousOutcomesSlider setValue:[self.previousOutcomes count] animated:YES];
    self.previousOutcomesSlider.enabled = [self.previousOutcomes count] >= 2 ? YES : NO;
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"CardFront" : @"CardBack"];
}

@end
