//
//  MultilineUILabel.m
//  Byte Me
//
//  Created by Leandro Marques on 15/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "MultilineUILabel.h"
#import "Constants.h"

@implementation MultilineUILabel

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize theSize = [super sizeThatFits:size];
    return CGSizeMake(theSize.width, theSize.height + 25.0f);
}

@end
