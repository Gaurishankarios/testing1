//
//  CarouselCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 07/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
-(void) initCellWithObject:(NSDictionary*) object path:(NSInteger )indexPath;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
