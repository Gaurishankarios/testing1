//
//  KeyboardViewController.h
//  Byte Me Keyboard
//
//  Created by Leandro Marques on 07/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KeyboardViewController : UIViewController//UIInputViewController
@property (weak, nonatomic) IBOutlet UIButton *nextKeyboardBtn;
@property (weak, nonatomic) IBOutlet UIButton *backspaceKeyboardBtn;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@end
