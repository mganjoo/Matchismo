//
//  ViewController.m
//  SuperCard
//
//  Created by CS193p Instructor on 10/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ViewController.h"
#import "SetCardView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.setCardView.number = 3;
    self.setCardView.shape = SquiggleShape;
    self.setCardView.color = GreenColor;
    self.setCardView.shading = StripedShading;
}

@end
