//
//  TutorialPageViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 28/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "TutorialPageViewController.h"
#import "PageContentViewController.h"
#import "Constants.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface TutorialPageViewController ()
@property (nonatomic) NSArray *pagesObjects;

@end

@implementation TutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"container_app"
                                                          action:@"launched"
                                                           label:nil
                                                           value:nil] build]];
    
    
    _pagesObjects = @[
                     @[@"Install the keyboard\n", @"\nSettings > General > Keyboard > Keyboards > Add > Allow Full Access", UIColorFromRGB(0xEC257B), UIColorFromRGB(0xFFFFFF), @"page_1"],
                     @[@"Allow Full Access\n", @"\nPlease allow full access so we can realiably copy sound bytes into your messages", UIColorFromRGB(0xF9EC00),UIColorFromRGB(0xEC257B),@"page_2"],
                     @[@"That's it!\n", @"\nTap or hold the globe icon to change the keyboard\n\nSwipe to view tutorial", UIColorFromRGB(0x83D6B9), UIColorFromRGB(0xFFFFFF), @"page_3"],
                     @[@"Hold a Sound Byte\n", @"\nFor more sharing options", UIColorFromRGB(0xEC257B), UIColorFromRGB(0xFFFFFF), @"page_4"],
                     @[@"Tap to Save\n", @"\nSaved sound bytes can be pasted or inserted directly into your message", UIColorFromRGB(0xF9EC00), UIColorFromRGB(0xEC257B), @"page_5"]
                     ];
    
    self.dataSource = self;
    self.delegate = self;

    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self trackTutorialPageAt:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)i
{
    if (([_pagesObjects count] == 0) || (i >= [_pagesObjects count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.pageIndex = i;
    [pageContentViewController.view setBackgroundColor:_pagesObjects[i][2]];
    [pageContentViewController setTitleLabel:_pagesObjects[i][0] description:_pagesObjects[i][1] colour:_pagesObjects[i][3]];
    return pageContentViewController;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_pagesObjects count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_pagesObjects count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    int i = (int)((PageContentViewController*) pageViewController.viewControllers[0]).pageIndex;
    [self trackTutorialPageAt:i];
   
}

-(void) trackTutorialPageAt:(int) i
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"container_app"
                                                          action:@"tutorial"
                                                           label:_pagesObjects[i][4]
                                                           value:nil] build]];
}

@end
