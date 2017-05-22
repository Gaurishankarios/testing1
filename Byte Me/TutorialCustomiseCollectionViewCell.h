//
//  TutorialCustomiseCollectionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 05/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialCustomiseCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *subTitle;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic) id delegate;


@end
