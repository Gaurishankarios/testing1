//
//  ByteViewController.h
//  Byte Me
//
//  Created by Leandro Marques on 14/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTagList.h"
@import MediaPlayer;
@import AVFoundation;
@import AVKit;
@interface ByteViewController : UITableViewController<DWTagListDelegate>
@property  (nonatomic) NSDictionary *byteData;
@property  (nonatomic) NSArray *bytesData;
@property  (nonatomic) int selected;

@property (nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) IBOutlet UILabel *desc;
@property (nonatomic) IBOutlet UIView *descBackground;
@property (nonatomic) IBOutlet UIButton *play;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *bkg;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic) IBOutlet UIView *video;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) AVPlayer *playerAV;
@property (nonatomic, strong) AVPlayerLayer *playerLayerAV;
@property (nonatomic, strong) AVPlayerItem *playerItemAV;
@property (nonatomic, strong) AVPlayerViewController *controllerAV;
@property (nonatomic) IBOutlet UIImageView *arrowLeft;
@property (nonatomic) IBOutlet UIImageView *arrowRight;

@property (nonatomic) IBOutlet UILabel *tip;


-(void) playVideo;
-(void) stopVideo;
- (void) initPage;
@end

