//
//  PlatformCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 21/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) NSString *imageName;


@end
