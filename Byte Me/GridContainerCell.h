//
//  GridContainerCell.h
//  Byte Me
//
//  Created by Leandro Marques on 12/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GridContentView;

@interface GridContainerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GridContentView *gridContentView;

@end
