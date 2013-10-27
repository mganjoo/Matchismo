//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Milind Ganjoo on 9/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSAttributedString *lastOutcome;
@property (strong, nonatomic) NSMutableArray *previousOutcomes; // of NSAttributedString

// UI elements
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastChoiceOutcomeLabel;

@end

@implementation CardGameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[[self cardButtons] count]
                                                  usingDeck:[self createDeck]
                                      numberOfCardsInChoice:[self numberOfCardsInChoice]];
    }
    return _game;
}

// Abstract method (must be overridden)
- (Deck *)createDeck
{
    return nil;
}

// Default implementation (could be overridden)
- (NSString *)faceUpBackgroundImageNameForCard:(Card *)card
{
    return @"CardFront";
}

// Default implementation (could be overridden)
- (NSString *)faceDownBackgroundImageNameForCard:(Card *)card
{
    return @"CardBack";
}

// We use a 2-card game by default (could be overridden)
- (NSUInteger)numberOfCardsInChoice
{
    return 2;
}

// Default implementation simply prints card contents (could be overridden)
- (NSAttributedString *)faceUpTitleForCard:(Card *)card
{
    return [[NSAttributedString alloc] initWithString: card.contents];
}

// Default implementation simply prints nothing (could be overridden)
- (NSAttributedString *)faceDownTitleForCard:(Card *)card
{
    return [[NSAttributedString alloc] initWithString: @""];
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    return card.isChosen ? [self faceUpTitleForCard:card] : [self faceDownTitleForCard:card];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? [self faceUpBackgroundImageNameForCard:card] : [self faceDownBackgroundImageNameForCard:card]];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self saveLastOutcome];
    [self updateUI];
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    self.game = nil;
    self.previousOutcomes = nil;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    
    self.lastChoiceOutcomeLabel.attributedText = self.lastOutcome;
    self.lastChoiceOutcomeLabel.alpha = 1;
}

- (NSMutableArray *)previousOutcomes
{
    if (!_previousOutcomes) _previousOutcomes = [[NSMutableArray alloc] init];
    return _previousOutcomes;
}

- (void)saveLastOutcome
{
    // Generate string for outcome, with placeholder for card titles
    NSString *outcomeString;
    if (self.game.lastChoiceOutcome == NoOutcome) {
        outcomeString = @"[CARDS]";
    } else if (self.game.lastChoiceOutcome == MatchOutcome) {
        outcomeString = [NSString stringWithFormat:@"Matched [CARDS] for %d points.", self.game.lastScoreChange];
    } else if (self.game.lastChoiceOutcome == MismatchOutcome) {
        outcomeString = [NSString stringWithFormat:@"[CARDS] don't match! %d point penalty.", self.game.lastScoreChange];
    }
    NSMutableAttributedString *outcomeAttributedString = [[NSMutableAttributedString alloc] initWithString:outcomeString];
    
    // Generate attributed string of card titles
    NSMutableAttributedString *cardsAttributedString = [[NSMutableAttributedString alloc] init];
    for (Card *card in self.game.lastFaceUpCards) {
        [cardsAttributedString appendAttributedString:[self faceUpTitleForCard:card]];
        if ([self.game.lastFaceUpCards indexOfObject:card] != [self.game.lastFaceUpCards count] - 1)
            [cardsAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    // Replace placeholder in outcome string
    NSRange cardsRange = [outcomeString rangeOfString:@"[CARDS]"];
    [outcomeAttributedString replaceCharactersInRange:cardsRange withAttributedString:cardsAttributedString];
    UIFontDescriptor *bodyDescriptor = [UIFontDescriptor
                                        preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    [outcomeAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont fontWithDescriptor:bodyDescriptor size:13]
                                    range:NSMakeRange(0, [outcomeAttributedString.string length])];
    
    self.lastOutcome = outcomeAttributedString;
    // If the outcome is either a match or a mismatch, store it in previousOutcomes
    if (self.game.lastChoiceOutcome == MatchOutcome || self.game.lastChoiceOutcome == MismatchOutcome)
        [self.previousOutcomes addObject:outcomeAttributedString];
}

@end
