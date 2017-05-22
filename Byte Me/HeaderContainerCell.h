//
//  HeaderContainerCell.h
//  Byte Me
//
//  Created by Leandro Marques on 29/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderContainerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
-(void) initHeaderWithObject:(NSDictionary*) object;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end
