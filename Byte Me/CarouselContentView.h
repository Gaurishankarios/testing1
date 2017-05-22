//
//  CarouselContentView.h
//  Byte Me
//
//  Created by Leandro Marques on 07/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselContentView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *carouselCollection;

-(void) initCarouselWithArray:(NSArray *) array delegate:(id) delegate;
@end
