//
//  MainCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 07/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *shield;
@property (weak, nonatomic) IBOutlet UIView *shadow;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UIColor *themeColorEdge;
@property (strong, nonatomic) UIColor *keyColor;

@property (weak, nonatomic) UICollectionView *parentCollectionView;
@property (weak, nonatomic) id delegate;

//-(void) initCellWithData:(NSArray*)data;
-(void) initCellWithData:(NSMutableDictionary *)data;
-(void) toggleSubCellsHidden:(BOOL) hidden hideBytes:(BOOL) bytes;
-(void) toogleScrollEnabled:(BOOL) enable;
@end
