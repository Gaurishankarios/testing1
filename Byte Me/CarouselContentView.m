//
//  CarouselContentView.m
//  Byte Me
//
//  Created by Leandro Marques on 07/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "CarouselContentView.h"
#import "CarouselCollectionViewCell.h"
#import "Constants.h"
#import "Mixpanel.h"

@interface CarouselContentView ()
@property (nonatomic) NSArray *carouselData;
@property (nonatomic) NSArray *carouselDataOriginal;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL hasCarouselInit;
@property (nonatomic) BOOL hasTimerEnabled;
@property (nonatomic) id delegate;

@end


@implementation CarouselContentView


- (void)awakeFromNib {
    [self setBackgroundColor:carouselBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCarousel:) name:@"showCarousel" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTimer) name:@"pauseCarousel" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTimer) name:@"resumeCarousel" object:nil];



}

-(void) initCarouselWithArray:(NSArray *) array delegate:(id) delegate
{
    self.hasCarouselInit = NO;
    self.delegate = delegate;
    
    self.carouselDataOriginal = [array copy];
    
    [self.carouselCollection setAlpha:0.0f];
            
    // duplicate the last item and put it at first
    // duplicate the first item and put it at last
    id firstItem = [[array firstObject] copy];
    id lastItem = [[array lastObject] copy];
    NSMutableArray *workingArray = [array mutableCopy];
    [workingArray insertObject:lastItem atIndex:0];
    [workingArray addObject:firstItem];
    self.carouselData = [workingArray mutableCopy];

    self.hasTimerEnabled = YES;
    if([workingArray count] <= 3)
    {
        [self.carouselCollection setScrollEnabled:NO];
        self.hasTimerEnabled = NO;
    }
    
    [self.carouselCollection reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.carouselCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        [self trackPageImpression];
        
    });

}


- (void)showCarousel:(NSNotification *)notis
{
    
    if(!self.hasCarouselInit)
    {
        self.hasCarouselInit = YES;
        
        [UIView animateWithDuration:carouselTransitionTime animations:^{
            
            [self.carouselCollection setAlpha:1.0f];
            
        } completion:^(BOOL finished) {
            
            [self addTimer];
            
        }];
    }

}

- (void)addTimer
{
    if(self.timer || (self.hasTimerEnabled == NO))
        return;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:carouselTime target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    
}

- (void)nextPage
{
    NSIndexPath *currentIndexPath = [[self.carouselCollection indexPathsForVisibleItems] lastObject];
    NSInteger nextItem = currentIndexPath.item + 1;
    
    if (nextItem == self.carouselData.count) {
        [self.carouselCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        nextItem = 1;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
    
    [self.carouselCollection scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UICollectionView delegate method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}


#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.carouselData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarouselCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CarouselSlide" forIndexPath:indexPath];
    [cell initCellWithObject:[self.carouselData objectAtIndex:indexPath.row] path:indexPath.row ];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeTimer];
    
    //NSLog(@"didSelectItemAtIndexPath %@", [self.carouselData objectAtIndex:[indexPath row]]);
    
    NSDictionary *data = [self.carouselData objectAtIndex:[indexPath row]];
    NSArray* target = [[data objectForKey:@"target"] componentsSeparatedByString: @"/"];
    NSString* section = [target objectAtIndex: 0];
    
    // tracking
    NSString *name = [data objectForKey:@"name"];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Carousel Slide Clicked" properties:@{
                                                              @"Component": @"Container",
                                                              @"Slide":name
                                                              }];
    
    if([section isEqualToString:@"byte"])
    {
        [self.delegate performSegueWithIdentifier:@"ShowByte" sender: [self.carouselData objectAtIndex:[indexPath row]]];
    }
    else
    {
        [self.delegate performSegueWithIdentifier:@"ShowAll" sender:[self.carouselData objectAtIndex:[indexPath row]]];

        /*
        NSString *restorationId = ((UIViewController*) self.delegate).restorationIdentifier;
        
        if([restorationId isEqualToString:@"HomePrimary"])
            [self.delegate performSegueWithIdentifier:@"ShowAllPrimary" sender:[self.carouselData objectAtIndex:[indexPath row]]];
        else if([restorationId isEqualToString:@"HomeSecondary"])
            [self.delegate performSegueWithIdentifier:@"ShowAllSecondary" sender:[self.carouselData objectAtIndex:[indexPath row]]];
         */
    }
    
   // NSLog(@"didSelectItemAtIndexPath %@", section);


}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
      // NSLog(@"didDeselectItemAtIndexPath");
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionView.frame = CGRectMake( self.frame.origin.x,  self.frame.origin.y, SCREEN_WIDTH, headerCelltHeight);
    return CGSizeMake(SCREEN_WIDTH, headerCelltHeight);
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGFloat lastContentOffsetX = FLT_MIN;
    
    //NSLog(@"scrollViewDidScroll");
    
    // We can ignore the first time scroll,
    // because it is caused by the call scrollToItemAtIndexPath: in ViewWillAppear
    if (FLT_MIN == lastContentOffsetX) {
        lastContentOffsetX = scrollView.contentOffset.x;
        return;
    }
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    CGFloat pageWidth = SCREEN_WIDTH;
    CGFloat offset = pageWidth * (self.carouselData.count - 2);
    
    // the first page(showing the last item) is visible and user's finger is still scrolling to the right
    if (currentOffsetX < pageWidth && lastContentOffsetX > currentOffsetX) {
        lastContentOffsetX = currentOffsetX + offset;
        scrollView.contentOffset = (CGPoint){lastContentOffsetX, currentOffsetY};
    }
    // the last page (showing the first item) is visible and the user's finger is still scrolling to the left
    else if (currentOffsetX > offset && lastContentOffsetX < currentOffsetX) {
        lastContentOffsetX = currentOffsetX - offset;
        scrollView.contentOffset = (CGPoint){lastContentOffsetX, currentOffsetY};
    } else {
        lastContentOffsetX = currentOffsetX;
    }
}


-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self trackPageImpression];
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self trackPageImpression];
}


-(void) trackPageImpression
{
    
    CGFloat offx = self.carouselCollection.contentOffset.x;
    CGFloat pageWidth = SCREEN_WIDTH;
    int page = (int)offx/pageWidth;
    NSString *name = [[self.carouselDataOriginal objectAtIndex:page-1] objectForKey:@"name"];
    //NSLog(@"page %d name %@", page, name );
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Carousel Slide Impression" properties:@{
                                                              @"Component": @"Container",
                                                              @"Slide":name
                                                              }];
}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
