//
//  ByteViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 14/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "ByteViewController.h"
#import "Constants.h"
#import "TagsContainerCell.h"
#import "SearchViewController.h"
#import "DecodedString.h"
#import "SettingsManager.h"
#import "Mixpanel.h"



@interface ByteViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* homeButtonItem;
@property  (nonatomic) NSDictionary *loadedData;
@property  (nonatomic) IBOutlet TagsContainerCell *tagsContainerCell;

@end

@implementation ByteViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    if (NSClassFromString(@"UIVisualEffectView") && !UIAccessibilityIsReduceTransparencyEnabled()) {
        self.tableView.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:self.tableView.frame];
        self.tableView.backgroundView = blurEffectView;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initPage];

}

- (IBAction)handleSwipeRightFrom:(UISwipeGestureRecognizer*)recognizer {
    //NSLog(@" ..............  Swipe RIGHT detected!! ...................");
    
    if((int)[self.bytesData count] > 1)
    {
        if(self.selected > 0)
        {
            self.selected--;
        }
        else
            self.selected = (int)[self.bytesData count]-1;
        
       // NSLog(@"self.selected %d total %d",self.selected, (int)[self.bytesData count]);
        
        // tracking
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Byte Swiped Right" properties:@{
                                                     @"Component": @"Container",
                                                     @"From Byte":[NSString stringWithFormat: @"Byte %@",self.label.text]
                                                     }];

        
        [self performSegueWithIdentifier:@"ShowPrevByte" sender:self];
        
        
        
    }

}

- (IBAction)handleSwipeLeftFrom:(UISwipeGestureRecognizer*)recognizer {
   // NSLog(@" ..............  Swipe LEFT detected!! ...................");
    
    if((int)[self.bytesData count] > 1)
    {
        if(self.selected < (int)[self.bytesData count]-1)
        {
            self.selected++;
        }
        else
            self.selected = 0;
        
       // NSLog(@"self.selected %d total %d",self.selected, (int)[self.bytesData count]);
        
        // tracking
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Byte Swiped Left" properties:@{
                                                          @"Component": @"Container",
                                                          @"From Byte":[NSString stringWithFormat: @"Byte %@",self.label.text]
                                                          }];
        
        [self performSegueWithIdentifier:@"ShowNextByte" sender:self];
    }

    

}


- (void)customSetup
{
    self.image.image = nil;
    [self.image setAlpha:0.0f];
    
    
    [self.image setContentMode:UIViewContentModeScaleToFill];
    self.image.layer.cornerRadius = gridThumbBorderRadius;
    self.image.layer.masksToBounds = YES;
    
    [self.play setAlpha:0.0f];
    [self.play setEnabled:NO];
    
    [self.indicator setHidesWhenStopped:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:navigationLabelColor, NSFontAttributeName:[UIFont fontWithName:@"Quicksand-Bold" size:17.0f]}];
    [self.navigationController.navigationBar setTintColor:navigationBarTintColor];
    
    [self.bkg.layer setBackgroundColor:[byteDescBackgroundColor CGColor]];
    self.bkg.layer.cornerRadius = gridThumbBorderRadius;
    self.bkg.layer.masksToBounds = YES;

    [self.desc setTextColor:copyTextColor];
    [self.desc setFont:[UIFont fontWithName:@"Quicksand-Regular" size:17.0f]];
    [self.descBackground setBackgroundColor:byteDescBackgroundColor];
     self.descBackground.layer.cornerRadius = byteDescBackgroundBorderRadius;
    self.desc.numberOfLines = 0;
    self.desc.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.label setTextColor:byteLabelColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:24.0f]];

    [self.homeButtonItem setTarget: self];
    [self.homeButtonItem setAction: @selector( handleBackButtonTouch )];
    
    [self.button setAlpha:0.0f];
    [self.button setEnabled:NO];
    
    for(UIView *v in self.video.subviews)
        [v removeFromSuperview];

    [self stopVideo];
    [self.player.view removeFromSuperview];
    self.player = nil;

    self.video.layer.cornerRadius = gridThumbBorderRadius;
    self.video.layer.masksToBounds = YES;
    [self.video setBackgroundColor:[UIColor clearColor]];
    
    
    UIImage *arrowLeft = [[UIImage imageNamed:@"key_arrow_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.arrowLeft setImage:arrowLeft];
    [self.arrowLeft setTintColor:copyTextColor];
    
    UIImage *arrowRight = [[UIImage imageNamed:@"key_arrow_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.arrowRight setImage:arrowRight];
    [self.arrowRight setTintColor:copyTextColor];
    
    [self.tip setText:@"Tip: Swipe sideways to see more bytes"];

    [self.tip setTextColor:copyTextColor];
    [self.tip setFont:[UIFont fontWithName:@"Quicksand-Regular" size:15.0f]];
    [self.tip setBackgroundColor:byteTipBackgroundColor];
    self.tip.layer.cornerRadius = byteDescBackgroundBorderRadius;
    
    if((int)[self.bytesData count] > 1)
    {
        [self.arrowLeft setHidden:NO];
        [self.arrowRight setHidden:NO];
    }
    else
    {
        [self.arrowLeft setHidden:YES];
        [self.arrowRight setHidden:YES];
    }



}

- (void)scaleView:(UIView*) view from:(float) from to:(float) to duration:(float) duration delay:(float) delay enable:(BOOL) enable

{
    [view.layer removeAllAnimations];
    [view setTransform:CGAffineTransformMakeScale(from, from)];
    [view setAlpha:0];
    
    [UIView animateWithDuration:duration delay:delay options: 0 animations:^{
        
        [view setTransform:CGAffineTransformMakeScale(to, to)];
        [view setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        [(UIButton*)view setEnabled:enable];
    }];
}

- (void) initPage
{
    //NSLog(@"initPage loadedData %@",self.loadedData);
    
    NSString *title = [self.byteData objectForKey:@"title"];

    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Page Visited" properties:@{
                                                     @"Component": @"Container",
                                                     @"Page":[NSString stringWithFormat: @"Byte %@",title]
                                                     }];

    
    if(self.loadedData)
        return;

    if(self.byteData)
    {
        // init page
        [self customSetup];

        NSString *target = [self.byteData objectForKey:@"target"];
        [self loadByteData:target];
        
    }
    
}



-(void) loadImage
{
    /*
    NSURL *url = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [self.loadedData objectForKey:COVER_SIZE]]];
    // NSData *data = [NSData dataWithContentsOfURL:url];

    self.indicator.center = self.image.center;
    [self.indicator startAnimating];

    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        
        
        
        UIImage *image = [UIImage imageWithData:data];
        [self.image setImage:image];
        [self.image setContentMode:UIViewContentModeScaleToFill];
        //[self.image.layer setBorderColor: [coverThumbBorderColor CGColor]];
        //[self.image.layer setBorderWidth: coverThumbBorderThickness];
        
        self.image.layer.cornerRadius = gridThumbBorderRadius;
        self.image.layer.masksToBounds = YES;
        
        
        [UIView animateWithDuration:thumbTransitionTime animations:^{
            
            [self.image setAlpha:1.0f];

            
        } completion:^(BOOL finished) {
        
             [self.indicator stopAnimating];
            [self scaleView:self.play from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:YES];

        }];
        
        
    }];
     */

}


-(void) updateCopy
{
    
   
    if(self.loadedData)
    {
        [self.label setText:[DecodedString decodedStringWithString:[self.loadedData objectForKey:@"title"]]];
        
        [self setTitle:[[DecodedString decodedStringWithString:[self.loadedData objectForKey:@"title"]] uppercaseString]];
        
        [self.desc setText:[DecodedString decodedStringWithString:[self.loadedData objectForKey:@"description"]]];

    }
    else
    {
        [self.desc setText:@""];
        [self.label setText:@""];
        [self setTitle:@""];
    }
    //NSLog(@"updateCopy");
    
    [self.desc sizeToFit];

    [self.tagsContainerCell initTagsWithObject:[self.loadedData objectForKey:@"tags"] delegate:self];

}


-(void) initButton
{
    /*
    UIImage *imageDisabled = [[UIImage imageNamed:@"key_checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.button setImage:imageDisabled forState:UIControlStateDisabled];
    [self.button setTitleColor:byteAddButtonBackgroundColor forState:UIControlStateDisabled];
    [self.button setTitle:@"Added" forState:UIControlStateDisabled];

    UIImage *image = [[UIImage imageNamed:@"key_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.button setImage:image forState:UIControlStateNormal];
    [self.button setTitleColor:byteAddButtonTintColor forState:UIControlStateNormal];
    [self.button setTitle:@"Add" forState:UIControlStateNormal];

    [self.button.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:byteAddButtonFontSize]];
    self.button.layer.cornerRadius = byteAddButtonBorderRadius;

    
    if([[SettingsManager sharedSettings] isByteAdded:self.loadedData])
    {
        if([[SettingsManager sharedSettings] isByteEnabled:self.loadedData])
        {
            [self.button setTintColor:byteAddButtonBackgroundColor];
            [self.button setBackgroundColor:byteAddButtonTintColor];
            [self.button setEnabled:NO];
            [self scaleView:self.button from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:NO];
        }
        else
        {
            [self.button setTintColor:byteAddButtonTintColor];
            [self.button setBackgroundColor:byteAddButtonBackgroundColor];
            [self.button setEnabled:YES];
            [self scaleView:self.button from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:YES];
        }
    }
    else
    {
        [self.button setTintColor:byteAddButtonTintColor];
        [self.button setBackgroundColor:byteAddButtonBackgroundColor];
        [self.button setEnabled:YES];
        [self scaleView:self.button from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:YES];
    }
    */
    
    UIImage *imageDisabled = [[UIImage imageNamed:@"key_checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *image = [[UIImage imageNamed:@"key_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    [self.button.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:byteAddButtonFontSize]];
    self.button.layer.cornerRadius = byteAddButtonBorderRadius;
    
    
    if([[SettingsManager sharedSettings] isByteAdded:self.loadedData])
    {
        if([[SettingsManager sharedSettings] isByteEnabled:self.loadedData])
        {
            [self.button setTintColor:byteAddButtonBackgroundColor];
            [self.button setBackgroundColor:byteAddButtonTintColor];
            [self.button setEnabled:YES];
            
            [self.button setImage:imageDisabled forState:UIControlStateNormal];
            [self.button setTitleColor:byteAddButtonBackgroundColor forState:UIControlStateNormal];
            [self.button setTitle:@"Added" forState:UIControlStateNormal];
            
            [self scaleView:self.button from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:YES];
        }
        else
        {
            [self.button setTintColor:byteAddButtonTintColor];
            [self.button setBackgroundColor:byteAddButtonBackgroundColor];
            [self.button setEnabled:YES];
            
            [self.button setImage:image forState:UIControlStateNormal];
            [self.button setTitleColor:byteAddButtonTintColor forState:UIControlStateNormal];
            [self.button setTitle:@"Add" forState:UIControlStateNormal];

            [self scaleView:self.button from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:YES];
        }
    }
    else
    {
        [self.button setTintColor:byteAddButtonTintColor];
        [self.button setBackgroundColor:byteAddButtonBackgroundColor];
        [self.button setEnabled:YES];
        
        [self.button setImage:image forState:UIControlStateNormal];
        [self.button setTitleColor:byteAddButtonTintColor forState:UIControlStateNormal];
        [self.button setTitle:@"Add" forState:UIControlStateNormal];

        [self scaleView:self.button from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:YES];
    }

}


-(void) hidePlayButton
{
    [self.play.layer removeAllAnimations];
    [UIView animateWithDuration:thumbTransitionTime*0.5 delay:0 options:0   animations:^{
        [self.play setTransform:CGAffineTransformMakeScale(1.05f, 1.05f)];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:thumbTransitionTime*0.5f  delay:0 options:0   animations:^{
            [self.play setTransform:CGAffineTransformMakeScale(0.95f, 0.95f)];
            [self.play setAlpha:0.0f];

        } completion:^(BOOL finished) {
            [self.play setEnabled:NO];
            [self playVideo];

        }];
    }];
}

-(void) showPlayButton
{
    [self.play.layer removeAllAnimations];
    [UIView animateWithDuration:thumbTransitionTime*0.5 delay:0 options:0   animations:^{
        [self.play setAlpha:1.0f];
        [self.play setTransform:CGAffineTransformMakeScale(1.05f, 1.05f)];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:thumbTransitionTime*0.5f  delay:0 options:0   animations:^{
            [self.play setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
            
        } completion:^(BOOL finished) {
            [self.play setEnabled:YES];
        }];
    }];
}


-(void) animateButtonToAdded
{
    
    UIImage *imageDisabled = [[UIImage imageNamed:@"key_checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [self.button.layer removeAllAnimations];
    //UIImage *img = [self.button imageForState:UIControlStateDisabled];
    //float s = img.scale;
    [UIView animateWithDuration:thumbTransitionTime delay:0 options:0   animations:^{
        [self.button setTransform:CGAffineTransformMakeScale(1.05f, 1.05f)];
       // [self.button.imageView setTransform:CGAffineTransformMakeScale(s*0.5f, s*0.5f)];
        [self.button setBackgroundColor:byteAddButtonTintColor];
        
        
    } completion:^(BOOL finished) {
        
        //[self.button setEnabled:NO];
        [self.button setTintColor:byteAddButtonBackgroundColor];
        [self.button setImage:imageDisabled forState:UIControlStateNormal];
        [self.button setTitleColor:byteAddButtonBackgroundColor forState:UIControlStateNormal];
        [self.button setTitle:@"Added" forState:UIControlStateNormal];


        [UIView animateWithDuration:thumbTransitionTime*0.5f  delay:0 options:0   animations:^{

            [self.button setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
            
            //[self.button.imageView setTransform:CGAffineTransformMakeScale(s, s)];
            
        } completion:^(BOOL finished) {
        
            if((int)[self.bytesData count] <= 1)
                [self handleBackButtonTouch];
        }];
    }];
}


-(void) animateButtonToAdd
{
    
    UIImage *image = [[UIImage imageNamed:@"key_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    [self.button.layer removeAllAnimations];
    //UIImage *img = [self.button imageForState:UIControlStateDisabled];
    //float s = img.scale;
    [UIView animateWithDuration:thumbTransitionTime delay:0 options:0   animations:^{
        [self.button setTransform:CGAffineTransformMakeScale(1.05f, 1.05f)];
        // [self.button.imageView setTransform:CGAffineTransformMakeScale(s*0.5f, s*0.5f)];
        [self.button setBackgroundColor:byteAddButtonBackgroundColor];
        
        
    } completion:^(BOOL finished) {
        
        //[self.button setEnabled:NO];
        [self.button setTintColor:byteAddButtonTintColor];
        [self.button setImage:image forState:UIControlStateNormal];
        [self.button setTitleColor:byteAddButtonTintColor forState:UIControlStateNormal];
        [self.button setTitle:@"Add" forState:UIControlStateNormal];

        
        
        [UIView animateWithDuration:thumbTransitionTime*0.5f  delay:0 options:0   animations:^{
            
            [self.button setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
            
            //[self.button.imageView setTransform:CGAffineTransformMakeScale(s, s)];
            
        } completion:^(BOOL finished) {
            
            //[self handleBackButtonTouch];
        }];
    }];
}



-(void)loadByteData:(NSString*)jsonPath
{
    [self.image setAlpha:0.0f];
    self.indicator.center = self.image.center;
    [self.indicator startAnimating];
    
    NSURL *dataURL = [NSURL URLWithString:[API_URL stringByAppendingString:[jsonPath stringByAppendingString: @".json"]]];
   // NSLog(@"dataURL %@",dataURL);
    
    NSError *errorLoad = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:dataURL options:NSDataReadingUncached error:&errorLoad];
        
    if (errorLoad) {
        NSLog(@"%@", [errorLoad localizedDescription]);
        
        [self.label setText:[DecodedString decodedStringWithString:@"Cannot Connect to Byte.me"]];
        [self.tableView reloadData];
        
    } else {
       // NSLog(@"Data has loaded successfully.");
        
        
        NSError *errorParse = nil;
        NSDictionary *dataDictionary = [NSJSONSerialization
                                        JSONObjectWithData:jsonData options:0 error:&errorParse];
        

        
        if (errorParse) {
            NSLog(@"%@", [errorParse localizedDescription]);
        } else {
             //NSLog(@"Data has parsed successfully %@",dataDictionary);
            
            /* index model
             data
                 version
                 asset_url
                 byte
                    id
                    title
                    cover1x
                    cover2x
                    cover3x
                    video
                    description
                    price
                    target
                    tags
                        items
                            item {id}
                                id
                                name
                        total
             */
            
            NSDictionary *data = [dataDictionary objectForKey:@"data"];
            
            //self.tableData = [[NSMutableArray alloc] init];
            
            if(data)
            {
                //NSLog(@"data ok");

                
                NSDictionary *byte = [data objectForKey:@"byte"];
                
                if(byte)
                {
                    //NSLog(@"byte %@", byte);


                    self.loadedData = byte;
                    
                    [self updateCopy];
                    //[self loadImage];
                    //[self loadVideo];
                    
                    [self loadVideo];
                        
                    [self initButton];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseCarousel" object:nil userInfo:nil];
                    
                    //[self.tableView reloadData];

                }
                else
                {
                    //NSLog(@"no byte");
                }
            }
            else
            {
               // NSLog(@"no data");
            }
        }
    }
    
}


- (IBAction)handlePlayButonDown:(id)sender {
    
    
    [self hidePlayButton];
}


- (void)handleBackButtonTouch
{
    
    //[self stopVideo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeCarousel" object:nil userInfo:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
   //NSLog(@"prepareForSegue %@ %@", segue, sender);
    [self stopVideo];

    if([segue.identifier isEqualToString:@"ShowSearch"])
    {
        SearchViewController *searchController = segue.destinationViewController;
        searchController.searchPath = sender;
        //[searchController initPage];

    }
    else if([segue.identifier isEqualToString:@"ShowNextByte"])
    {
        ByteViewController *byteController = segue.destinationViewController;
        byteController.byteData = [self.bytesData objectAtIndex:self.selected];
        byteController.bytesData = self.bytesData;
        byteController.selected = self.selected;
    }
    else if([segue.identifier isEqualToString:@"ShowPrevByte"])
    {
        ByteViewController *byteController = segue.destinationViewController;
        byteController.byteData = [self.bytesData objectAtIndex:self.selected];
        byteController.bytesData = self.bytesData;
        byteController.selected = self.selected;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"heightForRowAtIndexPath %f",SCREEN_HEIGHT);

    CGFloat h = headerCelltHeight;
    
    if([indexPath row] == 0)
    {
        CGFloat imgHeight = (SCREEN_WIDTH / 4.0f) * 3.0f;
        h = imgHeight;
    }
    else if([indexPath row] == 1)
    {
        h = byteTitleCellHeight;
    }
    else if([indexPath row] == 2)
    {
        
        if([[self.loadedData objectForKey:@"description"] isEqualToString:@""] || [self.desc.text isEqualToString:@""])
        {
           [self.desc.superview.superview removeConstraints:self.desc.superview.superview.constraints];

            h = 0;
        }
        else
        {
            CGSize size = self.desc.bounds.size;
            h = size.height;
        }
        
    }
    else if([indexPath row] == 3)
    {
        //NSLog(@"tags cell update %@",self.tagsContainerCell);
        
        if([self.tagsContainerCell.tagList hasItems])
        {
            CGPoint pos = self.tagsContainerCell.tagList.frame.origin;
            CGSize size = [self.tagsContainerCell.tagList fittedSize] ;
            h = pos.y+size.height;
            
            //NSLog(@"tags h  %f",h);

        }
        else
        {
            [self.tagsContainerCell.tagList.superview removeConstraints:self.tagsContainerCell.tagList.superview.constraints];
            h = 0;
           // NSLog(@"tags h  %f",h);

        }
    }
   
    else if([indexPath row] == 4)
    {
        h = byteAddButtonCellHeight;
    }
    
    else if([indexPath row] == 5)
    {
        // spacer
        h = 0.0f;
    }

    
    else if([indexPath row] == 6)
    {
        if((int)[self.bytesData count] > 1)
            h = byteTipCellHeight;
        else
            h = 0;
    }

    
    
   
    
    //NSLog(@"heightForRowAtIndexPath %f",h);
    
    return h;
}


- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex path:(NSString *)path
{
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:[NSString stringWithFormat:@"You tapped tag %@ at index %ld path %@", tagName,(long)tagIndex, path]
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
     */
   // NSLog(@"selectedTag");
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Hashtag Clicked" properties:@{
                                                     @"Component": @"Container",
                                                     @"Tag":path
                                                     }];


    [self performSegueWithIdentifier:@"ShowSearch" sender:path];

}


-(void)moviePlaybackFinished:(NSNotification *)receive
{
    //NSLog(@"moviePlaybackFinished");
    
    [self stopVideo];
    [self showPlayButton];
    //[self scaleView:self.play from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:YES];

}


-(void) loadVideo
{
    if(self.player == nil)
    {

        NSURL *videoUrl = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [self.loadedData objectForKey:@"video"]]];
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        [self.player.view setFrame:CGRectMake(0, 0,  self.image.frame.size.width,  self.image.frame.size.height) ];
        [self.player setShouldAutoplay:NO];
        self.player.allowsAirPlay = false;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieThumbLoadFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.player];
        [self.player requestThumbnailImagesAtTimes:@[ @0.0f]  timeOption:MPMovieTimeOptionNearestKeyFrame];
        [self.player stop];
    }
}


-(void) playVideoUsingAV
{
    NSURL *videoURL = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [self.loadedData objectForKey:@"video"]]];

    self.playerItemAV = [AVPlayerItem playerItemWithURL:videoURL];
    self.playerAV = [AVPlayer playerWithPlayerItem:self.playerItemAV ];
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];  //voice come
                                                                //                                                                   change here
    
    
    if(!self.controllerAV)
    {
        self.controllerAV = [[AVPlayerViewController alloc]init];
        [self addChildViewController:self.controllerAV];
    }

    self.controllerAV.player = self.playerAV;
    self.controllerAV.showsPlaybackControls = NO;
    self.controllerAV.view.frame = CGRectMake(0, 0,  self.image.frame.size.width,  self.image.frame.size.height);

    self.playerLayerAV = [AVPlayerLayer playerLayerWithPlayer:self.playerAV];
    [self.playerLayerAV setFrame:CGRectMake(0, 0,  self.image.frame.size.width,  self.image.frame.size.height)];
    self.playerLayerAV.videoGravity = AVLayerVideoGravityResize;
    [self.video.layer addSublayer:self.playerLayerAV];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItemAV];
    [self.playerAV play];
    
}

-(void)movieThumbLoadFinished:(NSNotification *)notification
{
    [self.player stop];

    NSDictionary *userInfo = [notification userInfo];
    UIImage *thumbnail = [userInfo valueForKey:MPMoviePlayerThumbnailImageKey];
    
    [self.image setImage:thumbnail];
    [self.image setContentMode:UIViewContentModeScaleToFill]; // UIViewContentModeScaleAspectFill
    self.image.layer.cornerRadius = gridThumbBorderRadius;
    self.image.layer.masksToBounds = YES;
    
    
    [UIView animateWithDuration:thumbTransitionTime animations:^{
        
        [self.image setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
  
        [self.indicator stopAnimating];
        [self scaleView:self.play from:0.9f to:1 duration:thumbTransitionTime delay:0 enable:YES];
        
    }];
}




-(void) playVideo
{
  
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Byte Previewed" properties:@{
                                                      @"Component": @"Container",
                                                      @"Byte":[NSString stringWithFormat: @"Byte %@",self.label.text]
                                                      }];
    [self playVideoUsingAV];
}

-(void) stopVideo
{

    if(self.player != nil)
        [self.player stop];
    
    if(self.playerAV != nil)
    {
        [self.playerAV seekToTime:CMTimeMake(0, 1)];
        [self.playerAV pause];
    }
    
}
- (IBAction)handleAddButtonDown:(id)sender {
    
    if([[SettingsManager sharedSettings] addNewByte:self.loadedData])
    {
      [[SettingsManager sharedSettings] enableByte:self.loadedData];
        [self animateButtonToAdded];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFooterData" object:nil userInfo:nil];
        

    }
    else if([[SettingsManager sharedSettings] enableByte:self.loadedData])
    {
        [self animateButtonToAdded];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFooterData" object:nil userInfo:nil];
        
    }
    else
    {
        [[SettingsManager sharedSettings] disableByte:self.loadedData];
        [self animateButtonToAdd];
             
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFooterData" object:nil userInfo:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopVideo];
    [self showPlayButton];

}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end
