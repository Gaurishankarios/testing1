//
//  ByteCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 13/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ByteCollectionViewCell.h"
#import "CBetterCollectionViewLayoutAttributes.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "DecodedString.h"
#import "RequestQueue.h"
#import "Mixpanel.h"

/*
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
*/

@interface ByteCollectionViewCell ()
@property (nonatomic) NSArray *items;

@property (readwrite, nonatomic, strong) CALayer *shieldLayer;
@property (nonatomic) int errorLoadCount;

@end

@implementation ByteCollectionViewCell

- (void)awakeFromNib {
    
    [_shadow setBackgroundColor:cellShadowColor];
    _shadow.layer.cornerRadius = tileBorderRadius;
    _shadow.layer.masksToBounds = YES;
    
    _image.layer.cornerRadius = tileBorderRadius;
    _image.layer.masksToBounds = YES;
    
    _shield.layer.cornerRadius = tileBorderRadius;
    _shield.layer.masksToBounds = YES;

    _video.layer.cornerRadius = tileBorderRadius;
    _video.layer.masksToBounds = YES;
    [_video setBackgroundColor:[UIColor clearColor]];
    
    [_image.layer setBorderColor: [coverThumbBorderColor CGColor]];
    [_image.layer setBorderWidth: 0.5f];
    
    [self.indicator setHidesWhenStopped:YES];
 
    if (self.gestureRecognizers.count == 0)
    {
        //[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)]];
        
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressCell:)]];
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:    self action:@selector(tapCell:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:   self action:@selector(doubelTapCell:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
}

-(void) prepareForReuse
{
    // NSLog(@"SubCollectionViewCell prepareForReuse %@",self.items  );
    self.errorLoadCount = 0;
    self.items = nil;
    self.videoPath = nil;
    self.videoName = @"";
    [self stopVideo];
    [self.player.view removeFromSuperview];
    self.player = nil;
    
    [self.image setImage: nil];
    
    
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    
    [super applyLayoutAttributes:layoutAttributes];
    
    CBetterCollectionViewLayoutAttributes *theLayoutAttributes = (CBetterCollectionViewLayoutAttributes *)layoutAttributes;
    if (self.shieldLayer == NULL)
    {
        self.shieldLayer = [self makeShieldLayer];
        [_shield.layer addSublayer:self.shieldLayer];
    }
    
    self.shieldLayer.opacity = theLayoutAttributes.shieldAlpha;
}



- (CALayer *)makeShieldLayer
{
    CALayer *theShield = [CALayer layer];
    theShield.frame = self.bounds;
    theShield.backgroundColor = [UIColor blackColor].CGColor;
    return(theShield);
}


//-(void) initCellWithData:(NSArray *)data
-(void) initCellWithData:(NSMutableDictionary *)data
{
    
    // 0:title, 1:bkg, 2:badge, 3:video 4:title text color, 5:sub objects arr
    self.errorLoadCount = 0;

    //_items = data[5];
    _items = [data objectForKey:@"children"];
    
    self.data = data;
    
    for(UIGestureRecognizer *g in self.gestureRecognizers)
        g.enabled = NO;
    
    for(UIView *v in _video.subviews)
        [v removeFromSuperview];

    _videoPath = nil;
    _videoName = @"";
    [self stopVideo];
    [_player.view removeFromSuperview];
    _player = nil;
    
    [_image setImage: nil];


    if(_items.count > 0)
    {
        // has sub
        
        // hide bkg, label, badge
        [_image setHidden:YES];
        [_shield setHidden:YES];
        [_label setHidden:YES];
        [_shadow setHidden:YES];
        [_video setHidden:YES];
    
        [self enabledGestures:NO];

    }
    else
    {
        // doesn't have sub
        
        // if cover
        // show bkg, label, badge
        
        //NSString *cover = [data objectForKey:COVER_SIZE];
        NSString *type = [data objectForKey:@"type"];

        
        //if([cover isEqualToString:@""])
        if([type isEqualToString:@"category"])
        {
            [_image setHidden:NO];
            [_shield setHidden:NO];
            [_label setHidden:NO];
            //[_shadow setHidden:NO];
            [_shadow setHidden:YES];

            [_video setHidden:YES];
            //[_label setText: [data objectForKey:@"title"]];
            [_label setText: [DecodedString decodedStringWithString:[data objectForKey:@"title"]]];

            [_label setTextColor:globalBackgroundColor];
            //[_label setTextColor:[[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor]];

            
            NSString *imagePath = [data objectForKey:@"cover"];
            
            
            if(![imagePath isEqualToString:@""])
            {
                
                //[_image setImage: [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath] scale:[UIScreen mainScreen].scale]];
                [_image setImage: [[UIImage imageNamed:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [_image setTintColor:globalBackgroundColor];
                //[_image setTintColor:[[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor]];

            }
            
            [self.image setContentMode:UIViewContentModeScaleToFill];
            //[_image setBackgroundColor:[[SettingsManager sharedSettings] getBackgroundFromObject:data defaultColout:categoryLabelColor]];
            [_image setBackgroundColor:[[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor]];

            [self enabledGestures:NO];
            [self.image setAlpha:1.0f];
            [self.indicator stopAnimating];

        }
        else
        {
            [_image setHidden:NO];
            [_shield setHidden:NO];
            [_label setHidden:NO];
            //[_shadow setHidden:NO];
            [_shadow setHidden:YES];

            [_video setHidden:NO];
            
       
            //NSString *imagePath = [self getFormattedImagePath:data[1] extension:data[2]];
            
            //NSString *imagePath = @"";
            NSString *imagePath = [data objectForKey:COVER_SIZE];

            if(![imagePath isEqualToString:@""])
            {
                // local
                /*
                [_image setImage: [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath] scale:[UIScreen mainScreen].scale]];
                 */
                
                [_label setHidden:YES];
                [self loadImage:imagePath];
            }

            //[self.image setContentMode:UIViewContentModeScaleAspectFill];

            
            //[_label setText: data[0]];
            //[_label setTextColor:data[4]];
         
            [_label setText: [data objectForKey:@"title"]];
            [_label setTextColor:globalBackgroundColor];
            
           // if(![data[3] isEqualToString:@""])
            if(![[data objectForKey:@"video"] isEqualToString:@""])

            {
               // _videoName = data[3];
               // _videoPath = [[NSBundle mainBundle] URLForResource:data[3] withExtension:@"mp4"];
                
                _videoName = [data objectForKey:@"video"];
                _videoPath = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [data objectForKey:@"video"]]];
            }

            [self enabledGestures:YES];


        }
        
        
    }
    [self toggleCellHidden:NO];

    
}


-(void) loadImage:(NSString*) file
{
    NSURL *url = [NSURL URLWithString:[ASSET_URL stringByAppendingString: file]];
    // NSData *data = [NSData dataWithContentsOfURL:url];
    [self.image setAlpha:0.0f];
    self.indicator.center = self.image.center;
    [self.indicator startAnimating];
    
    //NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:defaultTimeOutResponse];
    
    [[RequestQueue mainQueue] addRequest:request completionHandler:^(__unused NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error)
        {
            
            UIImage *image = [UIImage imageWithData:data];
            [self.image setImage:image];
            [self.image setContentMode:UIViewContentModeScaleToFill];
            self.image.layer.masksToBounds = YES;
            
            [UIView animateWithDuration:thumbKeyboardTransitionTime animations:^{
                
                [self.image setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                [self.indicator stopAnimating];
                
            }];
        }
        else
        {
            //loading error
            self.errorLoadCount++;
            
            if(self.errorLoadCount < 3)
                [self loadImage:file];
        }
        
    }];

    
}


-(NSString *) getFormattedImagePath:(NSString *)file extension:(NSString*) ext
{
    
    int s = (int) roundf([UIScreen mainScreen].scale);
        
    switch (s) {
        default:
        case 1:
            return [[NSBundle mainBundle] pathForResource:file ofType:ext];
            break;
        case 2:
            return [[NSBundle mainBundle] pathForResource:[file stringByAppendingString:@"@2x" ] ofType:ext];
            break;
        case 3:
            return [[NSBundle mainBundle] pathForResource:[file stringByAppendingString:@"@3x" ] ofType:ext];
            break;
    }
    
    
}



-(void)moviePlaybackFinished:(NSNotification *)receive
{
    [self stopVideo];
}


-(void) toggleCellHidden:(BOOL)h
{
    for(UIView *v in self.subviews)
    {
        [v setHidden:h];
    }
    
}

-(void) playVideo
{
    if(![_videoName isEqualToString:@""])
    {
        if(_player == nil)
        {
            /*
            _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_videoName ofType:@"mp4"]]];
             */
            _player = [[MPMoviePlayerController alloc] initWithContentURL:_videoPath];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:_player];
            
            _player.allowsAirPlay = false;
            self.player.scalingMode = MPMovieScalingModeFill;
            [_player.view setFrame:CGRectMake(0, 0,  _image.frame.size.width,  _image.frame.size.height) ];
            [_player setControlStyle:MPMovieControlStyleNone];
            [_player.view setBackgroundColor:[UIColor clearColor]];
            [_player.backgroundView setBackgroundColor:[UIColor clearColor]];
            
            
            
            
            
            for(UIView* subV in _player.view.subviews) {
                [subV setBackgroundColor:[UIColor clearColor]];
            }
            
           
            
            [_video addSubview:_player.view];
            
            //[_player setShouldAutoplay:YES];

            //for(UIGestureRecognizer *g in self.gestureRecognizers)
              //  g.enabled = YES;
            
           // [_player prepareToPlay];
           // [_player stop];
            [_player play];
        }
        
        else
        {
            if(_player.playbackState == MPMoviePlaybackStatePlaying)
                [_player stop];
            else
                [_player play];
        }
        /*
        [_player prepareToPlay];
        [_player stop];
        [_player play];
         */
        
        /*
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"video"
                                                              action:@"play"
                                                               label:_videoName
                                                               value:nil] build]];
         */
        
        
        // tracking
        NSString *title = [self.data objectForKey:@"title"];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Byte Previewed" properties:@{
                                                         @"Component": @"Keyboard",
                                                         @"Byte":title
                                                         }];

    }

    
    
}

-(void) stopVideo
{
    if(_player != nil)
        [_player stop];
}

-(void) enabledGestures:(BOOL) enable
{
    for(UIGestureRecognizer *g in self.gestureRecognizers)
        g.enabled = enable;
}

#pragma mark -
- (void)tapCell:(UITapGestureRecognizer *)inGestureRecognizer
{
    /*
    [self stopVideo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleByteUI" object:self userInfo:nil];
     */
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil]; //line add
    
    [self playVideo];

    /*
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"video"
                                                          action:@"tap"
                                                           label:_videoName
                                                           value:nil] build]];
     */


}


- (void)doubelTapCell:(UITapGestureRecognizer *)inGestureRecognizer
{
    
    //[self stopVideo];
   // [[SettingsManager sharedSettings] addNewFrequentByte:self.data];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleByteUIPressBegan" object:self userInfo:nil];
    
}

- (void)pressCell:(UILongPressGestureRecognizer *)inGestureRecognizer
{
    [self stopVideo];
    
    if(inGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
      //  [[SettingsManager sharedSettings] addNewFrequentByte:self.data];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleByteUIPressBegan" object:self userInfo:nil];
        
        /*
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"video"
                                                              action:@"long_press"
                                                               label:_videoName
                                                               value:nil] build]];
         */

    }
    /*
    if(inGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"pressCell END");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleByteUIPressEnd" object:self userInfo:nil];

    }
    */
    
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(_player != nil)
    {
        [self stopVideo];
        [_player.view removeFromSuperview];
        _player = nil;
    }
    
}


@end


