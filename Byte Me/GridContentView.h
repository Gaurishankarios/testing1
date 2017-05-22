//
//  GridContentView.h
//  Byte Me
//
//  Created by Leandro Marques on 12/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridContentView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bytesCollectionTopMarginConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *bytesCollection;
@property (nonatomic) NSMutableArray *bytesData;
@property (nonatomic) int selected;

-(void) initGridWithDicitionary:(NSDictionary *) data delegate:(id) delegate;

@end

