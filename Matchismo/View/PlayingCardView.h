//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor on 10/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL disabled;

// Methods for animation/transition
- (void)flip;
- (void)dim;

@end
