//
//  MyBytesContentView.h
//  Byte Me
//
//  Created by Leandro Marques on 21/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBytesContentView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *bytesCollection;


-(void) initGridWithDicitionary:(NSDictionary *) data delegate:(id) delegate;


@end
