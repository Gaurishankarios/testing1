//
//  MyBytesCollectionHeaderCell.h
//  Byte Me
//
//  Created by Leandro Marques on 24/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBytesCollectionHeaderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *bytesInstalledCount;
@property (weak, nonatomic) IBOutlet UILabel *bytesEnabledCount;
@property (weak, nonatomic) IBOutlet UILabel *bytesInstalledLabel;
@property (weak, nonatomic) IBOutlet UILabel *bytesEnabledLabel;
-(void) initHeader;
-(void) updateMyBytesHeader:(NSNotification *)notis;

@end
