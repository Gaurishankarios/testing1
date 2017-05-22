//
//  TutorialContentView.m
//  Byte Me
//
//  Created by Leandro Marques on 04/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "TutorialContentView.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "TutorialCustomiseCollectionViewCell.h"
#import "Mixpanel.h"

@interface TutorialContentView ()
@property (nonatomic) id delegate;

@end


@implementation TutorialContentView


- (void)awakeFromNib {
    [self setBackgroundColor:carouselBackgroundColor];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCarousel:) name:@"showCarousel" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTimer) name:@"pauseCarousel" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTimer) name:@"resumeCarousel" object:nil];
    */
    
    
}

-(void) initTutorialWithDicitionary:(NSDictionary *) data delegate:(id) delegate
{
    self.delegate = delegate;
    
}
/*

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
*/
/*
#pragma mark - UICollectionView delegate method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
*/

#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    /*
    if(![[SettingsManager sharedSettings] hasTutorialDone])
        return 4;
    else
        return 3;
     */
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int row = (int)[indexPath row];

     // tracking
     Mixpanel *mixpanel = [Mixpanel sharedInstance];
     [mixpanel track:@"Page Visited" properties:@{
     @"Component": @"Container",
     @"Page": [NSString stringWithFormat: @"Tutorial Page %d", row+1]
     }];
    
    if(row == 0)
    {
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TutorialAboutSlide" forIndexPath:indexPath];
        return cell;
    }
    else if (row == 1)
    {
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TutorialKeyboardSlide" forIndexPath:indexPath];
        return cell;
    }
    /*
    else if (row == 2)
    {
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TutorialNotificationsSlide" forIndexPath:indexPath];
        return cell;
    }
     */
    else if (row == 2)
    {
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TutorialEndSlide" forIndexPath:indexPath];
        return cell;
    }
    else if (row == 3)
    {
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TutorialCustomiseSlide" forIndexPath:indexPath];
        ((TutorialCustomiseCollectionViewCell*)cell).delegate = self.delegate;
        return cell;
    }
    else
        return nil;
    


}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"didSelectItemAtIndexPath");
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didDeselectItemAtIndexPath");
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = SCREEN_HEIGHT;
    
    if(![[SettingsManager sharedSettings] hasTutorialDone])
        h = SCREEN_HEIGHT_FULL;
   
    return CGSizeMake(SCREEN_WIDTH, h);
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
