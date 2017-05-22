//
//  ContentViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 28/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "ContentViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "CarouselContainerCell.h"
#import "FeaturedContainerCell.h"
#import "GridContainerCell.h"
#import "CarouselContentView.h"
#import "FeaturedContentView.h"
#import "GridContentView.h"
#import "ByteViewController.h"
#import "DecodedString.h"
#import "FooterContainerCell.h"
#import "MyBytesContainerCell.h"
#import "MyBytesContentView.h"
#import "HeaderContainerCell.h"
#import "LegalsContainerCell.h"
#import "TutorialContainerCell.h"
#import "TutorialContentView.h"
#import "CBZSplashView.h"
#import "UIBezierPath+Shapes.h"
#import "MessageContainerCell.h"
#import "Mixpanel.h"
#import "RequestQueue.h"

@interface ContentViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic) IBOutlet UIBarButtonItem* homeButtonItem;
@property (nonatomic) IBOutlet UIBarButtonItem* searchButtonItem;
@property (nonatomic) UIVisualEffectView* blurEffectView;
@property (nonatomic) CBZSplashView *splashView;
@property (nonatomic) BOOL isHome;
@property (nonatomic) BOOL hasSplash;
@property (nonatomic) id lastSeeAllClicked;

@end
@implementation ContentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customSetup];
   // [self updateTitle];

   // NSLog(@"viewDidLoad %@", self.categoryData);
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = refreshControlTintColor;
    refreshControl.backgroundColor = refreshControlBackgroundColor;
    [refreshControl addTarget:self action:@selector(initPage) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self.view setBackgroundColor:globalBackgroundColor];
    [self.tableView setBackgroundColor:globalBackgroundColor];
    
    if([[SettingsManager sharedSettings] isFirstScreen])
    {
        if([[SettingsManager sharedSettings] hasTutorialDone])
        {
            self.hasSplash = YES;
            
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            if (!window) {
                window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            }
            
            UIBezierPath *bezier = [UIBezierPath biscuitShape];
            UIColor *color = linkTintColor;
            
            self.splashView = [CBZSplashView splashViewWithBezierPath:bezier
                                                                backgroundColor:color];
            self.splashView.iconStartSize = CGSizeMake(80.0f, 80.f);
            self.splashView.animationDuration = 1.4;
            [window insertSubview:self.splashView aboveSubview:self.view];
            [window bringSubviewToFront:self.splashView];
            
        }
        
        [self initPage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[SettingsManager sharedSettings] loadStockBytes];
            
        });

    }
    
   

   
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self initPage];
    [self customSetup];
    
   // NSLog(@"viewWillAppear ");
    
    [self trackPageVisit];
    
    
//    [self getFooterData];
    
   
    [self updateCurrentPageId];
    
    if(![[SettingsManager sharedSettings] hasTutorialDone])
        self.navigationController.navigationBar.hidden = YES;
    else
        self.navigationController.navigationBar.hidden = NO;
    
    if(self.isHome)
    {
        if([[SettingsManager sharedSettings] hasTutorialDone])
        {
            
            if(self.categoryData)
            {
                NSString *target = [self.categoryData objectForKey:@"target"];
                if([target isEqualToString: @"home"])
                {
                   // NSLog(@"resume carousel");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeCarousel" object:nil userInfo:nil];

                }
            }
            else
            {
                //NSLog(@"resume carousel");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeCarousel" object:nil userInfo:nil];

            }
        }
    }
    
}

-(void) viewWillDisappear:(BOOL)animated
{
   // NSLog(@"viewWillDisappear");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseCarousel" object:nil userInfo:nil];

    [super viewWillDisappear:animated];
}


-(void) trackPageVisit
{
    if(![[SettingsManager sharedSettings] isFirstScreen])
    {
        if([[SettingsManager sharedSettings] hasTutorialDone])
        {
            NSString *section = @"Home";
            
            if(self.categoryData)
            {
                NSString *target = [self.categoryData objectForKey:@"target"];
                if([target isEqualToString: @"home"])
                    section = @"Home";
                else if ([target isEqualToString: @"settings"])
                    section = @"Settings";
                else if ([target isEqualToString: @"mybytes"])
                    section = @"My Bytes";
                else if ([target isEqualToString: @"legals"])
                    section = @"Legal";
                else if ([target isEqualToString: @"tutorial"])
                    section = @"";
                else
                {
                    //NSLog(@"self.categoryData %@",self.categoryData);
                    NSString *path = [self.categoryData objectForKey:@"path"];
                    NSString *name = [self.categoryData objectForKey:@"name"];
                    NSNumber *path_id = [self.categoryData objectForKey:@"path_id"];
                    NSNumber *cat_id = [self.categoryData objectForKey:@"id"];
                    
                    if(!path)
                        section = [NSString stringWithFormat: @"Category %@",name ];
                    else
                    {
                        if([path_id intValue] == [cat_id intValue])
                            section = [NSString stringWithFormat: @"Category %@",name ];
                        else
                            section = [NSString stringWithFormat: @"Category %@",path ];
                        
                    }
                    
                    
                    
                }
            }
            
            if(![section isEqualToString:@""])
            {
                // tracking
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel track:@"Page Visited" properties:@{
                                                             @"Component": @"Container",
                                                             @"Page":section
                                                             }];
            }
        }
    }
}


- (void)customSetup
{
    self.lastSeeAllClicked = nil;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        self.revealViewController.rightViewRevealOverdraw = 0.0f;
        //[self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setTarget: self];
        [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    [self.homeButtonItem setTarget: self];
    [self.homeButtonItem setAction: @selector( handleBackButtonTouch )];
    
    [self.searchButtonItem setTarget: self];
    [self.searchButtonItem setAction: @selector( handleSearchButtonTouch )];

}

-(void) rightRevealToggle:(id)sender
{
    [self.searchButtonItem setEnabled:!self.searchButtonItem.enabled];
    if(!self.searchButtonItem.enabled)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseCarousel" object:nil userInfo:nil];
        
        if (NSClassFromString(@"UIVisualEffectView") && !UIAccessibilityIsReduceTransparencyEnabled()) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            //[self.blurEffectView setFrame:self.view.frame];
            [self.blurEffectView setFrame:CGRectMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y, self.view.frame.size.height, self.view.frame.size.height)
             
             ];
            [self.tableView setScrollEnabled:NO];
            
            [self.blurEffectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeNavigation:)]];
            
            [self.view addSubview: self.blurEffectView];
            
        }

        [self.searchButtonItem setTintColor: [UIColor clearColor]];
        
        // tracking
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Page Visited" properties:@{
                                                     @"Component": @"Container",
                                                     @"Page":@"Sidenav"
                                                     }];

    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeCarousel" object:nil userInfo:nil];
        
        [self.tableView setScrollEnabled:YES];

        if (NSClassFromString(@"UIVisualEffectView") && !UIAccessibilityIsReduceTransparencyEnabled()) {
            [self.blurEffectView removeFromSuperview];
        }
        
        [self.searchButtonItem setTintColor: navigationBarTintColor];
        
        [self trackPageVisit];

    }

    [self.revealViewController rightRevealToggle:sender];
}

- (void)closeNavigation:(UITapGestureRecognizer *)inGestureRecognizer
{
    while (self.blurEffectView.gestureRecognizers.count) {
        [self.blurEffectView removeGestureRecognizer:[self.blurEffectView.gestureRecognizers objectAtIndex:0]];
    }

    [self rightRevealToggle:nil];
}


-(void) updateCurrentPageId
{
    if(self.categoryData)
    {
        int pageId = [[self.categoryData objectForKey:@"id"] intValue];
        [[SettingsManager sharedSettings] setCurrentPageId: pageId];
    }
    else
    {
        [[SettingsManager sharedSettings] setCurrentPageId: 0];
    }
    

}

- (void) initPage
{
    self.isHome = NO;
    
    if(![[SettingsManager sharedSettings] hasTutorialDone])
    {
        [[SettingsManager sharedSettings] setCurrentPageId: -4];
        self.refreshControl = nil;
     
        [self.homeButtonItem setImage:[UIImage imageNamed:@"key_arrow_left"]];
        [self loadTutorial];
        return;
    }
    
    [self updateTitle];

    if(self.categoryData)
    {

        // init page
        
        NSString *target = [self.categoryData objectForKey:@"target"];
       // NSLog(@"target %@",target);

        int pageId = [[self.categoryData objectForKey:@"id"] intValue];
        
        if([target isEqualToString: @"home"])
        {
            [[SettingsManager sharedSettings] setCurrentPageId: 0];
            
            self.isHome = YES;

            [self.homeButtonItem setImage:[UIImage imageNamed:@"key_biscuit"]];
            [self loadIndexData];
        }
        else if ([target isEqualToString: @"settings"])
        {
            [[SettingsManager sharedSettings] setCurrentPageId: pageId];
            self.refreshControl = nil;

            [self.homeButtonItem setImage:[UIImage imageNamed:@"key_arrow_left"]];
            

           // NSLog(@"target %@",target);
        }
        else if ([target isEqualToString: @"mybytes"])
        {
            [[SettingsManager sharedSettings] setCurrentPageId: pageId];
            self.refreshControl = nil;

            [self.homeButtonItem setImage:[UIImage imageNamed:@"key_arrow_left"]];
            [self loadMyBytes];
            
            // NSLog(@"target %@",target);
        }
        else if ([target isEqualToString: @"legals"])
        {
            [[SettingsManager sharedSettings] setCurrentPageId: pageId];
            self.refreshControl = nil;

            [self.homeButtonItem setImage:[UIImage imageNamed:@"key_arrow_left"]];
            [self loadLegalsData:target];

            // NSLog(@"target %@",target);
        }
        else if ([target isEqualToString: @"tutorial"])
        {
            [[SettingsManager sharedSettings] setCurrentPageId: pageId];
            self.refreshControl = nil;
            
            [self.homeButtonItem setImage:[UIImage imageNamed:@"key_arrow_left"]];
            [self loadTutorial];
            
            
            
            // NSLog(@"target %@",target);
        }
        else
        {
            // load parent
            [[SettingsManager sharedSettings] setCurrentPageId: pageId];

            [self.homeButtonItem setImage:[UIImage imageNamed:@"key_arrow_left"]];
            //NSLog(@"target %@",target);
            [self loadCategoryData:target];
        }


        
    }
    else
    {
        self.isHome = YES;

        // init home
        
        // load index
        [self loadIndexData];
        

    }
    
   // [self.searchButtonItem setEnabled:YES];

}



-(void) updateTitle
{
    NSString *title = @"HOME"; // Default title
    
    if(self.categoryData)
        title = [[DecodedString decodedStringWithString:[self.categoryData objectForKey:@"name"]] uppercaseString];
   
    [self setTitle:title];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:navigationLabelColor, NSFontAttributeName:[UIFont fontWithName:@"Quicksand-Bold" size:17.0f]}];
    [self.navigationController.navigationBar setTintColor:navigationBarTintColor];

}

-(void) updateTitleWithString:(NSString*) title
{
    [self setTitle:[[DecodedString decodedStringWithString:title] uppercaseString]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:navigationLabelColor, NSFontAttributeName:[UIFont fontWithName:@"Quicksand-Bold" size:17.0f]}];
    [self.navigationController.navigationBar setTintColor:navigationBarTintColor];
}




-(void)loadLegalsData:(NSString*)jsonPath
{
   // NSLog(@"loadLegalsData");
    
    NSURL *dataURL = [NSURL URLWithString:[API_URL stringByAppendingString:[jsonPath stringByAppendingString: @".json"]]];
    //NSLog(@"dataURL %@",dataURL);
    
    NSError *errorLoad = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:dataURL options:NSDataReadingUncached error:&errorLoad];
    self.tableData = [[NSMutableArray alloc] init];

    if (errorLoad) {
        NSLog(@"%@", [errorLoad localizedDescription]);
        
        [self loadErrorMessage];

    } else {
        //NSLog(@"Data has loaded successfully.");
        
        [self setNavItemsEnabled:YES];
        
        NSError *errorParse = nil;
        NSDictionary *dataDictionary = [NSJSONSerialization
                                        JSONObjectWithData:jsonData options:0 error:&errorParse];
        
        if (errorParse) {
            NSLog(@"%@", [errorParse localizedDescription]);
        } else {
            // NSLog(@"Data has parsed successfully %@",dataDictionary);
            
            /* index model
             data
                version
                legals
             */
            
            NSDictionary *data = [dataDictionary objectForKey:@"data"];
            
            
            if(data)
            {
                //NSLog(@"data ok");
                
                NSString *legals = [data objectForKey:@"legals"];
                
                
                if(legals)
                {
                    [self.tableData addObject:
                         [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:6],
                          legals,
                          nil]];
                        
                }
                //else
                    //NSLog(@"no legals");
            }
          //  else
               // NSLog(@"no data");
            
        }
        
        [self updateTable];

    }
    
}

-(void)loadMyBytes
{
    //NSLog(@"loadMyBytes");
    
    
    NSDictionary *data = [[SettingsManager sharedSettings] getBytes];
    
    self.tableData = [[NSMutableArray alloc] init];
    
    if(data)
    {
       // NSLog(@"data ok %d", (int)[data count]);
        
        self.featuredModelArray = [[NSMutableArray alloc] init];
    
        NSMutableDictionary *orderedBytes = [[NSMutableDictionary alloc] init];
        int count = 1;
        for(NSDictionary *b in data)
        {
            [orderedBytes setObject:[data objectForKey:b] forKey:[NSString stringWithFormat:@"%d",count]];
            
            count++;
        }
    
        NSDictionary *category_item = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"MY BYTES", @"name",
                                       @"", @"description",
                                       @"myBytes", @"target",

                                       [NSDictionary dictionaryWithObjectsAndKeys:
                                        orderedBytes, @"items",
                                        [NSNumber numberWithInt:(int)[data count]], @"total",
                                        nil], @"bytes",
                                       nil];
        
        
        [self.featuredModelArray addObject:category_item];
            
            
    }
    else
    {
       // NSLog(@"no data");
    }
    
    
    if (self.featuredModelArray)
        for(NSDictionary *i in self.featuredModelArray)
            [self.tableData addObject:
             [NSArray arrayWithObjects:
              [NSNumber numberWithInt:4],
              i,
              nil]];
    
    
    [self updateTable];
    NSLog(@" ...tableData %@", self.tableData);
    

    
}


-(void)loadErrorMessage
{
    
    [self setNavItemsEnabled:NO];
    
    self.tableData = [[NSMutableArray alloc] init];
    
    [self.tableData addObject:
     [NSArray arrayWithObjects:
      [NSNumber numberWithInt:8],
      @"Cannot Connect to\nByte.me",
      nil]];
    
    [self updateTable];
    
    if(self.hasSplash)
    {
        self.hasSplash = NO;
        [self.splashView startAnimation];
    }
    
}

-(void) setNavItemsEnabled:(BOOL) enabled
{
    
    [self.searchButtonItem setEnabled:enabled];
    [self.revealButtonItem setEnabled:enabled];
    //[self.homeButtonItem setEnabled:enabled];

}

-(void)loadTutorial
{
    
    self.tableData = [[NSMutableArray alloc] init];
    
    NSDictionary *category_item = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"ENABLE KEYBOARD", @"name",
                                   @"", @"description",
                                   @"tutorial", @"target",
                                   nil];

    [self.tableData addObject:
     [NSArray arrayWithObjects:
      [NSNumber numberWithInt:7],
      category_item,
      nil]];

    [self updateTable];
    
    if(self.hasSplash)
    {
        self.hasSplash = NO;
        [self.splashView startAnimation];
    }
    
    
}




-(void)loadCategoryData:(NSString*)jsonPath
{
    //NSLog(@"loadCategoryData");
    
    NSURL *dataURL = [NSURL URLWithString:[API_URL stringByAppendingString:[jsonPath stringByAppendingString: @".json"]]];
   // NSLog(@"dataURL %@",dataURL);
    
    NSError *errorLoad = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:dataURL options:NSDataReadingUncached error:&errorLoad];
    
    if (errorLoad) {
        NSLog(@"%@", [errorLoad localizedDescription]);
    } else {
        //NSLog(@"Data has loaded successfully.");
        
        
        NSError *errorParse = nil;
        NSDictionary *dataDictionary = [NSJSONSerialization
                                        JSONObjectWithData:jsonData options:0 error:&errorParse];
        
        if (errorParse) {
            NSLog(@"%@", [errorParse localizedDescription]);
            
            [self loadErrorMessage];

        } else {
            
            [self setNavItemsEnabled:YES];

            // NSLog(@"Data has parsed successfully %@",dataDictionary);

            /* index model
             data
                 version
                 asset_url
                 category
                     id
                     name
                     path
                     path_id
                     cover1x
                     cover2x
                     cover3x
                     colour
                     background
                     description
                     target
                     bytes
                         items
                             item {id}
                                 id
                                 title
                                 path
                                 path_id
                                 cover1x
                                 cover2x
                                 cover3x
                                 video
                                 description
                                 price
                                 target
                                 tags
                                     items
                                         item {id}
                                             id
                                             name
                                     total
                        total
                     children
                         items
                             item {id}
                                 id
                                 name
                                 path
                                 path_id
                                 cover1x
                                 cover2x
                                 cover3x
                                 colour
                                 background
                                 description
                                 target
                                 bytes
                                     items
                                         item {id}
                                             id
                                             title
                                             path
                                             path_id
                                             cover1x
                                             cover2x
                                             cover3x
                                             video
                                             description
                                             price
                                             target
                                             tags
                                                 items
                                                     item {id}
                                                         id
                                                         name
                                                 total
                                    total
                         total
             */
            
            NSDictionary *data = [dataDictionary objectForKey:@"data"];
            
            self.tableData = [[NSMutableArray alloc] init];
            
            if(data)
            {
               // NSLog(@"data ok");
                
                
                NSDictionary *category = [data objectForKey:@"category"];
                NSDictionary *children = [category objectForKey:@"children"];
                NSNumber *children_total = [children objectForKey:@"total"];
                
                
                if(category)
                {
                    //self.featuredModelArray = [[NSMutableArray alloc] init];

                    // NSLog(@"carousel_list ok");
                    
                    // header item
                    NSMutableDictionary *header_item = [[NSMutableDictionary alloc] init];
                    [header_item setObject:[category objectForKey:@"cover1x"] forKey:@"cover1x"];
                    [header_item setObject:[category objectForKey:@"cover2x"] forKey:@"cover2x"];
                    [header_item setObject:[category objectForKey:@"cover3x"] forKey:@"cover3x"];
                    [header_item setObject:[category objectForKey:@"colour"] forKey:@"colour"];
                    [header_item setObject:[category objectForKey:@"background"] forKey:@"background"];
                    [header_item setObject:@"header" forKey:@"type"];

                   
                    
                    NSMutableDictionary *category_item = [[NSMutableDictionary alloc] init];
                    [category_item setObject:[category objectForKey:@"id"] forKey:@"id"];
                    [category_item setObject:[category objectForKey:@"name"] forKey:@"name"];
                    [category_item setObject:[category objectForKey:@"path"] forKey:@"path"];
                    [category_item setObject:[category objectForKey:@"path_id"] forKey:@"path_id"];
                    [category_item setObject:[category objectForKey:@"cover1x"] forKey:@"cover1x"];
                    [category_item setObject:[category objectForKey:@"cover2x"] forKey:@"cover2x"];
                    [category_item setObject:[category objectForKey:@"cover3x"] forKey:@"cover3x"];
                    [category_item setObject:[category objectForKey:@"colour"] forKey:@"colour"];
                    [category_item setObject:[category objectForKey:@"background"] forKey:@"background"];
                    [category_item setObject:[category objectForKey:@"description"] forKey:@"description"];
                    [category_item setObject:[category objectForKey:@"target"] forKey:@"target"];
                    [category_item setObject:[category objectForKey:@"bytes"] forKey:@"bytes"];
                    
                                        /*
                    NSDictionary *category_item = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [category objectForKey:@"id"], @"id",
                                                      [category objectForKey:@"name"], @"name",
                                                      [category objectForKey:@"description"], @"description",
                                                      [category objectForKey:@"target"], @"target",
                                                        [category objectForKey:@"bytes"], @"bytes",
                                                      nil];
                    */
                    
                    NSDictionary *category_main_bytes = [category objectForKey:@"bytes"];
                    NSNumber * category_main_bytes_total = [category_main_bytes objectForKey:@"total"];
                    
                    
                    
                    if([category_main_bytes_total intValue] > 0)
                    {
                        //[self.featuredModelArray addObject:category_item];

                        [self.tableData addObject:
                         [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:2],
                          category_item,
                          nil]];

                    }

                    
                    if(children_total)
                    {
                        //  NSLog(@"carousel_list_total ok");
                        
                        if([children_total intValue] > 0)
                        {
                            
                            NSDictionary *children_list_items = [children objectForKey:@"items"];
                            
                            //NSLog(@"children_list_items %@ ",children_list_items);
                            
                            if(children_list_items)
                            {
                                //   NSLog(@"carousel_list_items ok");
                                
                                NSString *cover = [header_item objectForKey:COVER_SIZE];
                                if(cover)
                                {
                                    if(![cover isEqualToString:@""] && ![cover isEqualToString:@"<null>"])                                        [self.tableData insertObject:[NSArray arrayWithObjects:
                                                                      [NSNumber numberWithInt:5],
                                                                      header_item,
                                                                      nil] atIndex:0];

                                }

                                

                                
                                //for (NSDictionary *item in carousel_list_items)
                                for (int i=1; i <= [children_total intValue]; i++)
                                {
                                    NSString *item = [NSString stringWithFormat:@"%d",i];
                                    
                                    NSDictionary *child_item = [children_list_items objectForKey:item];
                                    
                                    
                                    //[self.featuredModelArray addObject:child_item];
                                    [self.tableData addObject:
                                     [NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:2],
                                      child_item,
                                      nil]];
                                    
                                }
                                
                            }
                            else
                            {
                                //NSLog(@"no children_list_items");
                                
                                NSString *cover = [header_item objectForKey:COVER_SIZE];
                                if(cover)
                                {
                                     if(![cover isEqualToString:@""] && ![cover isEqualToString:@"<null>"])
                                        [category_item setObject:header_item forKey:@"header"];
                                }

                            }
                        }
                        else
                        {
                            //NSLog(@"children_total = 0");

                            NSString *cover = [header_item objectForKey:COVER_SIZE];
                            if(cover)
                            {
                                 if(![cover isEqualToString:@""] && ![cover isEqualToString:@"<null>"]) 
                                    [category_item setObject:header_item forKey:@"header"];
                            }
                            
                          
                            // force update title
                            //NSLog(@" name %@", [category objectForKey:@"name"]);
                            
                            [self updateTitleWithString:[category objectForKey:@"name"]];
                            

                        }
                    }
                    else
                    {
                       // NSLog(@"no children_total");
                        
                        // force update title
                        //NSLog(@" name %@", [category objectForKey:@"name"]);
                        
                        [self updateTitleWithString:[category objectForKey:@"name"]];
                        
                    }
                }
                else
                {
                    //NSLog(@"no category");
                }
            }
            else
            {
                //NSLog(@"no data");
            }
            
            /*
            
            if (self.featuredModelArray)
                for(NSDictionary *i in self.featuredModelArray)
                    [self.tableData addObject:
                     [NSArray arrayWithObjects:
                      [NSNumber numberWithInt:2],
                      i,
                      nil]];
             */
            
            
            
            [self updateTable];
            //NSLog(@" tableData %@", self.tableData);
            
        }
    }
    
    
}


-(void)loadIndexData
{
   // NSLog(@"loadData ");
    
    NSURL *indexDataURL = [NSURL URLWithString:[API_URL stringByAppendingString:@"index.json"]];
   // NSLog(@"indexDataURL %@",indexDataURL);
    
    NSError *errorLoad = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:indexDataURL options:NSDataReadingUncached error:&errorLoad];
    
    if (errorLoad) {
        NSLog(@"%@", [errorLoad localizedDescription]);
        
        [self loadErrorMessage];
        
    } else {
        //NSLog(@"Data has loaded successfully.");
        
        [self setNavItemsEnabled:YES];

        NSError *errorParse = nil;
        NSDictionary *dataDictionary = [NSJSONSerialization
                                        JSONObjectWithData:jsonData options:0 error:&errorParse];
        
        if (errorParse) {
            NSLog(@"%@", [errorParse localizedDescription]);
        } else {
            // NSLog(@"Data has parsed successfully %@",dataDictionary);
            
            
            
            // load carousel
            // load featured
            
            /* index model
             data
                 version
                 asset_url
                 carousel
                    items
                        item {id}
                            id
                            name
                            description
                            cover1x
                            cover2x
                            cover3x
                            target
                    total
                 featured
                    items
                        item {id}
                            id
                            name
                            description
                            target
                            bytes
                                items
                                    item {id}
                                        id
                                        title
                                        cover1x
                                        cover2x
                                        cover3x
                                        video
                                        description
                                        price
                                        target
                                        tags
                                            items
                                                item {id}
                                                    id
                                                    name
                                            total
                                total
                    total
             */
            
            NSDictionary *data = [dataDictionary objectForKey:@"data"];
           
            self.tableData = [[NSMutableArray alloc] init];
            
            if(data)
            {
               // NSLog(@"data ok");
                
                NSDictionary *carousel_list = [data objectForKey:@"carousel"];
                NSNumber *carousel_list_total = [carousel_list objectForKey:@"total"];
               
                if(carousel_list)
                {
                    // NSLog(@"carousel_list ok");
                    
                    if(carousel_list_total)
                    {
                        //  NSLog(@"carousel_list_total ok");
                        
                        if([carousel_list_total intValue] > 0)
                        {
                            self.carouselModelArray = [[NSMutableArray alloc] init];
                            
                            NSDictionary *carousel_list_items = [carousel_list objectForKey:@"items"];
                            
                            //NSLog(@"carousel_list_items %@ ",carousel_list_items);

                            if(carousel_list_items)
                            {
                                //   NSLog(@"carousel_list_items ok");
                                
                                //for (NSDictionary *item in carousel_list_items)
                                for (int i=1; i <= [carousel_list_total intValue]; i++)
                                {
                                    NSString *item = [NSString stringWithFormat:@"%d",i];
                                    
                                    NSDictionary *carousel_item = [carousel_list_items objectForKey:item];
                                    
                                    //NSLog(@"carousel_item %@", carousel_item);
                                    
                                    [self.carouselModelArray addObject:carousel_item];
                                    
                                }
                                
                            }
                            else
                            {
                              //  NSLog(@"no carousel_list_items");
                            }
                        }
                        else
                        {
                          //  NSLog(@"carousel_list_total = 0");
                        }
                    }
                    else
                    {
                       // NSLog(@"no carousel_list_total");
                    }
                }
                else
                {
                    //NSLog(@"no carousel_list");
                }
                
                
                NSDictionary *featured_list = [data objectForKey:@"featured"];
                NSNumber *featured_list_total = [featured_list objectForKey:@"total"];
                
                
                if(featured_list)
                {
                    // NSLog(@"featured_list ok");
                    
                    if(featured_list_total)
                    {
                        //  NSLog(@"featured_list_total ok");
                        
                        if([featured_list_total intValue] > 0)
                        {
                            self.featuredModelArray = [[NSMutableArray alloc] init];
                            
                            // NSLog(@"featured_list_total > 0");
                            NSDictionary *featured_list_items = [featured_list objectForKey:@"items"];
                            
                            if(featured_list_items)
                            {
                                //   NSLog(@"featured_list_items ok");
                                
                                //for (NSDictionary *item in featured_list_items)
                                for (int i=1; i <= [featured_list_total intValue]; i++)
                                {
                                    NSString *item = [NSString stringWithFormat:@"%d",i];
                                    
                                    NSDictionary *featured_item = [featured_list_items objectForKey:item];
                                    
                                    //NSLog(@"featured_item %@", featured_item);
                                    
                                    [self.featuredModelArray addObject:featured_item];
                                    
                                }
                                
                            }
                            else
                            {
                                //NSLog(@"no featured_list_items");
                            }
                        }
                        else
                        {
                           // NSLog(@"featured_list_total = 0");
                        }
                    }
                    else
                    {
                       // NSLog(@"no featured_list_total");
                    }
                }
                else
                {
                    //NSLog(@"no featured_list");
                }
            }
            else
            {
               // NSLog(@"no data");
            }
            
            
            /*
            [self.expandTableView setDataSourceDelegate:self];
            [self.expandTableView setTableViewDelegate:self];
             */
            
            
            
            //NSLog(@" carouselModelArray %@", self.carouselModelArray);
            //NSLog(@" featuredModelArray %@", self.featuredModelArray);
            
            if(self.carouselModelArray)
                [self.tableData addObject:
                 [NSArray arrayWithObjects:
                  [NSNumber numberWithInt:1],
                  self.carouselModelArray,
                   nil]];
            
            if (self.featuredModelArray)
                for(NSDictionary *i in self.featuredModelArray)
                    [self.tableData addObject:
                     [NSArray arrayWithObjects:
                      [NSNumber numberWithInt:2],
                      i,
                      nil]];
            
            
            
            // footer

            [self.tableData addObject:
             [NSArray arrayWithObjects:
              [NSNumber numberWithInt:3],
              [self getFooterData],
              nil]];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFooterData:) name:@"updateFooterData" object:nil];

            


            [self updateTable];
            
            if(self.hasSplash)
            {
                self.hasSplash = NO;
                [self.splashView startAnimation];
            }

            //NSLog(@" tableData %@", self.tableData);
            
          

        }
    }
    
    
}

-(NSMutableAttributedString*) getFooterData
{
    int bytesEnabled = [[SettingsManager sharedSettings] getBytesEnabledCount];
    int bytesInstalled = [[SettingsManager sharedSettings] getBytesAddedCount];;
    
    NSString *byteCount = [@"MY BYTES " stringByAppendingString:[NSString stringWithFormat:@"%d/%d ",bytesEnabled, bytesInstalled ]];
    NSMutableAttributedString * footer = [[NSMutableAttributedString alloc] initWithString:byteCount];
    
    [footer addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Quicksand-Bold" size:footerFontSize] range:NSMakeRange(0, (int)byteCount.length)];
    [footer addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Quicksand-Regular" size:footerFontSize] range:NSMakeRange(0, 8)];
    
    return footer;
}

-(void) updateFooterData:(NSNotification *)notis
{
    
    for(UITableViewCell *c in [self.tableView visibleCells])
    {
        if([c isKindOfClass:[FooterContainerCell class]])
        {
            [((FooterContainerCell *)c).label setAttributedText:[self getFooterData]];
        }
    }
    
    for(int i=0; [self.tableData count]; i++)
    {
        if([[[self.tableData objectAtIndex:i] objectAtIndex:0] intValue] == 3)
        {
            // update footer data
            [self.tableData replaceObjectAtIndex:i withObject:[NSArray arrayWithObjects:
                                                  [NSNumber numberWithInt:3],
                                                  [self getFooterData],
                                                  nil]];
            break;
        }
    }
}

- (void)updateTable
{
    
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
}




#pragma mark table


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 1)
    {        
        CarouselContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarouselContainer" forIndexPath:indexPath];
        
        [cell.carouselContentView initCarouselWithArray:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] delegate:self];
        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 2)
    {
        int items = (int) [self.tableData count];
        
        if(items == 1)
        {
            GridContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GridContainer" forIndexPath:indexPath];
            [cell.gridContentView initGridWithDicitionary:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] delegate:self];
                        
            return cell;
        }
        else
        {
            BOOL last = NO;
            if((items-2) == (int)[indexPath row])
                last= YES;
            
            if(!
               self.isHome)
                last = NO;
            
            
            FeaturedContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeaturedContainer" forIndexPath:indexPath];
            
            [cell.featuredContentView initFeaturedWithDicitionary:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] delegate:self last:last];
            
            return cell;
        }
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 3)
    {
        FooterContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FooterContainer" forIndexPath:indexPath];
        cell.delegate = self;
        [cell.label setAttributedText:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1]];
        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 4)
    {
  
        MyBytesContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBytesContainer" forIndexPath:indexPath];
        [cell.myBytesContentView initGridWithDicitionary:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] delegate:self];
        
        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 5)
    {
        HeaderContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderContainer" forIndexPath:indexPath];
        [cell initHeaderWithObject:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1]];
        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 6)
    {
        LegalsContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LegalsContainer" forIndexPath:indexPath];
        [cell setText:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1]];
        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 7)
    {
        TutorialContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TutorialContainer" forIndexPath:indexPath];
        [cell.tutorialContentView initTutorialWithDicitionary:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] delegate:self];
        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 8)
    {
        MessageContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageContainer" forIndexPath:indexPath];
        [cell.label setText:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1]];
        [cell.label sizeToFit];

        
        return cell;
    }


    else
    {
        // TODO ADD OTHER CELL TYPES
        return nil;

    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = headerCelltHeight;
    int type = [[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue];

    //NSLog(@"indexPath %ld",(long)[indexPath row]);
    if([indexPath row] == 0 && [self.tableData count] == 1)
    {

        if(type == 2)
           h = SCREEN_HEIGHT;
        else if(type == 4)
            h = SCREEN_HEIGHT;
        else if(type == 6)
            h = SCREEN_HEIGHT;
        else if(type == 7 || type == 8)
        {
            if(![[SettingsManager sharedSettings] hasTutorialDone])
                h = SCREEN_HEIGHT_FULL;
            else
                h = SCREEN_HEIGHT;
        }

    }
    else if(type == 2)
        h = featuredCellHeight;
    else if(type == 3)
        h = footerCellHeight;
    else if(type == 5)
        h = headerCelltHeight;
    else if(type == 6)
        h = SCREEN_HEIGHT;
    else if(type == 7 || type == 8)
    {
        if(![[SettingsManager sharedSettings] hasTutorialDone])
            h = SCREEN_HEIGHT_FULL;
        else
            h = SCREEN_HEIGHT;
    }

        



    
    //NSLog(@"heightForRowAtIndexPath %f",h);

    return h;
}

- (IBAction)handleSeeAllButtonTouch:(id)sender {
    
   // NSLog(@"handleSeeAllButtonTouch %@",sender);
    
    if(self.lastSeeAllClicked != sender)
    {
        //NSLog(@"requests count %ld", [RequestQueue mainQueue].requestCount);
        
        [[RequestQueue mainQueue] cancelAllRequests];
        
        //NSLog(@"requests count %ld", [RequestQueue mainQueue].requestCount);


        self.lastSeeAllClicked = sender;
        
       // NSString *restorationId = self.restorationIdentifier;
        UIButton *myButton = (UIButton *)sender;
        FeaturedContentView *senderObject = (FeaturedContentView*)myButton.superview;
        
       // NSDictionary *target = [senderObject.featuredData objectForKey:@"target"];

        //NSLog(@"restorationId %@",restorationId);
        
        /*
        if([restorationId isEqualToString:@"HomePrimary"])
            [self performSegueWithIdentifier:@"ShowAllPrimary" sender:senderObject.featuredData];
        else if([restorationId isEqualToString:@"HomeSecondary"])
            [self performSegueWithIdentifier:@"ShowAllSecondary" sender:senderObject.featuredData];
         */
        
        [self performSegueWithIdentifier:@"ShowAll" sender:senderObject.featuredData];
    }

    
}


- (void)handleBackButtonTouch {
    
    NSString *target = [self.categoryData objectForKey:@"target"];

    if(self.categoryData == nil || [target isEqualToString:@"home"])
    {
       // NSLog(@"Force Refresh ");
        [self initPage];
        
    }
    else
    {
        if([self.navigationController popViewControllerAnimated:YES])
        {
           // NSLog(@"Went back ok to last view");
            
            
            
        }else
        {
            /*
            NSString *restorationId = self.restorationIdentifier;
            
            if([restorationId isEqualToString:@"HomePrimary"])
                [self performSegueWithIdentifier:@"GoBackPrimary" sender:nil];
            else if([restorationId isEqualToString:@"HomeSecondary"])
                [self performSegueWithIdentifier:@"GoBackSecondary" sender:nil];
             
             */
            
            [self performSegueWithIdentifier:@"ShowAll" sender:nil];

            
        }
    }
}

- (void)handleSearchButtonTouch {
    
   // NSLog(@"handleSearchButtonTouch");
    [self performSegueWithIdentifier:@"ShowSearch" sender:nil];

}

-(void) showMyBytes
{
   // NSLog(@"ShowMyBytes %@", sender);
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"-2", @"id",
                                                [@"My Bytes" uppercaseString], @"name",
                                                @"mybytes", @"target",
                                                nil];

   // NSLog(@"ShowMyBytes data %@", data);
    
    /*
    NSString *restorationId = self.restorationIdentifier;
    
    if([restorationId isEqualToString:@"HomePrimary"])
        [self performSegueWithIdentifier:@"ShowAllPrimary" sender:data];
    else if([restorationId isEqualToString:@"HomeSecondary"])
        [self performSegueWithIdentifier:@"ShowAllSecondary" sender:data];}
     */
    
    [self performSegueWithIdentifier:@"ShowAll" sender:data];

    
}

-(void) showHome
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"0", @"id",
                          [@"Home" uppercaseString], @"name",
                          @"home", @"target",
                          nil];
    [self performSegueWithIdentifier:@"ShowAll" sender:data];
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
     //NSLog(@"prepareForSegue %@ %@", segue, sender);
    
    // configure the destination view controller:
    
    
    
    if([segue.identifier isEqualToString:@"ShowSearch"])
    {
    }
    else if([segue.identifier isEqualToString:@"ShowByte"])
    {
        //NSLog(@"pause carousel");

        [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseCarousel" object:nil userInfo:nil];
        
        UINavigationController *navController = segue.destinationViewController;
        ByteViewController *byteController = [navController childViewControllers].firstObject;

        if([sender isKindOfClass:[FeaturedContentView class]])
        {
            FeaturedContentView *content = (FeaturedContentView*) sender;
            byteController.byteData = [content.bytesData objectAtIndex:content.selected];
            byteController.bytesData = content.bytesData;
            byteController.selected = content.selected;

        }
        else if([sender isKindOfClass:[GridContentView class]])
        {
            GridContentView *content = (GridContentView*) sender;
            byteController.byteData = [content.bytesData objectAtIndex:content.selected];
            byteController.bytesData = content.bytesData;
            byteController.selected = content.selected;
        }
        else
        {
            byteController.byteData = sender;
        }

    }
    else
    {
        ContentViewController *contentController = segue.destinationViewController;
        contentController.categoryData = sender;
        [contentController initPage];

    }



    
}


#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);

    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
   // NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
   // NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
