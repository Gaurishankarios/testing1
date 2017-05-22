//
//  MyBytesCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 21/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBytesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bkg;
@property (weak, nonatomic) IBOutlet UIImageView *image;
//@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIImageView *status;
@property (weak, nonatomic) IBOutlet UIImageView *statusBkg;

-(void) initCellWithObject:(NSDictionary*) object;
-(void) changeStatus;
@end
