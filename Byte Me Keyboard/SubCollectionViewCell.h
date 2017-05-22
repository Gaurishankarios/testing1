//
//  SubItemCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 08/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MediaPlayer;
@interface SubCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *video;
@property (weak, nonatomic) IBOutlet UIView *shield;
@property (weak, nonatomic) IBOutlet UIView *shadow;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) UIColor *themeColor;
@property (weak, nonatomic) UICollectionView *parentCollectionView;
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSURL *videoPath;
@property (strong, nonatomic) NSString *videoName;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic) NSMutableDictionary *data;

//-(void) initCellWithData:(NSArray*)data;
-(void) initCellWithData:(NSMutableDictionary *)data;
-(void) toggleSubCellsHidden:(BOOL) hidden hideBytes:(BOOL) bytes;
-(void) toggleCellHidden:(BOOL)h;
-(void) playVideo;
-(void) stopVideo;
-(void) enabledGestures:(BOOL) enable;
@end
