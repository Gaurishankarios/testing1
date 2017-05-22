//
//  MainView.h
//  Byte Me
//
//  Created by Leandro Marques on 07/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardDataUIView.h"

//@class ByteUIView;
//@class CInterpolator;

//@interface MainView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
@interface MainView : KeyboardDataUIView <UICollectionViewDataSource, UICollectionViewDelegate>
/*
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (weak, nonatomic) IBOutlet ByteUIView *byteUI;
@property (weak, nonatomic) IBOutlet UICollectionView *platformCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconYConstraint;


@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *backspaceButton;
@property (strong, nonatomic) IBOutlet UIButton *nextKeyboardButton;
@property (strong, nonatomic) IBOutlet UIButton *alphaNumericButton;

@property (nonatomic) BOOL isViewLoaded;
@property (nonatomic) BOOL isViewVisible;

@property (nonatomic) BOOL isByteUIVisible;
@property (nonatomic) NSMutableArray *mainObjects;
@property (readwrite, nonatomic, strong) CInterpolator *positionoffsetInterpolator;
@property (nonatomic) UIVisualEffectView *visualEffectView;
@property (nonatomic) NSURL *videoPath;
@property (nonatomic) NSString *videoName;
*/
/*
-(void) interpolateFromCenterColor:(UIColor*)f to:(UIColor*)t edgeFrom:(UIColor*)ef  edgeTo:(UIColor*)et progress:(float) p;
-(void)updateUIButtons:(UIColor*)f to:(UIColor*)t progress:(float) p;
-(void) initScrollOffsets;
-(void) initView;
 */

@end
