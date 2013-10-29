//
//  SetCardView.h
//  Matchismo
//
//  Created by Milind Ganjoo on 10/27/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
#import "SetCard.h"

@interface SetCardView : CardView

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardColor color;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardShape shape;
@property (nonatomic) BOOL chosen;

// Methods for animation
- (void)toggleChosen;

@end
