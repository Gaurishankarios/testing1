//
//  SearchViewController.h
//  Byte Me
//
//  Created by Leandro Marques on 13/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@import MessageUI;

@interface SearchViewController : UITableViewController< UISearchBarDelegate, MFMailComposeViewControllerDelegate>
@property  (nonatomic) NSDictionary *categoryData;
@property(nonatomic,strong) NSMutableArray * carouselModelArray;
@property(nonatomic,strong) NSMutableArray * featuredModelArray;
@property(nonatomic,strong) NSMutableArray * tableData;
@property  (nonatomic) NSString *searchPath;


@end

