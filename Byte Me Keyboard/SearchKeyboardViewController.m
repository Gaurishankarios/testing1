//
//  SearchViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 17/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "SearchKeyboardViewController.h"
//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"
#import "Constants.h"
#import "SearchView.h"
#import "SearchUIView.h"
#import "SettingsManager.h"
#import "SearchSuggesterCollectionViewCell.h"
#import "KeyboardUIView.h"
#import "SearchResultsView.h"
#import "CustomKey.h"
#import "Mixpanel.h"

@import AudioToolbox;

@interface SearchKeyboardViewController ()
@property (strong, nonatomic) IBOutlet SearchView *searchView;
@property (nonatomic) IBOutlet SearchUIView *searchUIView;
@property (nonatomic) IBOutlet KeyboardUIView *keyboardUIView;
@property (nonatomic) IBOutlet SearchResultsView *searchResultsView;
@property (nonatomic) IBOutlet UIView *blurView;

@property (nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) IBOutlet CustomKey *searchButton;
@property (nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) IBOutlet UIButton *searchBarOverlayButton;
@property (nonatomic) IBOutlet UIButton *searchBarClearButton;
@property (strong, nonatomic) IBOutlet UIImageView *searchIcon;
@property (nonatomic) IBOutlet UIView *searchCursor;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cursorConstraintX;

@property (nonatomic) NSMutableArray *suggesterData;
@property (nonatomic) NSMutableArray *suggesterDataSource;
@property (nonatomic) NSMutableDictionary *activeBytesDataSource;

@end


@implementation SearchKeyboardViewController

/*
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [self initSearchBar];

    [self.backButton.layer setBackgroundColor:[mainBkgColor CGColor]];

    [self initBlurView];
    [self fadeView:(UIView*)_visualEffectView toAlpha:0 withSpeed:0];
    
    self.suggesterDataSource = [[SettingsManager sharedSettings] loadActiveTags];
    self.activeBytesDataSource = [[SettingsManager sharedSettings] loadActiveBytes];
    [self.suggesterCollection setBackgroundColor:mainBkgColor];
    
    
    [self.searchButton toggleSearchEnabled:NO];
    
    [self.searchResultsView setHidden:YES];
    //NSLog(@"search");
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Page Visited" properties:@{
                                                 @"Component": @"Keyboard",
                                                 @"Page":@"Search"
                                                 }];

}
     
     

-(void) initSearchBar
{
    
    
    [self.searchIcon setImage:[[UIImage imageNamed:@"key_search"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate ]];
    
    [self.searchIcon setTintColor:mainBkgColor];

    UIImage *imageHighlight = [[UIImage imageNamed:@"key_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchBarClearButton setImage:imageHighlight forState:UIControlStateHighlighted];
    
    UIImage *image = [[UIImage imageNamed:@"key_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchBarClearButton setImage:image forState:UIControlStateNormal];
    [self.searchBarClearButton setTintColor:mainBkgColor];
    [self.searchBarClearButton setHidden:YES];

    
    [self.searchBar setBackgroundImage:[[UIImage alloc] init]];
    [self.searchBar setBackgroundColor:mainBkgColor];
    //[self.searchBar becomeFirstResponder];
    [self.searchBar setUserInteractionEnabled:NO];
    [self.searchBar setPositionAdjustment:UIOffsetMake(-32, 0)forSearchBarIcon:UISearchBarIconSearch];

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    //[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftViewMode:UITextFieldViewModeNever];
    UIImageView *placeholder =[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"key_search"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate ]];
    
    [placeholder setTintColor:clearCcolor];

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftView:placeholder];
    
    [self.searchCursor setBackgroundColor:linkTintColor];
    
    self.cursorConstraintX.constant = self.searchIcon.frame.size.width+6.0f;
    
    [self.searchCursor.layer removeAllAnimations];
    [self.searchCursor setAlpha:0];
    
    [UIView animateWithDuration:keyboardCursorFadeTime delay:0.f options: UIViewAnimationOptionRepeat| UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAutoreverse animations:^{
        
        [self.searchCursor setAlpha:1.0];
        
    } completion:^(BOOL finished) {
        
    }];
    



}

-(void) initBlurView
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _visualEffectView.frame = self.view.bounds;
    [self.blurView addSubview:_visualEffectView];
}


-(void) showBlurEffect:(NSNotification *)notis
{
    [self fadeView:(UIView*)_visualEffectView toAlpha:1.0f withSpeed:fadeSpeed*0.5f];
}

-(void) hideBlurEffect:(NSNotification *)notis
{
    [self fadeView:(UIView*)_visualEffectView toAlpha:0 withSpeed:fadeSpeed*0.5f];
}

- (void)fadeView:(UIView*)view toAlpha:(CGFloat)alpha withSpeed:(CGFloat)speed
{
    [view.layer removeAllAnimations];
    
    view.layer.shouldRasterize = YES;
    [UIView animateWithDuration:speed
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         view.alpha = alpha;
                     }
                     completion:^(BOOL finished){
                         view.layer.shouldRasterize = NO;
                     }];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"viewWillAppear");
    //[self.mainView initScrollOffsets];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSearchBackButton:) name:@"handleSearchBackButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSearchTextUpdate:) name:@"handleSearchTextUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSearchButtonPress:) name:@"handleSearchButtonPress" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlurEffect:) name:@"showBlurEffect" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBlurEffect:) name:@"hideBlurEffect" object:nil];
    
    
    [self resetSuggesterData];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   // NSLog(@"viewDidAppear");
    //[self.mainView initView];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    //NSLog(@"viewWillDisappear");

    [super viewWillDisappear:animated];
    //[self.searchBar resignFirstResponder];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleSearchBackButton:(NSNotification *)notis
{
      //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)handleSearchButtonPress:(NSNotification *)notis
{
    
    //NSLog(@"handleSearchButtonPress");
    //[self.searchBar resignFirstResponder];
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Searched For" properties:@{
                                                 @"Component": @"Keyboard",
                                                 @"Search Term":self.searchBar.text
                                                 }];

    
    [self.searchResultsView updateResultsWithArray:[self formatResultsForSearchText:self.searchBar.text]];
    
    [self.keyboardUIView setHidden:YES];
    [self.searchCursor setHidden:YES];

    [self.searchResultsView initScrollOffsets];
    [self.searchResultsView setHidden:NO];
    [self.searchResultsView initView];
    
    if(![self.searchBar.text isEqualToString:@""])
        [self.searchBarClearButton setHidden:NO];
    else
        [self.searchBarClearButton setHidden:YES];
    
    [self updateCursorPosition];
    
    
   


}

- (void)handleSearchTextUpdate:(NSNotification *)notis
{
   // NSLog(@"handleSearchTextUpdate");
    
    if (self.searchBar.text.length>0) {
        // search and reload data source
         [self filterContentForSearchText:self.searchBar.text
         scope:[[self.searchBar scopeButtonTitles]
         objectAtIndex:[self.searchBar
         selectedScopeButtonIndex]]];
        [self.searchBarClearButton setHidden:NO];

    }else
    {
        [self.searchBarClearButton setHidden:YES];

        [self resetSuggesterData];
    }
    
    //[self.searchBar becomeFirstResponder];
  
    [self updateCursorPosition];
    [self updateSerchButton];
}

-(void) updateCursorPosition
{
    
    UILabel *sizelabel = [[UILabel alloc] init];
    [sizelabel setFont:[UIFont systemFontOfSize:14.0f]];
    [sizelabel setText:self.searchBar.text];
    [sizelabel sizeToFit];
    self.cursorConstraintX.constant = self.searchIcon.frame.size.width+6.0f+sizelabel.frame.size.width;
}


-(NSMutableArray*) formatResultsForSearchText:(NSString*)searchText
{
    
    NSPredicate *resultPredicate;
    resultPredicate = [NSPredicate predicateWithFormat:@"(title contains[cd] %@) OR (description contains[cd] %@) OR (ANY tags.name contains[c] %@)", searchText,searchText,searchText];
  
    NSMutableArray *resultsData = [[NSMutableArray alloc] init];
    NSMutableArray *temp  = [[[self.activeBytesDataSource allValues] filteredArrayUsingPredicate:resultPredicate] mutableCopy];

    for(NSString *s in temp)
    {
        [resultsData addObject:s];
    }
    
   // NSLog(@"resultsData %@",resultsData);
    
    return resultsData;
}



-(void) formatSuggestionsForSearchText:(NSString*)searchText
{
    
    NSPredicate *resultPredicate;
    
    if((int)[searchText length] > 1)
        resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    else
        resultPredicate = [NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", searchText];
    
    self.suggesterData = [[NSMutableArray alloc] init];
    
    NSMutableArray *temp  = [[self.suggesterDataSource filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    
    for(NSString *s in temp)
    {
        [self.suggesterData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:1],
          s,
          nil]];
    }
    
    [self.suggesterCollection reloadData];
}

-(void) resetSuggesterData
{
    self.suggesterData = [[NSMutableArray alloc] init];
    NSMutableArray *temp  = [self.suggesterDataSource mutableCopy];

    for(NSString *s in temp)
    {
        [self.suggesterData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:1],
          s,
          nil]];
    }
    
    
    [self.suggesterCollection reloadData];
}



#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    [self formatSuggestionsForSearchText:searchText];
    //[self formatResultsForSearchText:searchText];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NSLog(@"searchBar");
    [self handleSearchTextUpdate:nil];
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
        // [self loadSearchResults:searchText];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    //[self.searchUIView.searchBar setShowsCancelButton:YES animated:YES];
    //NSLog(@"searchBarTextDidBeginEditing");
    [self.keyboardUIView setHidden:NO];
    [self.searchResultsView setHidden:YES];
    [self.searchCursor setHidden:NO];
    [self updateCursorPosition];


}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //[self.searchUIView.searchBar setShowsCancelButton:NO animated:YES];
    //[self.searchUIView updateSerchButton];
    //NSLog(@"searchBarTextDidEndEditing");
}
-(void)cancelSearching{
    /*
    [self.searchUIView.searchBar resignFirstResponder];
    self.searchUIView.searchBar.text  = @"";
     */
    // self.tableData = nil;
    //  [self showPreviousSearches];
}





#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.suggesterData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchSuggesterCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SearchSuggesterCell" forIndexPath:indexPath];
    [cell setLabelWithString:[[self.suggesterData objectAtIndex:indexPath.row] objectAtIndex:1]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectItemAtIndexPath %@", [self.suggesterData objectAtIndex:[indexPath row]]);
    [self.searchBar setText:[[self.suggesterData objectAtIndex:[indexPath row]] objectAtIndex:1]];
    [self handleSearchButtonPress:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"didDeselectItemAtIndexPath");
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel *sizelabel = [[UILabel alloc] init];
    [sizelabel setFont:[UIFont systemFontOfSize:keyboardSuggesterCellFontSize]];
    [sizelabel setText:[[self.suggesterData objectAtIndex:indexPath.row] objectAtIndex:1]];
    [sizelabel sizeToFit];
    
    CGFloat cellwidth = 16+sizelabel.frame.size.width;
    CGFloat cellHeight = keyboardSuggesterCellHeight;
    
    return CGSizeMake(cellwidth, cellHeight);
}



#pragma mark - KeyboardUIViewDelegate


- (IBAction)handleBackPress:(id)sender
{
   // NSLog(@"handleBackPress ");
    [(UIButton*)sender setHighlighted:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleSearchBackButton" object:nil userInfo:nil];
    AudioServicesPlaySystemSound(1104);
    
    
}

-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressKey:(CustomKey *)key
{
    //NSLog(@"didPressKey %@", [key getKeyStringValue]);
    AudioServicesPlaySystemSound(1104);
    
    NSString *text = [self.searchBar text];
    [self.searchBar setText: [text stringByAppendingString:[key getKeyStringValue]]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleSearchTextUpdate" object:nil userInfo:nil];
    
    //[self updateSerchButton];
    
}


-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressBackspace:(CustomKey *)key
{
    // NSLog(@"didPressBackspace ");
    AudioServicesPlaySystemSound(1104);
    
    NSString *text = [self.searchBar text];
    
    if ([text length] > 0) {
        text = [text substringToIndex:[text length] - 1];
        [self.searchBar setText: text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"handleSearchTextUpdate" object:nil userInfo:nil];
        
        
    } else {
        //no characters to delete... attempting to do so will result in a crash
    }
    
    
    //[self updateSerchButton];
    
    
}

-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressSpace:(CustomKey *)key
{
    //NSLog(@"didPressSpace ");
    AudioServicesPlaySystemSound(1104);
    
    NSString *text = [self.searchBar text];
    [self.searchBar setText: [text stringByAppendingString:@" "]];
    //[self updateSerchButton];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleSearchTextUpdate" object:nil userInfo:nil];
    
}

-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressSearch:(CustomKey *)key
{
    //NSLog(@"didPressSearch ");
    AudioServicesPlaySystemSound(1104);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleSearchButtonPress" object:nil userInfo:nil];
    
    
}


-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressGlobe:(CustomKey *)key
{
    AudioServicesPlaySystemSound(1104);
    
    //NSLog(@"didPressGlobe ");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleChangeKeyboadButton" object:nil userInfo:nil];
}

-(void) updateSerchButton
{
    //NSLog(@"updateSerchButton");
    NSString *text = [self.searchBar text];
    
    if ([text length] > 0)
    {
        // enable button
        [self.searchButton toggleSearchEnabled:YES];
    } else
    {
        // disable button
        [self.searchButton toggleSearchEnabled:NO];
    }
}

- (IBAction)handleSearchBarTouch:(id)sender {
    //NSLog(@"handleSearchBarTouch");
    
    [self.keyboardUIView setHidden:NO];
    [self.searchResultsView setHidden:YES];
    [self.searchCursor setHidden:NO];
    [self updateCursorPosition];


}
- (IBAction)handleSearchBarClearDown:(id)sender {
    
    [self.searchBarClearButton setTintColor:keyboardImageKeyBackgroundColor];

}


- (IBAction)handleSearchBarClear:(id)sender {
    NSLog(@"handleSearchBarClear");
    
    [self.searchBar setText:@""];
    [self.keyboardUIView setHidden:NO];
    [self.searchResultsView setHidden:YES];
    [self.searchBarClearButton setTintColor:mainBkgColor];
    [self handleSearchTextUpdate:nil];
    [self.searchCursor setHidden:NO];
    [self updateCursorPosition];

}


-(void) dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



