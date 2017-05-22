//
//  MainView.m
//  Byte Me
//
//  Created by Leandro Marques on 07/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "MainView.h"

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

@interface MainView ()

//@property (nonatomic) NSArray *mainObjects;


@end

@implementation MainView


- (void)awakeFromNib {
    
    /*
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:@"savedPlatform"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    
    self.positionoffsetInterpolator = [[CInterpolator interpolatorWithDictionary:@{
                                                                               @(-0.8f):               @(60.0f)
                                                                               }] interpolatorWithReflection:YES];
    
    self.isByteUIVisible = false;
    [self fadeView:(UIView*)self.byteUI toAlpha:0 withSpeed:0];
    [self fadeView:(UIView*)self.statusLabel toAlpha:0 withSpeed:0];
    [self fadeView:(UIView*)self.saveButton toAlpha:0 withSpeed:0];
    [self fadeView:(UIView*)self.platformCollectionView toAlpha:0 withSpeed:0];
    [self fadeView:(UIView*)self.closeButton toAlpha:0 withSpeed:0];

    [self fadeView:(UIView*)self.icon toAlpha:0 withSpeed:0];

    [self.saveButton setHidden:YES];
    
    
    [self initUIButtons];
    
    
    //NSLog(@"mainObjects %@",self.mainObjects);
   
    
    
    // bkg
    [self setBackgroundColor:mainBkgColor];
    [self.mainCollectionView setBackgroundColor:[UIColor clearColor]];
    [self updateBackgroundColor:mainBkgColor edge:mainBkgColor];
    

    
    // events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleByteUI:) name:@"toggleByteUI" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleByteUIPressBegan:) name:@"toggleByteUIPressBegan" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleByteUIPressEnd:) name:@"toggleByteUIPressEnd" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSaveButtonPress:) name:@"toggleSaveButtonPress" object:nil];
    
    
    

    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualEffectView.frame = self.contentView.bounds;
     [self.contentView addSubview:self.visualEffectView];
    
    
    //[self.alphaNumericButton.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Regular" size:keyboardAlphaNumericFontSize]];
    //[self.alphaNumericButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-NRegular" size:keyboardAlphaNumericFontSize]];

    self.saveButton.layer.cornerRadius = tileBorderRadiusSmall;
    self.saveButton.layer.masksToBounds = YES;

    
    */
   // NSLog(@"main awakeFromNib");

    [super awakeFromNib];
    
    self.mainObjects = [[SettingsManager sharedSettings] getBytesEnabledForKeyboard];
    [self updateColourArray];

    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualEffectView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH);
    [self.contentView addSubview:self.visualEffectView];
        
    self.mainCollectionView.transform = CGAffineTransformMakeScale(0.975f, 0.975f);

}

-(void) initView
{
    self.isViewLoaded = YES;
    [self fadeView:(UIView*)self.visualEffectView toAlpha:0 withSpeed:0.3f];
    //[self initScrollOffsets];
}



-(void) toggleByteUI:(NSNotification *)notis
{
    if(self.isViewVisible)
        [super toggleByteUI:notis];
}

-(void) toggleByteUIPressBegan:(NSNotification *)notis
{
    if(self.isViewVisible)
        [super toggleByteUIPressBegan:notis];
}

-(void) toggleByteUIPressEnd:(NSNotification *)notis
{
    if(self.isViewVisible)
        [super toggleByteUIPressEnd:notis];
    
}

-(void) toggleSaveButtonPress:(NSNotification *)notis
{
    if(self.isViewVisible)
    {
       // NSLog(@"main toggleSaveButtonPress");

        [self onSaveButtonDown:nil];
    }
}

@end
