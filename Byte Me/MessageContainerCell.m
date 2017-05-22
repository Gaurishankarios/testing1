//
//  MessageContainerCell.m
//  Byte Me
//
//  Created by Leandro Marques on 05/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "MessageContainerCell.h"
#import "Constants.h"

@implementation MessageContainerCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.label setTextColor:messageLabelColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:messageLabelFontSize]];
    [self setBackgroundColor:globalBackgroundColor];
    [self.label setText:[@">" uppercaseString]];
    
    [self.button setTitleColor:messageButtonLabelColour forState:UIControlStateNormal];
    [self.button setTitle:@"Check Network Settings" forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialButtonFontSize]];
    self.button.layer.cornerRadius = tutorialButtonBorderRadius;
    [self.button setBackgroundColor:messageButtonBackgroundColour];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleSettingsButtonDown:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Settings"]];
}

@end
