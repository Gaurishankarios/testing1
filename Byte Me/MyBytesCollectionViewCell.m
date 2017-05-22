//
//  MyBytesCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 21/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "MyBytesCollectionViewCell.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "RequestQueue.h"

@interface MyBytesCollectionViewCell ()
@property (nonatomic) NSDictionary *object;
@property (nonatomic) NSURLRequest *request;
@end

@implementation MyBytesCollectionViewCell


-(void) initCellWithObject:(NSDictionary*) object
{
    // NSLog(@"initCellWithObject %@", object);
    
    if(self.request)
        [[RequestQueue mainQueue] cancelRequest:self.request];
    self.request = NULL;
    
    self.image.image = nil;
    self.object = nil;
    
    [self.bkg.layer setBackgroundColor:[coverThumbBorderColor CGColor]];
    self.bkg.layer.cornerRadius = gridThumbBorderRadius;
    self.bkg.layer.masksToBounds = YES;
    
    
    [self.image setAlpha:0.0f];
    //[self.label setAlpha:0.0f];
    [self.indicator setHidesWhenStopped:YES];
    
    
    [self.statusBkg setImage:[[UIImage imageNamed:@"key_filledcircle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.statusBkg setTintColor:byteStatusBackgroundColor];

    [self.status setImage:[[UIImage imageNamed:@"key_checkmark_only"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.status setTintColor:linkTintColor];
    [self.status setAlpha:0.0f];
    [self.status setTransform:CGAffineTransformMakeScale(myByteDisbaledScale, myByteDisbaledScale)];

   
    self.object = object;
    [self loadImage:[[SettingsManager sharedSettings] isByteEnabled:object]];
    //[self initLabel];
    
    
}


-(void) loadImage:(BOOL) enabled
{
    NSURL *url = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [self.object objectForKey:COVER_SIZE_SMALL]]];
    // NSData *data = [NSData dataWithContentsOfURL:url];
    
    self.indicator.center = self.image.center;
    [self.indicator startAnimating];
    
    //NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    self.request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:defaultTimeOutResponse];
    
    [[RequestQueue mainQueue] addRequest:self.request completionHandler:^(__unused NSURLResponse *response, NSData *data, NSError *error) {
        
        self.request = NULL;
        
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            [self.image setImage:image];
            [self.image setContentMode:UIViewContentModeScaleAspectFill];
            [self.image.layer setBorderColor: [coverThumbBorderColor CGColor]];
            [self.image.layer setBorderWidth: coverThumbBorderThickness];
            
            self.image.layer.cornerRadius = gridThumbBorderRadius;
            self.image.layer.masksToBounds = YES;
            
            
            [UIView animateWithDuration:thumbTransitionTime animations:^{
                
                if(enabled)
                    [self.image setAlpha:1.0f];
                else
                    [self.image setAlpha:myByteDisbaledAlpha];
                
                //[self.label setAlpha:1.0f];
                
                
            } completion:^(BOOL finished) {
                
                [self.indicator stopAnimating];
                
                if(enabled)
                {
                    [UIView animateWithDuration:thumbTransitionTime delay:0 options:0   animations:^{
                        [self.status setAlpha:1.0f];
                        [self.status setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                    } completion:^(BOOL finished) {
                    }];
                }
                
                
            }];

            
        }
        else
        {
            //loading error
        }
        
    }];
    /*

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        
        
        
        UIImage *image = [UIImage imageWithData:data];
        [self.image setImage:image];
        [self.image setContentMode:UIViewContentModeScaleAspectFill];
        [self.image.layer setBorderColor: [coverThumbBorderColor CGColor]];
        [self.image.layer setBorderWidth: coverThumbBorderThickness];
        
        self.image.layer.cornerRadius = gridThumbBorderRadius;
        self.image.layer.masksToBounds = YES;
        
        
        [UIView animateWithDuration:thumbTransitionTime animations:^{
            
            if(enabled)
                [self.image setAlpha:1.0f];
            else
                [self.image setAlpha:myByteDisbaledAlpha];

            [self.label setAlpha:1.0f];
            
            
        } completion:^(BOOL finished) {
            
            [self.indicator stopAnimating];
            
            if(enabled)
            {
                [UIView animateWithDuration:thumbTransitionTime delay:0 options:0   animations:^{
                    [self.status setAlpha:1.0f];
                    [self.status setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                } completion:^(BOOL finished) {
                }];
            }
          
            
        }];
        
        
    }];
     */
    
}

/*
-(void) initLabel
{
    [self.label setTextColor:gridLabelColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:13.0f]];
    [self.label setText:[self.object objectForKey:@"title"]];
}
*/

-(void) changeStatus
{
    [self.statusBkg.layer removeAllAnimations];
    [self.status.layer removeAllAnimations];
    [self.image.layer removeAllAnimations];
    
    /*
    [UIView animateWithDuration:thumbTransitionTime delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAutoreverse  animations:^{
        [self.statusBkg setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
    } completion:^(BOOL finished) {
        [self.statusBkg setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
    }]
     */
    
    [UIView animateWithDuration:thumbTransitionTime*0.5f delay:0 options:0   animations:^{
        [self.statusBkg setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:thumbTransitionTime*0.5f  delay:0 options:0   animations:^{
            [self.statusBkg setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
        } completion:^(BOOL finished) {}];
    }];

    
    if([[SettingsManager sharedSettings] isByteEnabled:self.object])
    {
        [[SettingsManager sharedSettings] disableByte:self.object];
        
        [UIView animateWithDuration:thumbTransitionTime delay:0 options:0   animations:^{
            [self.image setAlpha:myByteDisbaledAlpha];
            [self.status setAlpha:0.0f];
            [self.status setTransform:CGAffineTransformMakeScale(myByteDisbaledScale, myByteDisbaledScale)];
        } completion:^(BOOL finished) {
        }];
        
    }
    else
    {
        [[SettingsManager sharedSettings] enableByte:self.object];
        
        [UIView animateWithDuration:thumbTransitionTime delay:0 options:0   animations:^{
            [self.image setAlpha:1.0f];
            [self.status setAlpha:1.0f];
            [self.status setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
        } completion:^(BOOL finished) {
        }];

    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyBytesHeader" object:nil userInfo:nil];

    /*
    [UIView animateWithDuration:thumbTransitionTime delay:0 options:0   animations:^{
        [self.button setBackgroundColor:byteAddButtonTintColor];
    } completion:^(BOOL finished) {
        [self.button setEnabled:NO];
        [self.button setTintColor:byteAddButtonBackgroundColor];
    }];
     */
}



-(void) prepareForReuse
{
    // cancel unloaded
    if(self.request)
        [[RequestQueue mainQueue] cancelRequest:self.request];
    
    self.request = NULL;
}


@end

