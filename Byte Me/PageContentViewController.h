//
//  PageViewController.h
//  Byte Me
//
//  Created by Leandro Marques on 28/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UILabel *label;
-(void) setTitleLabel:(NSString *)t description:(NSString *)d colour:(UIColor*)c;
@end
