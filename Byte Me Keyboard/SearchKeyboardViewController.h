//
//  SearchViewController.h
//  Byte Me
//
//  Created by Leandro Marques on 17/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardUIView.h"

@interface SearchKeyboardViewController : UIViewController<KeyboardUIViewDelegate, UISearchBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *suggesterCollection;
@property (nonatomic) UIVisualEffectView *visualEffectView;



-(void) updateSerchButton;

@end
