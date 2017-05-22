//
//  TutorialEndCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 04/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "TutorialEndCollectionViewCell.h"
#import "Constants.h"

@implementation TutorialEndCollectionViewCell

- (void)awakeFromNib {
    
    [self setBackgroundColor:linkTintColor];
    
    [self.title setTextColor:tutorialTitleTextColor];
    [self.title setFont:[UIFont fontWithName:@"Quicksand-Bold" size:tutorialTitleTextFontSize]];
    [self.title setText:@"THAT'S IT!"];
}
@end
