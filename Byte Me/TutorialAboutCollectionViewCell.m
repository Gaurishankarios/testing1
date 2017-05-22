//
//  TutorialAboutCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 04/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "TutorialAboutCollectionViewCell.h"
#import "Constants.h"

@implementation TutorialAboutCollectionViewCell

- (void)awakeFromNib {
    
    [self setBackgroundColor:linkTintColor];
    
    [self.title setTextColor:tutorialTitleTextColor];
    [self.title setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialTitleTextFontSize]];
    [self.title setText:@"BYTE.ME KEYBOARD"];
    
    
    [self.subTitle setTextColor:tutorialSubTitleTextColor];
    [self.subTitle setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialSubTitleTextFontSize]];
    [self.subTitle setText:@"Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit."];

}


@end
