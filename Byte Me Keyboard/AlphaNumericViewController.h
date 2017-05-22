//
//  AlphaNumericViewController.h
//  Byte Me
//
//  Created by Leandro Marques on 19/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardUIView.h"

@interface AlphaNumericViewController : UIViewController<KeyboardUIViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIView *msgView;


@end
