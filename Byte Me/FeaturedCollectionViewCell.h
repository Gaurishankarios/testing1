//
//  FeaturedCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 08/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

-(void) initCellWithObject:(NSDictionary*) object;

@end
