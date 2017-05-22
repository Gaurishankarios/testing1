//
//  TutorialCustomiseCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 05/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "TutorialCustomiseCollectionViewCell.h"
#import "Constants.h"
#import "ContentViewController.h"
#import "SettingsManager.h"

@implementation TutorialCustomiseCollectionViewCell
@synthesize delegate;

- (void)awakeFromNib {

    [self setBackgroundColor:linkTintColor];
    
    [self.title setTextColor:tutorialTitleTextColor];
    [self.title setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialTitleSmallerTextFontSize]];
    [self.title setText:@"CUSTOMISE KEYBOARD"];
    
    
    [self.subTitle setTextColor:tutorialSubTitleTextColor];
    [self.subTitle setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialSubTitleTextFontSize]];
    [self.subTitle setText:@"Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit."];
    
    
    if([[SettingsManager sharedSettings] hasTutorialDone])
        [self.settingsButton setHidden:YES];
        
    [self.settingsButton setTitleColor:tutorialButtonLabelColour forState:UIControlStateNormal];
    [self.settingsButton setTitle:@"Get More Bytes Now" forState:UIControlStateNormal];
    [self.settingsButton.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialButtonFontSize]];
    self.settingsButton.layer.cornerRadius = tutorialButtonBorderRadius;
    [self.settingsButton setBackgroundColor:tutorialButtonBackgroundColour];
    
}
- (IBAction)handleSettingsButtonDown:(id)sender
{
    [[SettingsManager sharedSettings] setHasTutorialDone:YES];
    [[SettingsManager sharedSettings] saveSettings];
    
    [(ContentViewController*)self.delegate showHome];
}

@end
