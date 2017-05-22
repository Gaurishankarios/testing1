//
//  TutorialContentView.h
//  Byte Me
//
//  Created by Leandro Marques on 04/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentView : UIView <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *tutorialCollection;

-(void) initTutorialWithDicitionary:(NSDictionary *) data delegate:(id) delegate;

@end
