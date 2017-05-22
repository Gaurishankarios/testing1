//
//  GridCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 12/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *bkg;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

-(void) initCellWithObject:(NSDictionary*) object;

@end
