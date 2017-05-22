//
//  SearchViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 13/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//



#import "SearchViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "CarouselContainerCell.h"
#import "FeaturedContainerCell.h"
#import "GridContainerCell.h"
#import "CarouselContentView.h"
#import "FeaturedContentView.h"
#import "GridContentView.h"
#import "DecodedString.h"
#import "ByteViewController.h"
#import "SearchSuggestionViewCell.h"
#import "NSString+URLEncoding.h"
#import "Mixpanel.h"

@interface SearchViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic) IBOutlet UIBarButtonItem* homeButtonItem;
@property (nonatomic) IBOutlet UIBarButtonItem* searchButtonItem;
@property (nonatomic,strong) UISearchBar        *searchBar;
@property (nonatomic)        float          searchBarBoundsY;
@property (nonatomic) BOOL showTip;
@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.showTip)
    {
        [self addSearchBar];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[SettingsManager sharedSettings] loadTags];
            
        });
    }

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.showTip)
    {
        if(![self.searchPath isEqualToString:@""])
        {
           // NSLog(@"searchPath %@", self.searchPath);
            [self.searchBar setText: self.searchPath];

        }
        
        [self customSetup];
    }
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Page Visited" properties:@{
                                                 @"Component": @"Container",
                                                 @"Page":@"Search"
                                                 }];

    
}

-(void) viewDidAppear:(BOOL)animated
{
   // NSLog(@"viewDidAppear");

    [super viewDidAppear:animated];
    if(!self.showTip)
    {
        if(![self.searchBar.text isEqualToString:@""])
            [self loadSearchResults:self.searchBar.text];
        
        else
        {
            [self.searchBar becomeFirstResponder];
            [self showPreviousSearches];
        }
    }
    else
    {
        [self.searchBar becomeFirstResponder];
        self.showTip = NO;
    }
}

-(NSString *) encodeSearchString:(NSString *) s
{
    return [s urlEncodeUsingEncoding:NSUTF8StringEncoding];
   /*return  [s stringByAddingPercentEscapesUsingEncoding:
             NSUTF8StringEncoding];
    */
}

- (void)customSetup
{
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        self.revealViewController.rightViewRevealOverdraw = 0.0f;
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    [self.homeButtonItem setTarget: self];
    [self.homeButtonItem setAction: @selector( handleBackButtonTouch )];
    
    [self.searchButtonItem setTarget: self];
    [self.searchButtonItem setAction: @selector( handleSearchButtonTouch )];
    
    
    
}


-(void)loadSearchResults:(NSString*)searchText
{
   // NSLog(@"loadSearchResults searchText %@",searchText);
    
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Searched For" properties:@{
                                                 @"Component": @"Container",
                                                 @"Search Term":searchText
                                                 }];

    
    
  
    NSString *saerchNoSpaces = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *searchTextencoded  = [NSString stringWithString:saerchNoSpaces];
    
    if((int)[searchText length] > 1)
    {
        // add * and ||
        searchTextencoded = [NSString stringWithFormat:@"%@||%@*", saerchNoSpaces, saerchNoSpaces];
    }

    searchTextencoded = [self encodeSearchString:searchTextencoded];
    
    NSString *searchOptions = @"&q.parser=simple&q.options={\"defaultOperator\":\"or\",\"operators\":[\"and\",\"escape\",\"fuzzy\",\"near\",\"not\",\"or\",\"phrase\",\"precedence\",\"prefix\",\"whitespace\"]}&return=_all_fields,_score&highlight.description={\"max_phrases\":3,\"format\":\"text\",\"pre_tag\":\"*#*\",\"post_tag\":\"*%*\"}&highlight.tags={\"max_phrases\":3,\"format\":\"text\",\"pre_tag\":\"*#*\",\"post_tag\":\"*%*\"}&highlight.title={\"max_phrases\":3,\"format\":\"text\",\"pre_tag\":\"*#*\",\"post_tag\":\"*%*\"}&sort=_score desc";
    
    searchOptions = [self encodeSearchString:searchOptions];

    searchTextencoded = [NSString stringWithFormat:@"%@%@", searchTextencoded, searchOptions];
    

    NSURL *dataURL = [NSURL URLWithString:[SEARCH_URL stringByAppendingString:[@"2013-01-01/search?q=" stringByAppendingString: searchTextencoded]]];
    //NSLog(@"dataURL %@",dataURL);
    
    NSError *errorLoad = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:dataURL options:NSDataReadingUncached error:&errorLoad];
    self.tableData = [[NSMutableArray alloc] init];
    NSMutableDictionary *category_item = nil;

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
            
            /* index model
             JSON
             status
                rid
                time-ms
             hits
                found
                start
                hit
                    {no}
                        id
                            fields
                                title
                                cover1x
                                cover2x
                                cover3x
                                video
                                description
                                price
                                target
                                tags
                                    tag
                          */
            
            NSDictionary *hits = [dataDictionary objectForKey:@"hits"];

            if(hits)
            {
                //NSLog(@"hits ok");
                
                NSNumber *hits_total = [hits objectForKey:@"found"];
                NSDictionary *hit_items = [hits objectForKey:@"hit"];

                
                if((int)[hits_total intValue] > 0)
                {
                    category_item = [[NSMutableDictionary alloc] init];

                    //NSLog(@"hits_total >0  ok");
                    
                    // save search term
                    
                    [[SettingsManager sharedSettings] addSearchTerm:searchText];
                    
                    
                    [category_item setValue:@"0" forKey:@"id"];
                    [category_item setValue:@"results" forKey:@"name"];
                    [category_item setValue:@"search results" forKey:@"description"];
                    [category_item setValue:@"search" forKey:@"target"];

                    NSMutableDictionary *hit_bytes = [[NSMutableDictionary alloc] init];
                    NSMutableDictionary *hit_bytes_items = [[NSMutableDictionary alloc] init];
                    
                    [hit_bytes setValue:hits_total forKey:@"total"];

                    
                   int b = 1;
                   for(NSDictionary *hit in hit_items)
                   {
                       
                       NSDictionary *hit_fields = [hit objectForKey:@"fields"];
                       
                       NSMutableDictionary *byte_item = [[NSMutableDictionary alloc] init];
                       [byte_item setValue:[hit objectForKey:@"id"] forKey:@"id"];
                       [byte_item setValue:[hit_fields objectForKey:@"title"] forKey:@"title"];
                       [byte_item setValue:[hit_fields objectForKey:@"description"] forKey:@"description"];
                       [byte_item setValue:[@"byte/" stringByAppendingString:[hit objectForKey:@"id"]] forKey:@"target"];
                       [byte_item setValue:[hit_fields objectForKey:@"cover1x"] forKey:@"cover1x"];
                       [byte_item setValue:[hit_fields objectForKey:@"cover2x"] forKey:@"cover2x"];
                       [byte_item setValue:[hit_fields objectForKey:@"cover3x"] forKey:@"cover3x"];
                       [byte_item setValue:[hit_fields objectForKey:@"video"] forKey:@"video"];
                       [byte_item setValue:[hit_fields objectForKey:@"price"] forKey:@"price"];
                       
                       
                       NSDictionary *hit_tags = [hit_fields objectForKey:@"tags"];
                       NSString *hit_tags_total = [NSString stringWithFormat:@"%d",(int)[hit_tags count]];
                       NSMutableDictionary *hit_tags_items = [[NSMutableDictionary alloc] init];
                       
                       if((int)[hit_tags count] > 0)
                       {
                           int c = 1;
                           for(NSString *t in hit_tags)
                           {
                           [hit_tags_items setValue:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%d",c], @"id",
                             t , @"name",
                             nil]
                             forKey:[NSString stringWithFormat:@"%d",c]];
                               c++;
                           }
                       }
                       
                       NSDictionary *tag_items = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  hit_tags_items, @"items",
                                                  hit_tags_total , @"total",
                                                  nil];
                       
                       [byte_item setValue:tag_items forKey:@"tags"];
                       [hit_bytes_items setValue:byte_item forKey:[NSString stringWithFormat:@"%d",b]];
                       
                        b ++;
                   }
                    
                    [hit_bytes setValue:hit_bytes_items forKey:@"items"];

                    [category_item setValue:hit_bytes forKey:@"bytes"];
                    
                }
                else
                {
                    NSLog(@"hits_total = 0");
                }
            }
            else
            {
                NSLog(@"no hits");
            }
            
            
        }
        
        if (category_item)
        {
            [self.searchBar resignFirstResponder];

            [self.tableData addObject:
             [NSArray arrayWithObjects:
              [NSNumber numberWithInt:2],
              category_item,
              nil]];
            
            [self.tableView reloadData];
        }
        else
        {
            [self showNoResultsWithPreviousSearchesForSearchText:searchText];
        }
        
       // NSLog(@" tableData %@", self.tableData);

    }
}



-(void)loadSearchSuggestion:(NSString*)searchText suggester:(NSString*)suggester
{
   // NSLog(@"loadSearchSuggestion searchText %@",searchText);
    
    NSString * searchTextEconded = [self encodeSearchString:searchText];
    NSString * suggesterName = [NSString stringWithFormat:@"&suggester=%@", suggester];
    NSString * suggesterPath = [SEARCH_URL stringByAppendingString:[@"2013-01-01/suggest?q=" stringByAppendingString: [searchTextEconded stringByAppendingString:suggesterName]]];


    NSURL *dataURL = [NSURL URLWithString:suggesterPath];
   //NSLog(@"dataURL %@",dataURL);
    
    NSError *errorLoad = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:dataURL options:NSDataReadingUncached error:&errorLoad];
    
    NSMutableArray *suggestionsData = [[NSMutableArray alloc] init];
    //self.tableData = [[NSMutableArray alloc] init];

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
            
            /* index model
             JSON
             status
                rid
                time-ms
             suggest
                query
                found
                suggestions
                    {no}
                        id
                        suggestion
                        score
            */
            
            NSDictionary *hits = [dataDictionary objectForKey:@"suggest"];
            
            if(hits)
            {
                //NSLog(@"hits ok");
                
                NSNumber *hits_total = [hits objectForKey:@"found"];
                NSDictionary *hit_items = [hits objectForKey:@"suggestions"];
                
                
                if((int)[hits_total intValue] > 0)
                {
                    for(NSDictionary *hit in hit_items)
                    {
                        NSString *suggestion_item = [hit objectForKey:@"suggestion"];
                        [suggestionsData addObject:suggestion_item];
                    }
                }
                else
                {
                  //  NSLog(@"hits_total = 0");
                }
            }
            else
            {
              //  NSLog(@"no hits");
            }
            
            
        }
        
        [self formatSuggestionsForSearchText:searchText loadedSuggestions:suggestionsData];
    }
    
}

-(void) formatSuggestionsForSearchText:(NSString*)searchText loadedSuggestions:(NSMutableArray *) loadedSuggestions
{
    
    NSPredicate *resultPredicate;
    
    if((int)[searchText length] > 1)
        resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    else
        resultPredicate = [NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", searchText];

    
    self.tableData = [[NSMutableArray alloc] init];
    
    NSMutableArray *temp  = [[[[SettingsManager sharedSettings] loadTags] filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    
    if((int)[loadedSuggestions count] >0)
    {
        for(int i=0; i <[loadedSuggestions count]; i++)
        {
            [temp insertObject:[loadedSuggestions objectAtIndex:i] atIndex:i];
        }
    }
    
    
    if((int)[temp count] >0)
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:3],
          [NSString stringWithFormat: @"Suggestions for \"%@\"", searchText],
          nil]];
    else
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:3],
          [NSString stringWithFormat: @"No Suggestions for \"%@\"", searchText],
          nil]];
    
    for(NSString *s in temp)
    {
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:1],
          s,
          nil]];
    }
    
    
    [self.tableView reloadData];
}


-(void) formatPreviousSearchesForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate    = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    self.tableData = [[NSMutableArray alloc] init];
    
    NSMutableArray *temp  = [[[[SettingsManager sharedSettings] savedSearches] filteredArrayUsingPredicate:resultPredicate] mutableCopy];
   
    
    if((int)[temp count] >0)
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:3],
          [NSString stringWithFormat: @"Suggestions for \"%@\"", searchText],
          nil]];
    else
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:3],
          [NSString stringWithFormat: @"No Suggestions for \"%@\"", searchText],
          nil]];
    
    for(NSString *s in temp)
    {
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:1],
          s,
          nil]];
    }
    
    
    [self.tableView reloadData];
}



-(void) showPreviousSearches
{
    self.tableData = [[NSMutableArray alloc] init];
    NSMutableArray *temp  = [[[SettingsManager sharedSettings] savedSearches] mutableCopy];

    if((int)[temp count] >0)
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:4],
          @"Previous Searches",
          nil]];
    
    
    for(NSString *s in temp)
    {
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:1],
          s,
          nil]];
    }
    
    
    [self.tableView reloadData];
}

-(void) showNoResultsWithPreviousSearchesForSearchText:(NSString*)searchText
{
   // NSLog(@"showNoResultsWithPreviousSearchesForSearchText searchText %@", searchText);

    self.tableData = [[NSMutableArray alloc] init];
    NSMutableArray *temp  = [[[SettingsManager sharedSettings] savedSearches] mutableCopy];
    
    [self.tableData addObject:
      [NSArray arrayWithObjects:
        [NSNumber numberWithInt:3],
         [NSString stringWithFormat: @"No Results for \"%@\"", searchText],
          nil]];
    
    [self.tableData addObject:
     [NSArray arrayWithObjects:
      [NSNumber numberWithInt:5],
      @"Can't find what you're looking for?",
      nil]];

    
    [self.tableData addObject:
     [NSArray arrayWithObjects:
      [NSNumber numberWithInt:4],
      @"Previous Searches",
      nil]];

    
    
    for(NSString *s in temp)
    {
        [self.tableData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:1],
          s,
          nil]];
    }
    
    [self.tableView reloadData];
}


#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    //[self formatSuggestionsForSearchText:searchText];
    
    
    [self loadSearchSuggestion:searchText suggester:@"title"];
    //[self formatPreviousSearchesForSearchText:searchText];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0) {
        // search and reload data source
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchBar
                                                         selectedScopeButtonIndex]]];
        //[self.collectionView reloadData];
        
        
        
        
    }else{
        // if text lenght == 0
        // we will consider the searchbar is not active
        self.tableData = nil;
        [self showPreviousSearches];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearching];
    //[self.collectionView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //[self.view endEditing:YES];
    //NSLog(@"searchBarTextDidEndEditing");
    
    //NSLog(@"searchBarSearchButtonClicked");
    NSString *searchText = [NSString stringWithString:self.searchBar.text];
    
    if(![searchText isEqualToString:@""])
    {
        [self loadSearchResults:searchText];
    }

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching{
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
    self.tableData = nil;
    //[self.tableView reloadData];
    [self showPreviousSearches];


}
#pragma mark - prepareVC

-(void)addSearchBar{
    
    //NSLog(@"addSearchBar");
    
    if (!self.searchBar) {
        
       // NSLog(@"addSearchBar instance");

        self.searchBarBoundsY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,self.searchBarBoundsY, [UIScreen mainScreen].bounds.size.width, 44)];
        
        self.searchBar.searchBarStyle       = UISearchBarStyleMinimal;
        self.searchBar.tintColor            = linkTintColor;
        self.searchBar.barTintColor         = [UIColor darkGrayColor];
        self.searchBar.delegate             = self;
        self.searchBar.placeholder          = @"Search";

        
        
        //[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:linkTintColor];

        self.navigationItem.titleView = self.searchBar;

        // add KVO observer.. so we will be informed when user scroll colllectionView
        //[self addObservers];
    }
    
    if (![self.searchBar isDescendantOfView:self.view]) {
        //[self.view addSubview:self.searchBar];
    }
}




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

    if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 2)
    {
        GridContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GridContainer" forIndexPath:indexPath];
        [cell.gridContentView initGridWithDicitionary:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] delegate:self];

        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 1)
    {
        SearchSuggestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestionCell" forIndexPath:indexPath];
        //[cell setLabelText: [[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1]];
        [cell setLabelText: [[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] icon:@"key_search"];
        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 3)
    {
        SearchSuggestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestionCell" forIndexPath:indexPath];
        [cell setHeaderLabelText: [[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1]];

        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 4)
    {
        SearchSuggestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestionCell" forIndexPath:indexPath];
        [cell setHeaderLabelText: [[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] icon:@"key_close"];
        
        
        return cell;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 5)
    {
        SearchSuggestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestionCell" forIndexPath:indexPath];
        [cell setTipLabelText:[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1] actionText:@"Send Us Content Suggestions" icon:@"key_add"];
        
        
        return cell;
    }
    else
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 1)
    {
        //return cell;
        //NSLog(@" search for %@",);
        NSString *search = [[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:1];
        [self.searchBar resignFirstResponder];
        self.searchBar.text = search;
        self.tableData = nil;
        [self loadSearchResults:search];
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 4)
    {
        [[SettingsManager sharedSettings] clearSavedSearches];
        self.tableData = nil;
        [self.tableView reloadData];
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 5)
    {
        [self showFeedback];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 2)
    {
        return SCREEN_HEIGHT;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 1)
    {
        return searchSuggestionCelltHeight;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 3)
    {
        return searchSuggestionHeaderCelltHeight;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 4)
    {
        return searchSuggestionHeaderCelltHeight;
    }
    else if([[[self.tableData objectAtIndex:[indexPath row]] objectAtIndex:0] intValue] == 5)
    {
        return searchSuggestionTipCelltHeight;
    }
    else
        return SCREEN_HEIGHT;
}

- (void)handleBackButtonTouch
{
    [self.searchBar resignFirstResponder];

    if([self.navigationController popViewControllerAnimated:YES])
    {
        //NSLog(@"Went back ok to last view");
        
    }else
    {
        
        [self performSegueWithIdentifier:@"ShowAll" sender:nil];
    }
}

- (void)handleSearchButtonTouch {
    
    NSLog(@"handleSearchButtonTouch");
    [self performSegueWithIdentifier:@"ShowSearch" sender:nil];
    
}



- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    //NSLog(@"prepareForSegue %@ %@", segue, sender);
    
    // configure the destination view controller:
    if([segue.identifier isEqualToString:@"ShowByte"])
    {
        //NSLog(@"pause carousel");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseCarousel" object:nil userInfo:nil];
        
        UINavigationController *navController = segue.destinationViewController;
        ByteViewController *byteController = [navController childViewControllers].firstObject;
       
        if([sender isKindOfClass:[GridContentView class]])
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


- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    self.showTip = YES;
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}

@end


