//
//  FeaturedContentView.h
//  Byte Me
//
//  Created by Leandro Marques on 08/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedContentView : UIView <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *bytesCollection;
@property (nonatomic) NSDictionary *featuredData;
@property (nonatomic) NSMutableArray *bytesData;
@property (nonatomic) int selected;

-(void) initFeaturedWithDicitionary:(NSDictionary *) data delegate:(id) delegate last:(BOOL) last;

@end
