//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Milind Ganjoo on 10/13/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *historyView;

@end

@implementation HistoryViewController

- (void)setPreviousOutcomes:(NSArray *)previousOutcomes;
{
    _previousOutcomes = previousOutcomes;
    if (self.view.window) [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    NSMutableAttributedString *fullText = [[NSMutableAttributedString alloc] initWithString:@""];
    int index = 1;
    for (NSAttributedString *outcome in self.previousOutcomes) {
        [fullText appendAttributedString:[[NSAttributedString alloc]
                                          initWithString:[NSString stringWithFormat:@"%d. ", index]]];
        [fullText appendAttributedString:outcome];
        if ([self.previousOutcomes indexOfObject:outcome] != [self.previousOutcomes count] - 1)
            [fullText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        index++;
    }
    [self.historyView setAttributedText:fullText];
}

@end
