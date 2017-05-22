//
//  MyBytesCollectionHeaderCell.m
//  Byte Me
//
//  Created by Leandro Marques on 24/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "MyBytesCollectionHeaderCell.h"
#import "SettingsManager.h"
#import "Constants.h"

@interface MyBytesCollectionHeaderCell ()
@property (nonatomic) UIView *separatorLineView;
@end


@implementation MyBytesCollectionHeaderCell

- (void)awakeFromNib {
    
    [self.bytesInstalledCount setTextColor:myBytesLabelColor];
    [self.bytesInstalledCount setFont:[UIFont fontWithName:@"Quicksand-Bold" size:myBytesCountFontSize]];

    [self.bytesEnabledCount setTextColor:myBytesLabelColor];
    [self.bytesEnabledCount setFont:[UIFont fontWithName:@"Quicksand-Bold" size:myBytesCountFontSize]];

    [self.bytesInstalledLabel setTextColor:myBytesLabelColor];
    [self.bytesInstalledLabel setFont:[UIFont fontWithName:@"Quicksand-Regular" size:myBytesLabelFontSize]];

    [self.bytesEnabledLabel setTextColor:myBytesLabelColor];
    [self.bytesEnabledLabel setFont:[UIFont fontWithName:@"Quicksand-Regular" size:myBytesLabelFontSize]];
    
    // separator
    if(!self.separatorLineView)
    {
        self.separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.2f, myBytesHeaderCellHeight*0.5f,SCREEN_WIDTH*0.6f, menuSeparatorThickness)];
        self.separatorLineView.backgroundColor = categorySeparatorColor;
        [self addSubview:self.separatorLineView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyBytesHeader:) name:@"updateMyBytesHeader" object:nil];

}

-(void) initHeader
{
    [self.bytesInstalledCount setText:[NSString stringWithFormat:@"%d", [[SettingsManager sharedSettings] getBytesAddedCount]]];
    [self.bytesEnabledCount setText:[NSString stringWithFormat:@"%d", [[SettingsManager sharedSettings] getBytesEnabledCount]]];
    [self.bytesInstalledLabel setText:@"TOTAL BYTES"];
    [self.bytesEnabledLabel setText:@"ACTIVE BYTES"];
}

-(void) updateMyBytesHeader:(NSNotification *)notis
{
    [self.bytesEnabledCount.layer removeAllAnimations];
    
    [UIView animateWithDuration:thumbTransitionTime*0.5f delay:0 options:0   animations:^{
        [self.bytesEnabledCount setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
        [self.bytesEnabledCount setTextColor:myBytesLabelBrightColor];
    } completion:^(BOOL finished) {
        [self.bytesEnabledCount setText:[NSString stringWithFormat:@"%d", [[SettingsManager sharedSettings] getBytesEnabledCount]]];

        [UIView animateWithDuration:thumbTransitionTime*0.5f  delay:0 options:0   animations:^{
            [self.bytesEnabledCount setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
            [self.bytesEnabledCount setTextColor:myBytesLabelColor];

        } completion:^(BOOL finished) {}];
    }];

}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
