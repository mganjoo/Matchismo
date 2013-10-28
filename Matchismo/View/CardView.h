//
//  CardView.h
//  Matchismo
//
//  Created by Milind Ganjoo on 10/27/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

// Scaling factor for the card's rounded corner
- (CGFloat)cornerScaleFactor;

// Scaled value of the corner radius
- (CGFloat)cornerRadius;

@end
