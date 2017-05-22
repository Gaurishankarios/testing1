//
//  MenuViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 28/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "ContentViewController.h"
#import "DecodedString.h"
#import "SettingsManager.h"
#import "JKParentTableViewCell.h"
#import "JKSubTableViewCellCell.h"
#import "JKSingleSelectSubTableViewCell.h"

@interface MenuViewController ()
@property (nonatomic) NSMutableArray *items;
@end


@implementation MenuViewController
@synthesize expandTableView, dataModelArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:menuBackgroundColor];
    [self loadData];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setSelectedSection];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseCarousel" object:nil userInfo:nil];
}


-(void) setSelectedSection
{
    if(self.dataModelArray)
    {
        
        [self.expandTableView reloadData];
        
        // cell based on currentpageid
        UITableViewCell *selectedCellById = nil;
        
        int currentPageId = [[SettingsManager sharedSettings] currentPageId];
        
        for(int i = 0; i< [self.expandTableView numberOfRowsInSection:0]; i++)
        {
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.expandTableView cellForRowAtIndexPath:indexPath];
            if ([cell isKindOfClass:[JKParentTableViewCell class]])
            {
                
                JKParentTableViewCell * pCell = (JKParentTableViewCell *) cell;
                NSInteger children = [self.expandTableView numberOfChildrenUnderParentIndex: [pCell parentIndex]];

                
                if(children > 0)
                {
                    for(int c = 0; c< children; c++)
                    {
                        int childId = [self idForCellAtChildIndex:c withinParentCellIndex:[pCell parentIndex]];
                        
                        if(childId == currentPageId)
                        {
                            selectedCellById = pCell;
                            break;
                        }
                    }
                    
                }
                else
                {
                    if(pCell.sectionId == currentPageId)
                    {
                        selectedCellById = pCell;
                        break;
                    }
                }
                
                /*
                NSInteger children = [self.expandTableView numberOfChildrenUnderParentIndex: [pCell parentIndex]];
                
                if(children > 0)
                {
                    if ([[self.expandTableView.expansionStates objectAtIndex:[pCell parentIndex]] boolValue]) {
                        [self.expandTableView collapseForParentAtRow:indexPath.row];
                        [self.expandTableView animateParentCellIconExpand:NO forCell:pCell];
                    }
                }
                 */
            
            }

                
                
            
            
        }
        
      //  NSLog(@"selectedCellById %d",((JKParentTableViewCell *)selectedCellById).sectionId );
        
        
        /*
        NSIndexPath *selectedIndex = self.expandTableView.indexPathForSelectedRow;
        
        NSLog(@"selectd index %@",selectedIndex);
        
        if(selectedIndex)
        {
            UITableViewCell *selectedCell = [self.expandTableView cellForRowAtIndexPath:selectedIndex];
            if ([selectedCell isKindOfClass:[JKParentTableViewCell class]]) {
                
                JKParentTableViewCell * pCell = (JKParentTableViewCell *) selectedCell;
                
                NSInteger children = [self.expandTableView numberOfChildrenUnderParentIndex: [pCell parentIndex]];
                
                if(children > 0)
                {
                    if ([[self.expandTableView.expansionStates objectAtIndex:[pCell parentIndex]] boolValue]) {
                        [self.expandTableView collapseForParentAtRow:selectedIndex.row];
                        [self.expandTableView animateParentCellIconExpand:NO forCell:pCell];
                    } else {
                        [self.expandTableView expandForParentAtRow:selectedIndex.row];
                        [self.expandTableView animateParentCellIconExpand:YES forCell:pCell];
                    }
                }
                else
                {
                    
                }
                
            }
        }
         */
        
        NSIndexPath *selectedIndex = self.expandTableView.indexPathForSelectedRow;
        UITableViewCell *selectedCell = [self.expandTableView cellForRowAtIndexPath:selectedIndex];
        
       // NSLog(@"selectedCell %d",((JKParentTableViewCell *)selectedCell).sectionId );

        if(selectedCellById)
            selectedCell = selectedCellById;
        
       // NSLog(@"selectedCell afetr %d",((JKParentTableViewCell *)selectedCell).sectionId );

        for(int i = 0; i< [self.expandTableView numberOfRowsInSection:0]; i++)
        {
           
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.expandTableView cellForRowAtIndexPath:indexPath];
            if ([cell isKindOfClass:[JKParentTableViewCell class]])
            {
                JKParentTableViewCell * pCell = (JKParentTableViewCell *) cell;
                NSInteger children = [self.expandTableView numberOfChildrenUnderParentIndex: [pCell parentIndex]];
                
                if(selectedCell != cell)
                {
                    if(children > 0)
                    {
                        if ([[self.expandTableView.expansionStates objectAtIndex:[pCell parentIndex]] boolValue]) {
                            [self.expandTableView collapseForParentAtRow:indexPath.row];
                            [self.expandTableView animateParentCellIconExpand:NO forCell:pCell];
                        }
                    }
                    else
                    {
                        [pCell highlightCell:NO];
                    }
                }
                else if(selectedCell == cell)
                {
                    if(children > 0)
                    {
                        if (![[self.expandTableView.expansionStates objectAtIndex:[pCell parentIndex]] boolValue]) {
                            [self.expandTableView expandForParentAtRow:indexPath.row];
                            [self.expandTableView animateParentCellIconExpand:YES forCell:pCell];
                        }
                    }
                    else
                    {
                        [pCell highlightCell:YES];
                    }
                }

            }
        
        }

        /*
        for(int i = 0; i< [self.expandTableView numberOfRowsInSection:0]; i++)
        {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *selectedCell = [self.expandTableView cellForRowAtIndexPath:indexPath];
            if ([selectedCell isKindOfClass:[JKParentTableViewCell class]]) {
                
                JKParentTableViewCell * pCell = (JKParentTableViewCell *) selectedCell;
                
                NSInteger children = [self.expandTableView numberOfChildrenUnderParentIndex: [pCell parentIndex]];
                
                if(children > 0)
                {
                    if ([[self.expandTableView.expansionStates objectAtIndex:[pCell parentIndex]] boolValue]) {
                        [self.expandTableView collapseForParentAtRow:indexPath.row];
                        [self.expandTableView animateParentCellIconExpand:NO forCell:pCell];
                    } else {
                        [self.expandTableView expandForParentAtRow:indexPath.row];
                        [self.expandTableView animateParentCellIconExpand:YES forCell:pCell];
                    }
                }
                else
                {
                    if ([self.expandTableView.tableViewDelegate respondsToSelector:@selector(tableView:didSelectParentCellAtIndex:)]) {
                        [self.expandTableView.tableViewDelegate tableView:tableView didSelectParentCellAtIndex:[pCell parentIndex]];
                    }
                }
                
            } else {
                // ignore clicks on child because the sub table should handle it.
            }
        }
         */

    }
}

-(void)loadData
{
   // NSLog(@"loadData ");

    NSURL *indexDataURL = [NSURL URLWithString:[API_URL stringByAppendingString:@"sidenav.json"]];
    
    
    NSLog(@"indexDataURL menu %@",indexDataURL);
    
    NSError *errorLoad = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:indexDataURL options:NSDataReadingUncached error:&errorLoad];
    
    if (errorLoad) {
        NSLog(@"%@", [errorLoad localizedDescription]);
    } else {
       // NSLog(@"Data has loaded successfully.");
 
    
        NSError *errorParse = nil;
        NSDictionary *dataDictionary = [NSJSONSerialization
                                        JSONObjectWithData:jsonData options:0 error:&errorParse];
        
        if (errorParse) {
            NSLog(@"%@", [errorParse localizedDescription]);
        } else {
           //NSLog(@"Data has parsed successfully %@",dataDictionary);
            
            
            
            // check total parents
            
            // get parents
            
                // check total children
            
                // get children
            
            
            /* sidenav model
                data
                    categories_list
                        items
                            id
                                id
                                name
                                description
                                target
                                children
                                    items
                                        id
                                            id
                                            name
                                            description
                                            target
                                    total
                        total
            */
            
            NSDictionary *data = [dataDictionary objectForKey:@"data"];
            NSDictionary *categories_list = [data objectForKey:@"categories_list"];
            NSNumber *categories_list_total = [categories_list objectForKey:@"total"];

            if(data)
            {
               // NSLog(@"data ok");
                
                if(categories_list)
                {
                   // NSLog(@"categories_list ok");
                    
                    if(categories_list_total)
                    {
                      //  NSLog(@"categories_list_total ok");
                        
                        if([categories_list_total intValue] > 0)
                        {
                            self.dataModelArray = [[NSMutableArray alloc] initWithCapacity:[categories_list_total intValue]];

                            
                           // NSLog(@"categories_list_total > 0");
                            NSDictionary *categories_list_items = [categories_list objectForKey:@"items"];
                            
                            if(categories_list_items)
                            {
                             //   NSLog(@"categories_list_items ok");
                                
                                
                                // Settings
                                NSDictionary *home_item_meta = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    
                                                                @"0", @"id",
                                                                [@"Home" uppercaseString], @"name",
                                                                    
                                                                    @"home", @"target",
                                                                    nil];
                                
                                
                                NSMutableArray *home_category = [[NSMutableArray alloc] initWithObjects:
                                                                     home_item_meta,
                                                                     [[NSMutableArray alloc] init],
                                                                     nil
                                                                     ];
                                
                                [self.dataModelArray addObject:home_category];
                                
                                
                                
                                
                               // for (NSDictionary *item in categories_list_items)
                                for (int i=1; i <= [categories_list_total intValue]; i++)
                                {
                                    NSString *item = [NSString stringWithFormat:@"%d",i];
                                    
                                    // NSLog(@"item %@", [categories_list_items objectForKey:item]);

                                    NSDictionary *parent_item = [categories_list_items objectForKey:item];
                                    
                                    NSMutableArray *parent_category_children = [[NSMutableArray alloc] init];
                                    
                                    NSMutableDictionary *parent_item_meta = [[NSMutableDictionary alloc] init];
                                    
                                    [parent_item_meta setObject:[parent_item objectForKey:@"id"] forKey: @"id"];
                                    [parent_item_meta setObject:[[DecodedString decodedStringWithString:[parent_item objectForKey:@"name"]] uppercaseString] forKey: @"name"];
                                    [parent_item_meta setObject:[parent_item objectForKey:@"description"] forKey: @"description"];
                                    [parent_item_meta setObject:[parent_item objectForKey:@"target"] forKey: @"target"];
                                    [parent_item_meta setObject:[parent_item objectForKey:@"colour"] forKey: @"colour"];
                                    [parent_item_meta setObject:[parent_item objectForKey:@"background"] forKey: @"background"];
                                    
                                    /*
                                    NSDictionary *parent_item_meta = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [parent_item objectForKey:@"id"], @"id",
                                                      [[DecodedString decodedStringWithString:[parent_item objectForKey:@"name"]] uppercaseString], @"name",
                                                                     [parent_item objectForKey:@"description"], @"description",
                                                                     [parent_item objectForKey:@"target"], @"target",
                                                                     nil];
                                     */


                                    NSMutableArray *parent_category = [[NSMutableArray alloc] initWithObjects:
                                                                       parent_item_meta,
                                                                       parent_category_children,
                                                                       nil
                                                                      ];
                                    

                                    
                                    NSDictionary *children = [[categories_list_items objectForKey:item] objectForKey:@"children"];
                                    NSNumber *children_total = [children objectForKey:@"total"];

                                    
                                    if([children_total intValue] > 0)
                                    {
                                        //  NSLog(@"children_total ok");
                                        NSDictionary *children_items = [children objectForKey:@"items"];
                                        
                                        
                                        // category all
                                        NSMutableDictionary *child_all_item_meta = [[NSMutableDictionary alloc] init];
                                        [child_all_item_meta setObject:[parent_item objectForKey:@"id"] forKey: @"id"];
                                        [child_all_item_meta setObject:[[@"All " stringByAppendingString:[DecodedString decodedStringWithString:[parent_item objectForKey:@"name"]]] uppercaseString] forKey: @"name"];
                                        [child_all_item_meta setObject:[parent_item objectForKey:@"description"] forKey: @"description"];
                                        [child_all_item_meta setObject:[parent_item objectForKey:@"target"] forKey: @"target"];
                                        
                                        [child_all_item_meta setObject:[parent_item objectForKey:@"background"] forKey: @"background"];
                                        [child_all_item_meta setObject:[parent_item objectForKey:@"colour"] forKey: @"colour"];
                                        /*
                                        NSDictionary *child_all_item_meta = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [parent_item objectForKey:@"id"], @"id",
                                                                             [[@"All " stringByAppendingString:[DecodedString decodedStringWithString:[parent_item objectForKey:@"name"]]] uppercaseString], @"name",
                                                                         [parent_item objectForKey:@"description"], @"description",
                                                                         [parent_item objectForKey:@"target"], @"target",
                                                                         nil];
                                         */
                                        
                                        [parent_category_children addObject:child_all_item_meta];


                                        
                                        for (NSDictionary *c_item in children_items)
                                        {
                                           // NSLog(@"c_item %@", [children_items objectForKey:c_item]);
                                            
                                            NSDictionary *child_item = [children_items objectForKey:c_item];
                                            
                                            
                                            
                                            NSMutableDictionary *child_item_meta = [[NSMutableDictionary alloc] init];
                                            
                                            
                                            [child_item_meta setObject: [child_item objectForKey:@"id"] forKey:@"id"];
                                            [child_item_meta setObject: [[DecodedString decodedStringWithString:[child_item objectForKey:@"name"]] uppercaseString]
                                                                forKey:@"name"];
                                            
                                            if([child_item objectForKey:@"description"])
                                            [child_item_meta setObject: [child_item objectForKey:@"description"] forKey:@"description"];
                                            
                                            if([child_item objectForKey:@"target"])
                                            [child_item_meta setObject: [child_item objectForKey:@"target"] forKey:@"target"];

                                            
                                           
                                            [parent_category_children addObject:child_item_meta];

                                            
                                        }
                                        

                                        

                                    }
                                    else
                                    {
                                        //NSLog(@"children_total = 0");
                                    }
                                    
                                    [self.dataModelArray addObject:parent_category];
                                    
                                }
                                
                                // Settings
                                NSDictionary *settings_item_meta = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    @"-1", @"id",
                                                                    [@"Settings" uppercaseString], @"name",
                                                                    @"settings", @"target",
                                                                    nil];
                                
                                
                                
                                
                                // Settings Children
                                NSMutableArray *settings_children = [[NSMutableArray alloc] initWithObjects:
                                                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      @"-2", @"id",
                                                                      [@"My Bytes" uppercaseString], @"name",
                                                                      @"mybytes", @"target",
                                                                      nil],
                                                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      @"-4", @"id",
                                                                      @"ENABLE KEYBOARD", @"name",
                                                                      @"tutorial", @"target",
                                                                      nil],
                                                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      @"-7", @"id",                    [@"Rate the app" uppercaseString], @"name",
                                                                      @"rate", @"target",
                                                                      nil],
                                                                     /*
                                                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      @"-3", @"id",                      [@"Help" uppercaseString], @"name",
                                                                      @"help", @"target",
                                                                      nil],
                                                                      */
                                                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      @"-6", @"id",                     [@"Feedback" uppercaseString], @"name",
                                                                      @"feedback", @"target",
                                                                      nil],
                                                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      @"-5", @"id",                     [@"Legal" uppercaseString], @"name",
                                                                      @"legals", @"target",
                                                                      nil],
                                                                     
                                                                     nil];
                                
                                NSMutableArray *settings_category = [[NSMutableArray alloc] initWithObjects:
                                                                     settings_item_meta,
                                                                     settings_children,
                                                                     //[[NSMutableArray alloc] init],
                                                                     nil
                                                                     ];
                                
                                [self.dataModelArray addObject:settings_category];



                            }
                            else
                            {
                                //NSLog(@"no categories_list_items");
                            }
                        }
                        else
                        {
                            //NSLog(@"categories_list_total = 0");
                        }
                    }
                    else
                    {
                       // NSLog(@"no categories_list_total");
                    }
                }
                else
                {
                   // NSLog(@"no categories_list");
                }
            }
            else
            {
                //NSLog(@"no data");
            }
            
            [self.expandTableView setDataSourceDelegate:self];
            [self.expandTableView setTableViewDelegate:self];
            
            //NSLog(@" model %@", self.dataModelArray);
            
            
        
        }
    }
  
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - JKExpandTableViewDelegate
// return YES if more than one child under this parent can be selected at the same time.  Otherwise, return NO.
// it is permissible to have a mix of multi-selectables and non-multi-selectables.
- (BOOL) shouldSupportMultipleSelectableChildrenAtParentIndex:(NSInteger) parentIndex {
    /*
    if ((parentIndex % 2) == 0) {
        return NO;
    } else {
        return YES;
    }
     */
    return NO;

}

-(void) tableView:(UITableView *)tableView didSelectParentCellAtIndex:(NSInteger)parentIndex
{
    //NSLog(@"didSelectParentCellAtIndex parentIndex %ld", (long)parentIndex);
    
    
    NSDictionary *data = [[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:0];

    NSString *target = [data objectForKey:@"target"];
    
    if ([target isEqualToString: @"feedback"])
    {
        [self showFeedback];
    }
    else if ([target isEqualToString: @"rate"])
    {
        [self showRateUs];
    }
    else
        [self performSegueWithIdentifier:@"MenuSegue" sender:data];
    
    /*
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [revealViewController rightRevealToggleAnimated:YES];
    }
     */

}
- (void) tableView:(UITableView *)tableView didSelectCellAtChildIndex:(NSInteger) childIndex withInParentCellIndex:(NSInteger) parentIndex {
    //[[self.dataModelArray objectAtIndex:parentIndex] setObject:[NSNumber numberWithBool:YES] atIndex:childIndex];
    //NSLog(@"didSelectCellAtChildIndex %ld parentIndex %ld", (long)childIndex, (long)parentIndex);
    
    
    //NSLog(@"dataModelArray %@", [[[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:1] objectAtIndex:childIndex]);
    NSDictionary *data = [[[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:1] objectAtIndex:childIndex];
    
    NSString *target = [data objectForKey:@"target"];
    
    if ([target isEqualToString: @"feedback"])
    {
        [self showFeedback];
    }
    else if ([target isEqualToString: @"rate"])
    {
        [self showRateUs];
    }
    else
        [self performSegueWithIdentifier:@"MenuSegue" sender:data];

    
}

- (void) tableView:(UITableView *)tableView didDeselectCellAtChildIndex:(NSInteger) childIndex withInParentCellIndex:(NSInteger) parentIndex {
   //[[self.dataModelArray objectAtIndex:parentIndex] setObject:[NSNumber numberWithBool:NO] atIndex:childIndex];
    NSLog(@"didDeselectCellAtChildIndex %ld parentIndex %ld", (long)childIndex, (long)parentIndex);
}

- (UIFont *) fontForParents {
    return [UIFont fontWithName:@"Quicksand-Bold" size:17.0f];
}

- (UIFont *) fontForChildren {
    return [UIFont fontWithName:@"Quicksand-Bold" size:17.0f];
}
/*
 - (UIColor *) foregroundColor {
 return [UIColor darkTextColor];
 }
 
 - (UIColor *) backgroundColor {
 return [UIColor grayColor];
 }


 */
/*
 - (UIImage *) selectionIndicatorIcon {
 return [UIImage imageNamed:@"green_checkmark"];
 }
 */
#pragma mark - JKExpandTableViewDataSource
- (NSInteger) numberOfParentCells {
    return [self.dataModelArray count];
}

- (NSInteger) numberOfChildCellsUnderParentIndex:(NSInteger) parentIndex {
    //NSMutableArray *childArray = [self.dataModelArray objectAtIndex:parentIndex];
    
    NSMutableArray *childArray = [[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:1];

    return [childArray count];
}

- (NSString *) labelForParentCellAtIndex:(NSInteger) parentIndex {
    
    NSDictionary *meta = [[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:0];
    return [meta objectForKey:@"name"];
    //return [NSString stringWithFormat:@"parent %ld", (long)parentIndex];
}


- (NSString *) labelForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex {
    NSDictionary *meta = [[[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:1] objectAtIndex:childIndex];
    return [meta objectForKey:@"name"];
   // return [NSString stringWithFormat:@"child %ld of parent %ld", (long)childIndex, (long)parentIndex];
}

- (int ) idForParentCellAtIndex:(NSInteger) parentIndex {
    
    NSDictionary *meta = [[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:0];
    return [[meta objectForKey:@"id"] intValue];
}

- (int ) idForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex {
    NSDictionary *meta = [[[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:1] objectAtIndex:childIndex];
    return [[meta objectForKey:@"id"] intValue];
}

- (BOOL) shouldDisplaySelectedStateForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex {
   // NSMutableArray *childArray = [[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:1];
    //return [[childArray objectAtIndex:childIndex] boolValue];
    return NO;
}

- (BOOL) shouldHighlightCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex {
    
    int currentId = [[SettingsManager sharedSettings] currentPageId];
    int childId = [self idForCellAtChildIndex:childIndex withinParentCellIndex:parentIndex];    
    
    if(childId == currentId)
        return YES;
    else
        return NO;
}

- (UIImage *) iconForParentCellAtIndex:(NSInteger) parentIndex {
    
    NSMutableArray *childArray = [[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:1];
    
    if([childArray count] > 0)
    {
        UIImage *image =  [UIImage imageNamed:@"key_arrow-icon"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        return image;
    }
    else
        return NULL;
}

- (UIImage *) iconLeftForCellAtIndex:(NSInteger) parentIndex {
    
    
        UIImage *image =  [UIImage imageNamed:@"key_dot"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        return image;
   }

- (UIColor *) iconLeftColourForCellAtIndex:(NSInteger) parentIndex {
    
    NSDictionary *meta = [[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:0];

    return [[SettingsManager sharedSettings] getColourFromObject:meta defaultColout:menuLeftIconColor];
}

 - (UIImage *) iconForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex {
     
     UIImage *image =  [UIImage imageNamed:@"key_dot"];
     image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
     
     return image;

 }

- (UIColor *) iconColourForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex
{
    NSDictionary *meta = [[self.dataModelArray objectAtIndex:parentIndex] objectAtIndex:0];
    
    return [[SettingsManager sharedSettings] getColourFromObject:meta defaultColout:menuLeftIconColor];
}


/*
- (UIImage *) iconForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex {
    if (((childIndex + parentIndex) % 3) == 0) {
        return [UIImage imageNamed:@"heart"];
    } else if ((childIndex % 2) == 0) {
        return [UIImage imageNamed:@"cat"];
    } else {
        return [UIImage imageNamed:@"dog"];
    }
}
 */

- (BOOL) shouldRotateIconForParentOnToggle {
    return YES;
}

-(UIColor *) backgroundColor
{
    return menuBackgroundColor;
}

-(UIColor *) foregroundColor
{
    return menuLabelColor;
}





- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    //NSLog(@"prepareForSegue %@ %@", segue, sender);

    
   // NSLog(@"prepareForSegue %@", sender);
    
    // configure the destination view controller:
   
        UINavigationController *navController = segue.destinationViewController;
        ContentViewController *contentController = [navController childViewControllers].firstObject;
    
        //NSArray *sender_array = (NSArray*) sender;
    
    /*
        NSDictionary *sender_meta = [sender objectAtIndex:0];
    
        NSLog(@"name  %@", [sender_meta objectForKey:@"name"]);

        [navController.navigationBar.topItem setTitle:[sender_meta objectForKey:@"name"]];
     */
    
        contentController.categoryData = sender;
        [contentController initPage];

        /*
        UILabel* c = [(SWUITableViewCell *)sender label];
        UINavigationController *navController = segue.destinationViewController;
        ColorViewController* cvc = [navController childViewControllers].firstObject;
        if ( [cvc isKindOfClass:[ColorViewController class]] )
        {
            cvc.color = c.textColor;
            cvc.text = c.text;
        }
         */
}

-(void) showFeedback
{
    if (![MFMailComposeViewController canSendMail]) {
           // NSLog(@"Mail services are not available.");
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops"
         message:@"Feedback services are not available."
         delegate:nil
         cancelButtonTitle:@"Ok"
         otherButtonTitles:nil];
         [alert show];
    }
    else
    {
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        
        composeVC.navigationBar.tintColor = navigationBarTintColor;
        [composeVC.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:navigationLabelColor, NSFontAttributeName:[UIFont fontWithName:@"Quicksand-Bold" size:17.0f]}];

        composeVC.mailComposeDelegate = self;
        
        [composeVC setToRecipients:@[feedbackEmailAddress]];
        [composeVC setSubject:feedbackSubject];
        //[composeVC setMessageBody:@"Hello from Byte.Me App!" isHTML:NO];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
        
        
    }
    
    // NSLog(@"target %@",target);
}

-(void) showRateUs
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APP_STORE_ID]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

@end
