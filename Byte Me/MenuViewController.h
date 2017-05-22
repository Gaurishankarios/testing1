//
//  MenuViewController.h
//  Byte Me
//
//  Created by Leandro Marques on 28/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKExpandTableView.h"
@import MessageUI;


@interface MenuViewController : UIViewController
<JKExpandTableViewDelegate, JKExpandTableViewDataSource, MFMailComposeViewControllerDelegate>

@property(nonatomic,weak) IBOutlet JKExpandTableView * expandTableView;

@property(nonatomic,strong) NSMutableArray * dataModelArray;


@end
