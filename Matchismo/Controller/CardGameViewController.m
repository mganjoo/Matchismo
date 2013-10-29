 //
//  CardGameViewController.m
//  Matchismo
//
//  Created by Milind Ganjoo on 9/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardGameViewController.h"
#import "Grid.h"

@interface CardGameViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cardViews; // of CardView
@property (strong, nonatomic) Grid *grid;

// Dynamic animator stuff
@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) UIDynamicAnimator *cardGatheringAnimator;
@property (strong, nonatomic) NSMutableArray *gatheringAttachments; // of UIAttachmentBehavior

// UI elements
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardsPlaceholderView;

@end

#define DEFAULT_NUMBER_OF_CARDS_IN_CHOICE 2
#define DEFAULT_NUMBER_OF_CARDS_IN_PLAY  10

@implementation CardGameViewController

- (void)viewDidAppear:(BOOL)animated
{
    // Set up gesture recognizers for dynamic behavior
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(handleCardPlaceholderPinch:)];

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(handleCardPlaceholderPan:)];
    panRecognizer.minimumNumberOfTouches = 2;
    
    pinchRecognizer.delegate = self;
    panRecognizer.delegate = self;
    
    [self.cardsPlaceholderView addGestureRecognizer:panRecognizer];
    [self.cardsPlaceholderView addGestureRecognizer:pinchRecognizer];
}

- (void)viewDidLayoutSubviews
{
    [self updateUI];
}

// Abstract method (must be overridden)
- (Deck *)createDeck
{
    return nil;
}

// Abstract method (must be overridden)
- (CardView *)createViewForCard:(Card *)card
{
    return nil;
}

// Abstract method (must be overridden)
- (void)updateTappedCardView:(CardView *)cardView forOutcome:(ChoiceOutcome)outcome
{
}

// Abstract method (must be overridden)
- (void)updateOpenCardView:(CardView *)cardView forOutcome:(ChoiceOutcome)outcome
{
}

- (void)handleCardTouch:(UITapGestureRecognizer *)gestureRecognizer
{
    CardView *cardView = (CardView *)gestureRecognizer.view;
    int i = [self.cardViews indexOfObject:cardView];
    
    // Perform selection of card
    [self.game chooseCardAtIndex:i];
    
    // Perform any visual updates if necessary
    [self updateTappedCardView:cardView forOutcome:self.game.lastChoiceOutcome];

    // If it was a match or mismatch, we also want to update the others
    if (self.game.lastChoiceOutcome != NoOutcome) {
        for (NSNumber *index in [self.game lastFaceUpCardIndices]) {
            CardView *otherCardView = self.cardViews[[index integerValue]];
            
            if (otherCardView != cardView)
                [self updateOpenCardView:otherCardView forOutcome:self.game.lastChoiceOutcome];

            // Disable tap gestures if matched
            if (self.game.lastChoiceOutcome == MatchOutcome)
                for (UIGestureRecognizer *recognizer in cardView.gestureRecognizers)
                    if ([recognizer isKindOfClass:[UITapGestureRecognizer class]])
                        recognizer.enabled = NO;
        }
    }
    
    [self updateUI];
}

// Default implementation assumes 10 cards (could be overridden)
- (NSUInteger)numberOfInitialCardsInPlay
{
    return DEFAULT_NUMBER_OF_CARDS_IN_PLAY;
}

// We use a 2-card game by default (could be overridden)
- (NSUInteger)numberOfCardsInChoice
{
    return DEFAULT_NUMBER_OF_CARDS_IN_CHOICE;
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    [self redeal];
}

- (void)redeal {
    // Schedule all cards (old and new; doesn't matter) for removal
    for (CardView *cardView in self.cardViews)
        cardView.needsRemoval = YES;
    [self updateUI];
}

// Animation options
#define CARD_ARRIVAL_DURATION       1.0
#define CARD_REMOVAL_DURATION       1.0
#define CARD_ARRIVAL_SPRING_DAMPING 0.6
#define NEW_CARD_ARRIVAL_DELAY_START     0.3
#define NEW_CARD_ARRIVAL_DELAY_BASE_STEP 0.1
#define NEW_CARD_ARRIVAL_DELAY_STEP      0.03
#define NEW_CARD_VIEW_OFFSET_FRACTION    0.3

- (void)updateUI
{
    // We only collect the cards we are showing
    NSMutableArray *cardsToShow = [[NSMutableArray alloc] init];
    NSMutableArray *cardsToRemove = [[NSMutableArray alloc] init];
    for (CardView *view in [self activeCardViews]) {
        CardView *cardView = (CardView *)view;
        if ([cardView needsRemoval]) {
            [cardsToRemove addObject:cardView];
        } else {
            [cardsToShow addObject:cardView];
        }
    }
    
    // Animation delays
    // We want the baseDelay to exist only if there are NO existing cards, i.e.
    // new ones will be created
    float baseDelay = [cardsToShow count] > 0 ? 0 : NEW_CARD_ARRIVAL_DELAY_START;
    float currentBaseDelay = baseDelay;
    float currentDelay;

    
    if ([cardsToRemove count] > 0)
        [self animateAndRemoveCards:cardsToRemove];
    
    if ([cardsToShow count] == 0) {
        // There are no cards to show, i.e. we must reset game and cardViews
        self.cardViews = nil;
        self.game = nil;
        
        // No cards to show: add new ones
        for (int i = 0; i < [self numberOfInitialCardsInPlay]; i++) {
            [self createAndAddCardView:[self.game cardAtIndex:i]];
        }
        cardsToShow = self.cardViews;
    }

    // Update grid with current parameters
    self.grid.cellAspectRatio = CARD_ASPECT_RATIO;
    self.grid.size = self.cardsPlaceholderView.bounds.size;
    self.grid.minimumNumberOfCells = [cardsToShow count];
    
    // Draw cards
    int row = 0, col = 0;
    for (CardView *cardView in cardsToShow) {
        if (cardView.center.y < self.cardsPlaceholderView.bounds.origin.y
            && cardView.center.x > self.cardsPlaceholderView.bounds.origin.x
            + self.cardsPlaceholderView.bounds.size.width * (1 + NEW_CARD_VIEW_OFFSET_FRACTION / 2)) {
            // If card is new (i.e. out of bounds) add a slight delay effect to simulate "dealing"
            currentDelay = currentBaseDelay;
            currentBaseDelay += NEW_CARD_ARRIVAL_DELAY_STEP;
        } else {
            currentDelay = 0;
        }
        // Animate arrival
        [UIView animateWithDuration:CARD_ARRIVAL_DURATION
                              delay:currentDelay
             usingSpringWithDamping:CARD_ARRIVAL_SPRING_DAMPING
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             cardView.center = [self.grid centerOfCellAtRow:row inColumn:col];
                             cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
                         }
                         completion:nil];
        [cardView setNeedsDisplay];

        col++;
        if (col >= [self.grid columnCount]) {
            col = 0;
            row++;
            if (currentBaseDelay >= baseDelay + NEW_CARD_ARRIVAL_DELAY_STEP) {
                baseDelay += NEW_CARD_ARRIVAL_DELAY_BASE_STEP;
                currentBaseDelay = baseDelay;
            }
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self numberOfInitialCardsInPlay]
                                                  usingDeck:[self createDeck]
                                      numberOfCardsInChoice:[self numberOfCardsInChoice]];
    }
    return _game;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

- (Grid *)grid
{
    if (!_grid) _grid = [[Grid alloc] init];
    return _grid;
}

// Add cards to play and return number of cards successfully added
- (int)addCardsToPlay:(NSUInteger)numToAdd
{
    int i;
    for (i = 0; i < numToAdd; i++) {
        int index = [self.game addCardToPlayAndGetIndex];
        if (index < 0) break;
        [self createAndAddCardView:[self.game cardAtIndex:index]];
    }
    if (i > 0) [self updateUI];
    return i;
}

- (NSArray *)activeCardViews
{
    NSMutableArray *activeViews = [[NSMutableArray alloc] init];
    for (UIView *view in [self.cardsPlaceholderView subviews]) {
        if ([view isKindOfClass:[CardView class]]) {
            [activeViews addObject:view];
        }
    }
    return activeViews;
}

#pragma Mark - Creating, removing and animating cards

#define NEW_CARD_VIEW_OFFSET_FRACTION 0.3

// Add cards to superview, and set up for animation
- (void)createAndAddCardView:(Card *)card
{
    CardView *cardView = [self createViewForCard:card];
    [self.cardViews addObject:cardView];
    [self.cardsPlaceholderView addSubview:cardView];
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleCardTouch:)];
    [cardView addGestureRecognizer:recognizer];
    
    // Start at top right (outside view)
    cardView.center = CGPointMake(self.cardsPlaceholderView.bounds.origin.x
                                  + self.cardsPlaceholderView.bounds.size.width * (1 + NEW_CARD_VIEW_OFFSET_FRACTION),
                                  self.cardsPlaceholderView.bounds.origin.y
                                  - self.cardsPlaceholderView.bounds.size.height * NEW_CARD_VIEW_OFFSET_FRACTION);
}

- (void)animateAndRemoveCards:(NSArray *)cardsToRemove
{
    [UIView animateWithDuration:CARD_REMOVAL_DURATION
                     animations:^{
                        for (CardView *cardView in cardsToRemove) {
                            // Move card to random x coordinate below screen
                            int x = ((arc4random() % (int)(self.cardsPlaceholderView.bounds.size.width * 4))
                                     - (int)self.cardsPlaceholderView.bounds.size.width * 2);
                            cardView.center = CGPointMake(x, 2 * self.cardsPlaceholderView.bounds.size.height);
                        }
                     }
                     completion:^(BOOL finished) {
                         [cardsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }
     ];
}

#pragma Mark - Pinching & collecting cards

- (UIDynamicAnimator *)cardGatheringAnimator
{
    if (!_cardGatheringAnimator) {
        _cardGatheringAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardsPlaceholderView];
    }
    return _cardGatheringAnimator;
}

- (NSMutableArray *)gatheringAttachments
{
    if (!_gatheringAttachments)
        _gatheringAttachments = [[NSMutableArray alloc] init];
    return _gatheringAttachments;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleCardPlaceholderPinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    CGPoint gesturePoint = [gestureRecognizer locationInView:self.cardsPlaceholderView];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self gatherCardsToPoint:gesturePoint];
            break;
        case UIGestureRecognizerStateChanged:
            [self updateCardsAttachmentDistanceByScale:gestureRecognizer.scale];
            gestureRecognizer.scale = 1;
            break;
        case UIGestureRecognizerStateEnded:
            [self releaseAttachedCards];
            break;
        default:
            break;
    }
}

- (void)handleCardPlaceholderPan:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint gesturePoint = [gestureRecognizer locationInView:self.cardsPlaceholderView];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateChanged:
            [self updateCardsAttachmentAnchor:gesturePoint];
            break;
        default:
            break;
    }
}

- (void)gatherCardsToPoint:(CGPoint)gatherPoint
{
    for (CardView *cardView in [self activeCardViews]) {
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView
                                                                     attachedToAnchor:gatherPoint];
        
        [self.gatheringAttachments addObject:attachment];
        [self.cardGatheringAnimator addBehavior:attachment];
    }
}

- (void)updateCardsAttachmentDistanceByScale:(CGFloat)scale
{
    for (UIAttachmentBehavior *attachment in self.gatheringAttachments) {
        attachment.length *= scale;
    }
}

- (void)updateCardsAttachmentAnchor:(CGPoint)anchor
{
    for (UIAttachmentBehavior *attachment in self.gatheringAttachments) {
        attachment.anchorPoint = anchor;
    }
}

- (void)releaseAttachedCards
{
    for (UIAttachmentBehavior *attachment in self.gatheringAttachments) {
        [self.cardGatheringAnimator removeBehavior:attachment];
    }
    self.gatheringAttachments = nil;
    [self updateUI];
}

@end
