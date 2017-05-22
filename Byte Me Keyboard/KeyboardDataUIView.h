//
//  KeyboardDataUIView.h
//  Byte Me
//
//  Created by Leandro Marques on 25/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ByteUIView;
@class CInterpolator;

@interface KeyboardDataUIView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
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

@property (nonatomic) NSMutableArray *colourArray;
@property (nonatomic) NSMutableArray *mainObjects;
@property (readwrite, nonatomic, strong) CInterpolator *positionoffsetInterpolator;
@property (nonatomic) UIVisualEffectView *visualEffectView;
@property (nonatomic) NSURL *videoPath;
@property (nonatomic) NSString *videoName;

-(void) interpolateFromCenterColor:(UIColor*)f to:(UIColor*)t edgeFrom:(UIColor*)ef  edgeTo:(UIColor*)et progress:(float) p;
-(void)updateUIButtons:(UIColor*)f to:(UIColor*)t progress:(float) p;
-(void) initScrollOffsets;
-(void) initView;
-(void) updateFrequentBytes;
-(void) getSelectedItemMain;
-(IBAction)onBackButtonPressed:(id)sender;
- (void)fadeView:(UIView*)view toAlpha:(CGFloat)alpha withSpeed:(CGFloat)speed;
-(void) copyVideo;
-(void) onVideoCopyReady;
-(void) onVideoSavedReady;
-(void) toggleBlurEffect;
-(void) toggleByteUI:(NSNotification *)notis;
-(void) toggleByteUIPressBegan:(NSNotification *)notis;
-(void) toggleByteUIPressEnd:(NSNotification *)notis;
- (IBAction)onSaveButtonDown:(id)sender;
- (void)resetBytes;
-(void) updateColourArray;
- (BOOL)testFullAccess;
@end
