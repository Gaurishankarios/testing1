//
//  SearchResultsView.m
//  Byte Me
//
//  Created by Leandro Marques on 18/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "SearchResultsView.h"
#import "MainCollectionViewCell.h"
#import "SubCollectionViewCell.h"
#import "ByteCollectionViewCell.h"
#import "CInterpolator.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CCoverflowCollectionViewLayout.h"
#import "CCoverflowVerticalCollectionViewLayout.h"
#import "CCoverflowByteCollectionViewLayout.h"
#import "Constants.h"
#import "ByteUIView.h"
#import "CCARadialGradientLayer.h"
#import "SettingsManager.h"


/*
 #import "GAI.h"
 #import "GAIDictionaryBuilder.h"
 */


@import AudioToolbox;
@import AssetsLibrary;
@import Photos;

@interface SearchResultsView ()
/*
@property (nonatomic) BOOL isByteUIVisible;

//@property (nonatomic) NSArray *mainObjects;
@property (nonatomic) NSMutableArray *mainObjects;
@property (readwrite, nonatomic, strong) CInterpolator *positionoffsetInterpolator;
//@property (nonatomic) UIVisualEffectView *visualEffectView;
@property (nonatomic) NSURL *videoPath;
@property (nonatomic) NSString *videoName;
*/

@end

@implementation SearchResultsView


- (void)awakeFromNib {
    
    
    //NSLog(@"search awakeFromNib");

    [super awakeFromNib];

    self.mainCollectionView.transform = CGAffineTransformMakeScale(0.85f, 0.85f);

}




-(void) initView
{
    self.isViewLoaded = YES;
    //[self fadeView:(UIView*)_visualEffectView toAlpha:0 withSpeed:0];
    //[self initScrollOffsets];
}

-(void) updateResultsWithArray:(NSMutableArray*) array
{
    self.mainObjects = [[SettingsManager sharedSettings] getFormatedBytesSearchResultsWithArray:array];
    [self.mainCollectionView reloadData];
    [self onBackButtonPressed:nil];
}











-(void) toggleBlurEffect
{
    
    if(self.isByteUIVisible)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBlurEffect" object:nil userInfo:nil];

        //[self fadeView:(UIView*)_visualEffectView toAlpha:1.0f withSpeed:fadeSpeed*0.5f];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideBlurEffect" object:nil userInfo:nil];

        //[self fadeView:(UIView*)_visualEffectView toAlpha:0 withSpeed:fadeSpeed*0.5f];
    }
}


-(void) toggleSaveButtonPress:(NSNotification *)notis
{
    NSLog(@"search toggleSaveButtonPress");
    [self onSaveButtonDown:nil];
}



@end
