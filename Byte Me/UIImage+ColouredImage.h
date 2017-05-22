//
//  UIImage+ColouredImage.h
//  Byte Me
//
//  Created by Leandro Marques on 11/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColouredImage)
+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;
@end
