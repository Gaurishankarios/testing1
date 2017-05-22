//
//  TutorialKeyboardCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 04/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "TutorialKeyboardCollectionViewCell.h"
#import "Constants.h"
#import "Mixpanel.h"

@implementation TutorialKeyboardCollectionViewCell

- (void)awakeFromNib {
    
    [self setBackgroundColor:linkTintColor];
    
    [self.title setTextColor:tutorialTitleTextColor];
    [self.title setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialTitleSmallerTextFontSize]];
    [self.title setText:@"INSTALL THE KEYBOARD"];
    
    
    [self.subTitle setTextColor:tutorialSubTitleTextColor];
    [self.subTitle setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialSubTitleTextFontSize]];
    [self.subTitle setText:@"Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit."];
    
    
    
    [self.settingsButton setTitleColor:tutorialButtonLabelColour forState:UIControlStateNormal];
    [self.settingsButton setTitle:@"Open Settings" forState:UIControlStateNormal];
    [self.settingsButton.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialButtonFontSize]];
    self.settingsButton.layer.cornerRadius = tutorialButtonBorderRadius;
    [self.settingsButton setBackgroundColor:tutorialButtonBackgroundColour];
    
}
- (IBAction)handleSettingsButtonDown:(id)sender
{
    NSURL *settingsURL = [NSURL URLWithString:@"prefs:root=General&path=Keyboard/KEYBOARDS"];
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Open Phone Settings Clicked" properties:@{
                                                 @"Component": @"Container"
                                                 }];

     if(settingsURL)
     {
         [[UIApplication sharedApplication] openURL:settingsURL];
     }
}



@end
