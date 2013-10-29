//
//  CardView.h
//  Matchismo
//
//  Created by Milind Ganjoo on 10/27/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const float CARD_ASPECT_RATIO;

@interface CardView : UIView

@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic, readonly) UIColor *defaultStrokeColor;
@property (strong, nonatomic, readonly) UIColor *defaultFillColor;

// Scaled value of the corner radius
@property (nonatomic, readonly) CGFloat cornerRadius;

// Does the card need to be removed from play in the next UI update?
@property (nonatomic) BOOL needsRemoval;

// Subclasses can override this to change contents
- (void)drawContents:(CGRect)rect;

@end
