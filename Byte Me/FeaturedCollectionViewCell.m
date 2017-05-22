//
//  FeaturedCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 08/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "FeaturedCollectionViewCell.h"
#import "SettingsManager.h"
#import "Constants.h"
#import "RequestQueue.h"

@interface FeaturedCollectionViewCell ()
@property (nonatomic) NSDictionary *object;
@property (nonatomic) int errorLoadCount;
@property (nonatomic) NSURLRequest *request;

@end

@implementation FeaturedCollectionViewCell


-(void) initCellWithObject:(NSDictionary*) object
{
    if(self.request)
        [[RequestQueue mainQueue] cancelRequest:self.request];
    self.request = NULL;
    
    self.errorLoadCount = 0;

    self.image.image = nil;
    self.object = nil;

    self.object = object;

    UIColor *color =  coverThumbBorderColor;//[[SettingsManager sharedSettings] getColourFromObject:self.object defaultColout:coverThumbBorderColor];

    [self.layer setBackgroundColor:[color CGColor]];
    [self.layer setBorderColor: [color CGColor]];
    [self.layer setBorderWidth: coverThumbBorderThickness];
    self.layer.cornerRadius = coverThumbBorderRadius;
    self.layer.masksToBounds = YES;

    
    [self.image setAlpha:0.0f];
    [self.indicator setHidesWhenStopped:YES];
    //[self.indicator setColor:[UIColor whiteColor]];

    [self loadImage];
}



-(void) loadImage
{
    NSURL *url = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [self.object objectForKey:COVER_SIZE_SMALL]]];
   // NSData *data = [NSData dataWithContentsOfURL:url];
    
    self.indicator.center = self.image.center;
    [self.indicator startAnimating];

    //NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    self.request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:defaultTimeOutResponse];
    
    [[RequestQueue mainQueue] addRequest:self.request completionHandler:^(__unused NSURLResponse *response, NSData *data, NSError *error) {
        
        
        if (!error)
        {
            self.request = NULL;

            UIImage *image = [UIImage imageWithData:data];
            [self.image setImage:image];
            [self.image setContentMode:UIViewContentModeScaleAspectFill];
            self.image.layer.masksToBounds = YES;
            
            [UIView animateWithDuration:thumbTransitionTime animations:^{
                
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
                [self loadImage];
            
        }
        
    }];
    
    /*
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        
        UIImage *image = [UIImage imageWithData:data];
        [self.image setImage:image];
        [self.image setContentMode:UIViewContentModeScaleAspectFill];
        self.image.layer.masksToBounds = YES;
        
        [UIView animateWithDuration:thumbTransitionTime animations:^{
            
            [self.image setAlpha:1.0f];
            
        } completion:^(BOOL finished) {
            [self.indicator stopAnimating];

        }];
        
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
