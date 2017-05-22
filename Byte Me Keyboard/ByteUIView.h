//
//  ByteUIView.h
//  Byte Me
//
//  Created by Leandro Marques on 20/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByteUIView : UIView<UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) NSArray *platformObjects;

-(void) setGestureEnabled:(BOOL)enabled;
@end
