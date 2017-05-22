//
//  FooterContainerCell.h
//  Byte Me
//
//  Created by Leandro Marques on 21/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface FooterContainerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *arrow;

@property  (nonatomic) ContentViewController *delegate;

@end
