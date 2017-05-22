//
//  CarouselContainerCell.h
//  Byte Me
//
//  Created by Leandro Marques on 07/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarouselContentView;

@interface CarouselContainerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CarouselContentView *carouselContentView;

@end
