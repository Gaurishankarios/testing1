//
//  ContentViewController.h
//  Byte Me
//
//  Created by Leandro Marques on 28/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UITableViewController
@property  (nonatomic) NSDictionary *categoryData;
@property(nonatomic,strong) NSMutableArray * carouselModelArray;
@property(nonatomic,strong) NSMutableArray * featuredModelArray;
@property(nonatomic,strong) NSMutableArray * tableData;
- (void) initPage;
-(void) showMyBytes;
-(void) showHome;

@end
