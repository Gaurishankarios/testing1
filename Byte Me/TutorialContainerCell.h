//
//  TutorialContainerCell.h
//  Byte Me
//
//  Created by Leandro Marques on 04/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TutorialContentView;
@interface TutorialContainerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TutorialContentView *tutorialContentView;

@end
