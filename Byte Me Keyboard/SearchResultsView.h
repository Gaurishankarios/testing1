//
//  SearchResultsView.h
//  Byte Me
//
//  Created by Leandro Marques on 18/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardDataUIView.h"

//@class ByteUIView;

//@interface SearchResultsView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
@interface SearchResultsView : KeyboardDataUIView <UICollectionViewDataSource, UICollectionViewDelegate>
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
@property (nonatomic) BOOL isViewLoaded;
 */
/*

-(void) interpolateFromCenterColor:(UIColor*)f to:(UIColor*)t edgeFrom:(UIColor*)ef  edgeTo:(UIColor*)et progress:(float) p;
-(void)updateUIButtons:(UIColor*)f to:(UIColor*)t progress:(float) p;
-(void) initScrollOffsets;
-(void) initView;
 */
-(void) updateResultsWithArray:(NSMutableArray*) array;
@end
