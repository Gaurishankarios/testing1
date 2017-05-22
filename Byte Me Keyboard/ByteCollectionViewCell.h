//
//  ByteCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 13/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@import MediaPlayer;

@interface ByteCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *shield;
@property (weak, nonatomic) IBOutlet UIView *shadow;
@property (weak, nonatomic) IBOutlet UIView *video;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) NSURL *videoPath;
@property (strong, nonatomic) NSString *videoName;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic) NSMutableDictionary *data;


//-(void) initCellWithData:(NSArray*)data;
-(void) initCellWithData:(NSMutableDictionary *)data;
-(void) toggleCellHidden:(BOOL)h;
-(void) playVideo;
-(void) stopVideo;
-(void) enabledGestures:(BOOL) enable;
@end
