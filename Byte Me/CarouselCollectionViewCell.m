//
//  CarouselCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 07/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "CarouselCollectionViewCell.h"
#import "Constants.h"
#import "RequestQueue.h"

@interface CarouselCollectionViewCell ()
@property (nonatomic) NSDictionary *object;
@property (nonatomic) NSInteger path;
@property (nonatomic) NSURLRequest *request;
@end

@implementation CarouselCollectionViewCell

- (void)awakeFromNib {
  

}



-(void) initCellWithObject:(NSDictionary*) object path:(NSInteger )indexPath
{
    if(self.request)
        [[RequestQueue mainQueue] cancelRequest:self.request];
    self.request = NULL;
    
    self.image.image = nil;
    self.object = nil;

    [self.indicator setHidesWhenStopped:YES];
    [self.image setAlpha:0.0f];
    self.object = object;
    self.path = indexPath;
    [self loadImage];
}


-(void) loadImage
{
    NSURL *url = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [self.object objectForKey:COVER_SIZE_SMALL]]];
   // NSData *data = [NSData dataWithContentsOfURL:url];
    
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
            
            
            [UIView animateWithDuration:carouselthumbTransitionTime animations:^{
                
                [self.image setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                
                [self.indicator stopAnimating];
                //  if(self.path == 1)
                //{
                //NSLog(@"CarouselCollectionViewCell showCarousel");
         
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showCarousel" object:nil userInfo:nil];
                // }
                
                
            }];
        }
        else
        {
            //loading error
        }
        
    }];

    
       
    

}


-(void) prepareForReuse
{
    // cancel unloaded
    if(self.request)
        [[RequestQueue mainQueue] cancelRequest:self.request];
    
    self.request = NULL;
}

@end
