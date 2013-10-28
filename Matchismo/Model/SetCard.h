//
//  SetCard.h
//  Matchismo
//
//  Created by Milind Ganjoo on 10/13/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "Card.h"

// Maximum number for a Set card
extern const int NUMBER_OF_SET_FEATURES_PER_TYPE;

// Definitions for feature enums. The values in
// each enum are guaranteed to be in the range
// [1, NUMBER_OF_SET_FEATURES_PER_TYPE].

typedef NS_ENUM(NSUInteger, SetCardColor) {
    UnknownColor = 0,
    RedColor,
    GreenColor,
    PurpleColor
};

typedef NS_ENUM(NSUInteger, SetCardShading) {
    UnknownShading = 0,
    SolidShading,
    StripedShading,
    OpenShading
};

typedef NS_ENUM(NSUInteger, SetCardShape) {
    UnknownShape = 0,
    SquiggleShape,
    OvalShape,
    DiamondShape
};

@interface SetCard : Card

@property (nonatomic) SetCardColor color;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardShape shape;
@property (nonatomic) NSUInteger number;

@end
