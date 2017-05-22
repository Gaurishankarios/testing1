//
//  PlatformCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 21/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "PlatformCollectionViewCell.h"
#import "Constants.h"
#import "UIImage+ColouredImage.h"

@implementation PlatformCollectionViewCell


- (void)awakeFromNib {
    
    self.layer.cornerRadius = tileBorderRadius;
    self.layer.masksToBounds = YES;
}


#pragma mark -
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        /*
        [self.image setAlpha:0];
        UIImage *image = [UIImage imageNamed:self.imageName];
        [self.image setImage:image];
        */
        
        [UIView animateWithDuration:platSelectionFadeSpeed animations:^{
            //[self.image setAlpha:1];
            self.layer.backgroundColor = platSelectedColor.CGColor;
        }];
        
    }
    else
    {
        /*
        [self.image setAlpha:0];
        UIImage *image = [UIImage imageNamed:self.imageName withColor:platSelectedColorOverlay];
        [self.image setImage:image];
         */
        
        [UIView animateWithDuration:platSelectionFadeSpeed animations:^{
            
            //[self.image setAlpha:1];
            self.layer.backgroundColor = [UIColor clearColor].CGColor;
        }];
    }
    
}

@end
