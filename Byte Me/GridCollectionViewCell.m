//
//  GridCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 12/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "GridCollectionViewCell.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "RequestQueue.h"

@interface GridCollectionViewCell ()
@property (nonatomic) NSDictionary *object;
@property (nonatomic) NSURLRequest *request;

@end

@implementation GridCollectionViewCell


-(void) initCellWithObject:(NSDictionary*) object
{
    // NSLog(@"initCellWithObject %@", object);
    
    
    if(self.request)
        [[RequestQueue mainQueue] cancelRequest:self.request];
    self.request = NULL;
    
    self.image.image = nil;
    self.object = nil;
    self.object = object;

    UIColor *color = coverThumbBorderColor;//[[SettingsManager sharedSettings] getColourFromObject:self.object defaultColout:coverThumbBorderColor];
    [self.bkg.layer setBackgroundColor:[color CGColor]];
    [self.bkg.layer setBorderColor: [color CGColor]];
    [self.bkg.layer setBorderWidth: coverThumbBorderThickness];
    self.bkg.layer.cornerRadius = coverThumbBorderRadius;
    self.bkg.layer.masksToBounds = YES;
  
    
    [self.image setAlpha:0.0f];
    [self.label setAlpha:0.0f];
    
    [self.indicator setHidesWhenStopped:YES];
    //[self.indicator setColor:[UIColor whiteColor]];

    [self loadImage];
    [self initLabel];
    
    
}


-(void) loadImage
{
    NSURL *url = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [self.object objectForKey:COVER_SIZE_SMALL]]];
   // NSData *data = [NSData dataWithContentsOfURL:url];
    
    self.indicator.center = self.image.center;
    [self.indicator startAnimating];
    
    //NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    self.request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:defaultTimeOutResponse];
    
   // NSLog(@"requests count %ld", [RequestQueue mainQueue].requestCount);
    
    [[RequestQueue mainQueue] addRequest:self.request completionHandler:^(__unused NSURLResponse *response, NSData *data, NSError *error) {
        
        self.request = NULL;

        if (!error)
        {

            UIImage *image = [UIImage imageWithData:data];
            [self.image setImage:image];
            [self.image setContentMode:UIViewContentModeScaleAspectFill];
            self.image.layer.masksToBounds = YES;
            
            
            [UIView animateWithDuration:thumbTransitionTime animations:^{
                
                [self.image setAlpha:1.0f];
                [self.label setAlpha:1.0f];
                
                
            } completion:^(BOOL finished) {
                
                [self.indicator stopAnimating];
                
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
            self.image.layer.masksToBounds = YES;
         
                
                [UIView animateWithDuration:thumbTransitionTime animations:^{
                    
                    [self.image setAlpha:1.0f];
                    [self.label setAlpha:1.0f];

                    
                } completion:^(BOOL finished) {
                    
                    [self.indicator stopAnimating];
                    
                }];

        
          }];
     */
    
}

-(void) prepareForReuse
{
   // NSLog(@"prepareForReuse requests count %ld", [RequestQueue mainQueue].requestCount);

    // cancel unloaded
    if(self.request)
        [[RequestQueue mainQueue] cancelRequest:self.request];

    self.request = NULL;
}

-(void) initLabel
{
    [self.label setTextColor:gridLabelColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:13.0f]];
    [self.label setText:[self.object objectForKey:@"title"]];
}



@end

