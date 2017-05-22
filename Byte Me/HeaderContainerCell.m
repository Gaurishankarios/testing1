//
//  HeaderContainerCell.m
//  Byte Me
//
//  Created by Leandro Marques on 29/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "HeaderContainerCell.h"
#import "Constants.h"
#import "RequestQueue.h"

@interface HeaderContainerCell ()
@property (nonatomic) NSDictionary *object;
@end

@implementation HeaderContainerCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:coverThumbBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void) initHeaderWithObject:(NSDictionary*) object
{
    //NSLog(@"initHeaderWithObject %@", object);
    self.image.image = nil;
    self.object = nil;
    
    [self.indicator setHidesWhenStopped:YES];
    [self.image setAlpha:0.0f];
    self.object = object;
    [self loadImage];
}


-(void) loadImage
{
    
    
    NSURL *url = [NSURL URLWithString:[ASSET_URL stringByAppendingString: [self.object objectForKey:COVER_SIZE]]];
    // NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self.indicator startAnimating];
    
    
    //NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:defaultTimeOutResponse];
    
    [[RequestQueue mainQueue] addRequest:request completionHandler:^(__unused NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error)
        {
            
            UIImage *image = [UIImage imageWithData:data];
            [self.image setImage:image];
            [self.image setContentMode:UIViewContentModeScaleAspectFill];
            
            
            [UIView animateWithDuration:carouselthumbTransitionTime animations:^{
                
                [self.image setAlpha:1.0f];
                
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
        
        
        [UIView animateWithDuration:carouselthumbTransitionTime animations:^{
            
            [self.image setAlpha:1.0f];
            
        } completion:^(BOOL finished) {
            
            [self.indicator stopAnimating];
            
        }];
        
        
    }];
     */
    
    
    
}

@end
