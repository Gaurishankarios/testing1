//
//  TagsContainerCell.h
//  Byte Me
//
//  Created by Leandro Marques on 18/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTagList.h"

@interface TagsContainerCell : UITableViewCell<DWTagListDelegate>
@property (nonatomic, weak) IBOutlet DWTagList    *tagList;

-(void) initTagsWithObject:(NSDictionary*) object delegate:(id) delegate;
@end
