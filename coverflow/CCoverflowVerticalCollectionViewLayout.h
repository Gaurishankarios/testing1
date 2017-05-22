//
//  CCoverflowVerticalCollectionViewLayout.h
//  Byte Me
//
//  Created by Leandro Marques on 08/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCoverflowVerticalCollectionViewLayout : UICollectionViewLayout
@property (readwrite, nonatomic, assign) CGSize cellSize;
@property (readwrite, nonatomic, assign) CGFloat cellSpacing;
@property (readwrite, nonatomic, assign) BOOL snapToCells;
@property (readonly, nonatomic, strong) NSIndexPath *currentIndexPath;
@end
