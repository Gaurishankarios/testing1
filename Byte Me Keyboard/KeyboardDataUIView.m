//
//  KeyboardDataUIView.m
//  Byte Me
//
//  Created by Leandro Marques on 25/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "KeyboardDataUIView.h"

#import "MainCollectionViewCell.h"
#import "SubCollectionViewCell.h"
#import "ByteCollectionViewCell.h"
#import "CInterpolator.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CCoverflowCollectionViewLayout.h"
#import "CCoverflowVerticalCollectionViewLayout.h"
#import "CCoverflowByteCollectionViewLayout.h"
#import "Constants.h"
#import "ByteUIView.h"
#import "CCARadialGradientLayer.h"
#import "SettingsManager.h"
#import "Mixpanel.h"
/*
 #import "GAI.h"
 #import "GAIDictionaryBuilder.h"
 */

@import AudioToolbox;
@import AssetsLibrary;
@import Photos;

@interface KeyboardDataUIView ()




@end

@implementation KeyboardDataUIView


- (void)awakeFromNib {
    
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:@"savedPlatform"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    
    self.positionoffsetInterpolator = [[CInterpolator interpolatorWithDictionary:@{
                                                                                   @(-0.8f):               @(60.0f)
                                                                                   }] interpolatorWithReflection:YES];
    
    self.isByteUIVisible = false;
    [self fadeView:(UIView*)self.byteUI toAlpha:0 withSpeed:0];
    [self fadeView:(UIView*)self.statusLabel toAlpha:0 withSpeed:0];
    [self fadeView:(UIView*)self.saveButton toAlpha:0 withSpeed:0];
    [self fadeView:(UIView*)self.platformCollectionView toAlpha:0 withSpeed:0];
    [self fadeView:(UIView*)self.closeButton toAlpha:0 withSpeed:0];
    
    [self fadeView:(UIView*)self.icon toAlpha:0 withSpeed:0];
    
    [self.saveButton setHidden:YES];
    
    
    [self initUIButtons];
    
   // self.mainObjects = [[SettingsManager sharedSettings] getBytesEnabledForKeyboard];
    
    //NSLog(@"mainObjects %@",self.mainObjects);
    
    
    
    // bkg
    [self setBackgroundColor:mainBkgColor];
    [self.mainCollectionView setBackgroundColor:[UIColor clearColor]];
    [self updateBackgroundColor:mainBkgColor edge:mainBkgColor];
    
    
    
    // events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleByteUI:) name:@"toggleByteUI" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleByteUIPressBegan:) name:@"toggleByteUIPressBegan" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleByteUIPressEnd:) name:@"toggleByteUIPressEnd" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSaveButtonPress:) name:@"toggleSaveButtonPress" object:nil];
    
    
    
  //  self.mainCollectionView.transform = CGAffineTransformMakeScale(0.975f, 0.975f);
    
    
    /*
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualEffectView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.visualEffectView];
    */
    
    //[self.alphaNumericButton.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Regular" size:keyboardAlphaNumericFontSize]];
    //[self.alphaNumericButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-NRegular" size:keyboardAlphaNumericFontSize]];
    
    self.saveButton.layer.cornerRadius = tileBorderRadiusSmall;
    self.saveButton.layer.masksToBounds = YES;
    
    /*
    
    if(![self testFullAccess])
    {
        NSLog(@"NO FULL ACCESS");
        
        self.isByteUIVisible = YES;
        
        [self.statusLabel setText:@"SETUP INCOMPLETE\nYOU MUST ALLOW FULL ACCESS\nIN THE KEYBOARD SETTINGS"];
        [self fadeView:(UIView*)self.byteUI toAlpha:1.0f withSpeed:fadeSpeed];
        
        [self toggleBlurEffect];
        */
        /*
         id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
         [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"warning_message"
         action:@"setup_incomplete"
         label:@"must_allow_full_access"
         value:nil] build]];
         */
        
        
   // }

    
    
    //[self performSelector:@selector(initScrollOffsets) withObject:self afterDelay:0.1f];
    //[self performSelector:@selector(initView) withObject:self afterDelay:0.2f];
    
}

-(void) updateColourArray
{
    self.colourArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *d in self.mainObjects)
    {
        NSMutableDictionary *colours = [[NSMutableDictionary alloc] init];
    
        [colours setObject:[[SettingsManager sharedSettings] getBackgroundFromObject:d defaultColout:categoryLabelColor] forKey:@"background"];
        [colours setObject:[[SettingsManager sharedSettings] getColourFromObject:d defaultColout:categoryLabelColor] forKey:@"colour"];
        
        [self.colourArray addObject:colours];
    }
    
}

-(void) updateFrequentBytes
{
   // NSLog(@"updateFrequentBytes");
    for(NSMutableDictionary *c in self.mainObjects)
    {
        if([[c objectForKey:@"id"] isEqualToString:@"0"])
        {
            NSMutableArray *children = [[NSMutableArray alloc] init];
            [[SettingsManager sharedSettings] addFrequentBytesWithChildren:children];
            //NSMutableArray *children = [c objectForKey:@"children"];
            [c setObject:children forKey:@"children"];
            return;
        }
    }
    
}

-(void) initUIButtons
{
    UIImage *imageBackButton = [[UIImage imageNamed:@"key_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setImage:imageBackButton forState:UIControlStateNormal];
    [self.backButton setTintColor:globalBackgroundColor];
    
    UIImage *imageBackspaceButton = [[UIImage imageNamed:@"key_backspaceHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backspaceButton setImage:imageBackspaceButton forState:UIControlStateNormal];
    [self.backspaceButton setTintColor:globalBackgroundColor];
    
    UIImage *imageNextButton = [[UIImage imageNamed:@"key_next-keyboardHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.nextKeyboardButton setImage:imageNextButton forState:UIControlStateNormal];
    [self.nextKeyboardButton setTintColor:globalBackgroundColor];
    
    UIImage *imageSearchButton = [[UIImage imageNamed:@"key_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchButton setImage:imageSearchButton forState:UIControlStateNormal];
    [self.searchButton setTintColor:globalBackgroundColor];
    
    [self.alphaNumericButton setTitleColor:globalBackgroundColor forState:UIControlStateNormal];
    [self.alphaNumericButton setTitleColor:keyboardButtonHighlightColor forState:UIControlStateHighlighted];
    
}

-(void) initView
{
    self.isViewLoaded = YES;
    [self fadeView:(UIView*)self.visualEffectView toAlpha:0 withSpeed:0.3f];
    //[self initScrollOffsets];
}

-(void) initScrollOffsets
{
    [self scrollViewDidScroll:self.mainCollectionView];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.mainObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MainCell" forIndexPath:indexPath];
    
    long row = [indexPath row];
    cell.delegate = self;
    cell.parentCollectionView = self.mainCollectionView;
    [cell initCellWithData:self.mainObjects[row]];
    
    return cell;
}



-(void) interpolateFromCenterColor:(UIColor*)f to:(UIColor*)t edgeFrom:(UIColor*)ef  edgeTo:(UIColor*)et progress:(float) p
{
    
    UIColor *center = [self interpolateFromColor:f to:t progress:p];
    UIColor *edge = [self interpolateFromColor:ef to:et progress:p];
    
    [self updateBackgroundColor:center edge:edge];
    [self updateUIButtons:f to:t progress:p];
}

-(void)updateUIButtons:(UIColor*)f to:(UIColor*)t progress:(float) p
{
    UIColor *color = [self interpolateFromColor:f to:t progress:p];
    [self.backButton setTintColor:color];
    [self.backspaceButton setTintColor:color];
    [self.searchButton setTintColor:color];
    [self.nextKeyboardButton setTintColor:color];
    [self.alphaNumericButton setTitleColor:color forState:UIControlStateNormal];
    
}

-(UIColor*) interpolateFromColor:(UIColor*)f to:(UIColor*)t progress:(float) p
{
    
    if(p < 0.0f)
        p = 0.0f;
    
    const CGFloat *components = CGColorGetComponents([f CGColor]);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    const CGFloat *componentsFinal = CGColorGetComponents([t CGColor]);
    CGFloat finalRed = componentsFinal[0];
    CGFloat finalGreen = componentsFinal[1];
    CGFloat finalBlue = componentsFinal[2];
    
    CGFloat newRed   = ((1.0 - p) * red   + p * finalRed);
    CGFloat newGreen = ((1.0 - p) * green + p * finalGreen);
    CGFloat newBlue  = ((1.0 - p) * blue  + p * finalBlue);
    UIColor *color = [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:1.0];
    
    return color;
}




-(void) updateBackgroundColor:(UIColor*) center edge:(UIColor*) edge
{
    //  [_mainCollectionView setBackgroundColor:c];
    [self updateGradientBkgWithView:self.backgroundView centerColor:center edgeColor:edge];
    
}
-(void) updateGradientBkgWithView:(UIView*) view centerColor:(UIColor*)centerColor edgeColor:(UIColor*) edgeColor
{
    CCARadialGradientLayer *radialGradientLayer = [CCARadialGradientLayer layer];
    radialGradientLayer.colors = @[(id)centerColor.CGColor, (id)edgeColor.CGColor];
    [radialGradientLayer setValue:@"1" forKey:@"BkgGradientLayer"];
    radialGradientLayer.locations = @[@0, @1];
    radialGradientLayer.gradientOrigin = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    radialGradientLayer.gradientRadius = view.bounds.size.height*0.5f;
    radialGradientLayer.frame = view.bounds;
    
    CALayer *pGradientLayer = nil;
    NSArray *ar = view.layer.sublayers;
    for (CALayer *pLayer in ar)
    {
        if ([pLayer valueForKey:@"BkgGradientLayer"])
        {
            pGradientLayer = pLayer;
            break;
        }
    }
    if (!pGradientLayer) [view.layer insertSublayer:radialGradientLayer atIndex:0];
    else [view.layer replaceSublayer:pGradientLayer with:radialGradientLayer];
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    CGRect theViewBounds = self.mainCollectionView.bounds;
    CGFloat theRow = [self getSelectedItemIndex];
    CGFloat cellSpacing = cellSpacingConst;
    CGFloat refPosition =  280.0f;
    CGFloat centerOffset = (self.mainCollectionView.bounds.size.width - cellSpacing) * 0.5f;
    
    CGFloat theDelta = ((theRow + 0.5f) * cellSpacing + centerOffset - theViewBounds.size.width * 0.5f - scrollView.contentOffset.x) / cellSpacing;
    
    CGFloat thePosition =  refPosition+fabs([self.positionoffsetInterpolator interpolatedValueForKey:theDelta]);
    
    
    for(int i=0; i <[self.mainCollectionView numberOfItemsInSection:0]; i++)
    {
        
        MainCollectionViewCell *cell = (MainCollectionViewCell*)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if(theRow == i)
            [cell toogleScrollEnabled:YES];
        else
            [cell toogleScrollEnabled:NO];

        
        for(int j=1; j <[cell.collectionView numberOfItemsInSection:0]; j++)
        {
            SubCollectionViewCell *subcell = (SubCollectionViewCell*)[cell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
            
            CGFloat comp = 1.0f;
            
            if(j == 1)
            {
                
                if(theRow == i)
                {
                    comp = 0;
                    [subcell toggleCellHidden:NO];
                }
                else
                    [subcell toggleCellHidden:YES];
                
                subcell.center = CGPointMake(subcell.center.x, thePosition+(comp*150.0f));
            }
            else
                [subcell toggleCellHidden:YES];
            
            
            
        }
    }
    
    if(self.isViewVisible)
    {
       // UPDATE COLOURS
        CGFloat refX = cellSpacingConst;
        CGFloat offX = scrollView.contentOffset.x;
        
        int currentRow = (int)floorf(offX/refX);
        
        UIColor *fromUIColor;
        UIColor *fromBkgColor;
        
        UIColor *toUIColor;
        UIColor *toBkgColor;
        
        CGFloat edgeRight = refX*(currentRow+1);
        CGFloat percentX = 1.0f-(edgeRight-offX)/refX;


        if(currentRow < 0 )
        {
            NSDictionary *current = [self.colourArray objectAtIndex:0];
            fromUIColor = toUIColor = [current objectForKey:@"colour"];
            fromBkgColor = toBkgColor = [current objectForKey:@"background"];
        }
        else if ( currentRow >= [self.mainCollectionView numberOfItemsInSection:0]-1)
        {
            NSDictionary *current = [self.colourArray objectAtIndex:[self.mainCollectionView numberOfItemsInSection:0]-1];
            fromUIColor = toUIColor = [current objectForKey:@"colour"];
            fromBkgColor = toBkgColor = [current objectForKey:@"background"];
        }
        else
        {
            NSDictionary *current = [self.colourArray objectAtIndex:currentRow];
            
            fromUIColor = [current objectForKey:@"colour"];
            fromBkgColor = [current objectForKey:@"background"];
            
            if(currentRow+1 < [self.mainCollectionView numberOfItemsInSection:0])
            {
                NSDictionary *next = [self.colourArray objectAtIndex:currentRow+1];

                toUIColor = [next objectForKey:@"colour"];
                toBkgColor = [next objectForKey:@"background"];
            }
            else
            {
                toUIColor = fromUIColor;
                toBkgColor = fromBkgColor;
            }
        }
        
        [self interpolateFromCenterColor:fromBkgColor to:toBkgColor edgeFrom:fromBkgColor edgeTo:toBkgColor progress:percentX];
        [self updateUIButtons:fromUIColor to:toUIColor progress:percentX];
    }
    
    

}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self getSelectedItemMain];
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //NSLog(@"MAIN scrollViewDidEndScrollingAnimation");
    [self scrollViewDidScroll:scrollView];
}

- (int)getSelectedItemIndex
{
    NSIndexPath *theIndexPath = ((CCoverflowCollectionViewLayout *)self.mainCollectionView.collectionViewLayout).currentIndexPath;
    if (theIndexPath == NULL)
        return 0;
    else
        return (int)theIndexPath.row;
}

- (IBAction)onBackButtonPressed:(id)sender {
    
    
    int mainIndex = [self getSelectedItemIndex];
    int subIndex = 0;
    int byteIndex = 0;
    
    MainCollectionViewCell *cell = (MainCollectionViewCell*)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:mainIndex inSection:0]];
    SubCollectionViewCell *subcell;
    
    if(cell != NULL)
    {
        NSIndexPath *subIndexPath = ((CCoverflowVerticalCollectionViewLayout *)cell.collectionView.collectionViewLayout).currentIndexPath;
        
        subIndex = (int)subIndexPath.row;
        subcell = (SubCollectionViewCell*)[cell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:subIndex inSection:0]];
        
        if(subcell != NULL)
        {
            NSIndexPath *byteIndexPath = ((CCoverflowByteCollectionViewLayout *)subcell.collectionView.collectionViewLayout).currentIndexPath;
            byteIndex = (int)byteIndexPath.row;
        }
    }
    
    
    if(byteIndex > 0)
    {
        // rewind byte
        [subcell.collectionView  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        for(int i=0; i <[subcell.collectionView numberOfItemsInSection:0]; i++)
        {
            ByteCollectionViewCell *byte = (ByteCollectionViewCell*)[subcell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [byte stopVideo];
        }
        
        
    }
    else if (subIndex > 0)
    {
        // rewind sub
        [cell.collectionView  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        
        for(int i=0; i <[cell.collectionView numberOfItemsInSection:0]; i++)
        {
            SubCollectionViewCell *sub = (SubCollectionViewCell*)[cell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [sub stopVideo];
        }
        
    }
    else if (mainIndex > 0)
    {
        // rewind main
        
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    
    AudioServicesPlaySystemSound(1104);
    
    //NSLog(@"go back mainIndex %d subIndex %d byteIndex %d ",mainIndex, subIndex, byteIndex);
}



- (void)resetBytes
{
   // NSLog(@"resetBytes");
    
    
    
    int mainIndex = [self getSelectedItemIndex];
    int subIndex = 0;
    int byteIndex = 0;
 
    
    
        MainCollectionViewCell *cell = (MainCollectionViewCell*)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:mainIndex inSection:0]];
        SubCollectionViewCell *subcell;
        
        if(cell != NULL)
        {
            NSIndexPath *subIndexPath = ((CCoverflowVerticalCollectionViewLayout *)cell.collectionView.collectionViewLayout).currentIndexPath;
            
            subIndex = (int)subIndexPath.row;
            subcell = (SubCollectionViewCell*)[cell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:subIndex inSection:0]];
            
            if(subcell != NULL)
            {
                NSIndexPath *byteIndexPath = ((CCoverflowByteCollectionViewLayout *)subcell.collectionView.collectionViewLayout).currentIndexPath;
                byteIndex = (int)byteIndexPath.row;
            }
        }
    
    while (mainIndex > 0 || subIndex>0 || byteIndex>0) {

        
        if(byteIndex > 0)
        {
            // rewind byte
            [subcell.collectionView  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            
            for(int i=0; i <[subcell.collectionView numberOfItemsInSection:0]; i++)
            {
                ByteCollectionViewCell *byte = (ByteCollectionViewCell*)[subcell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [byte stopVideo];
            }
            
            
            byteIndex = 0;
            
        }
        else if (subIndex > 0)
        {
            // rewind sub
            [cell.collectionView  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            
            for(int i=0; i <[cell.collectionView numberOfItemsInSection:0]; i++)
            {
                SubCollectionViewCell *sub = (SubCollectionViewCell*)[cell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [sub stopVideo];
            }
            
            subIndex = 0;
            
        }
        else if (mainIndex > 0)
        {
            // rewind main
            
            [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            
            mainIndex = 0;
        }
        
    }
    
    [self updateFrequentBytes];
    [self.mainCollectionView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self initScrollOffsets];
        
    });

    
   
}



- (void)getSelectedItemMain
{
    // tracking

    if(self.isViewVisible)
    {
         int selected = [self getSelectedItemIndex];
        NSString *title = [[self.mainObjects objectAtIndex:selected] objectForKey:@"title"];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Page Visited" properties:@{
                                                       @"Component": @"Keyboard",
                                                       @"Page":[NSString stringWithFormat:@"Category %@",title]
                                                       }];
    }
    
    
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


-(void) toggleByteUI:(NSNotification *)notis
{
    
   
    if(self.isByteUIVisible)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleByteUIPressEnd:) object:nil];
        
        self.isByteUIVisible = NO;
        [self.byteUI setGestureEnabled:NO];
        
        
        [self fadeView:(UIView*)self.platformCollectionView toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.saveButton toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.icon toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.closeButton toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.statusLabel toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.byteUI toAlpha:0 withSpeed:fadeSpeed];
    }
    else
    {
        if(notis.object != nil)
        {
            self.isByteUIVisible = YES;
            
            self.videoPath = ((ByteCollectionViewCell*)notis.object).videoPath;
            self.videoName = ((ByteCollectionViewCell*)notis.object).videoName;
            [[SettingsManager sharedSettings] addNewFrequentByte:((ByteCollectionViewCell*)notis.object).data];
            
            [self copyVideo];
            
            [self fadeView:(UIView*)self.platformCollectionView toAlpha:0 withSpeed:fadeSpeed*0.7f];
            [self fadeView:(UIView*)self.saveButton toAlpha:0 withSpeed:fadeSpeed*0.7f];
            [self fadeView:(UIView*)self.icon toAlpha:0 withSpeed:fadeSpeed*0.7f];
            [self fadeView:(UIView*)self.closeButton toAlpha:0 withSpeed:fadeSpeed*0.7f];
            [self fadeView:(UIView*)self.statusLabel toAlpha:1.0f withSpeed:fadeSpeed*0.7f];
            [self fadeView:(UIView*)self.byteUI toAlpha:1.0f withSpeed:fadeSpeed];
        }
        
        [self updateFrequentBytes];

    }
    
    [self toggleBlurEffect];

}

-(void) toggleByteUIPressBegan:(NSNotification *)notis
{
    [self.platformCollectionView reloadData];
    if(self.isByteUIVisible)
    {
        [self.statusLabel setText:@""];
        [self fadeView:(UIView*)self.statusLabel toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.platformCollectionView toAlpha:1.0f withSpeed:fadeSpeed];
        [self fadeView:(UIView*)self.saveButton toAlpha:1.0f withSpeed:fadeSpeed];
        [self fadeView:(UIView*)self.icon toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.closeButton toAlpha:1.0f withSpeed:fadeSpeed];
    }
    else
    {
        
        if(notis.object != nil)
        {
            self.videoPath = ((ByteCollectionViewCell*)notis.object).videoPath;
            self.videoName = ((ByteCollectionViewCell*)notis.object).videoName;
            [[SettingsManager sharedSettings] addNewFrequentByte:((ByteCollectionViewCell*)notis.object).data];

            self.isByteUIVisible = YES;
            
            [self.statusLabel setText:@""];
            [self fadeView:(UIView*)self.statusLabel toAlpha:0 withSpeed:fadeSpeed*0.7f];
            [self fadeView:(UIView*)self.platformCollectionView toAlpha:1.0f withSpeed:fadeSpeed];
            [self fadeView:(UIView*)self.saveButton toAlpha:1.0f withSpeed:fadeSpeed];
            [self fadeView:(UIView*)self.icon toAlpha:0 withSpeed:fadeSpeed*0.7f];
            [self fadeView:(UIView*)self.closeButton toAlpha:1.0f withSpeed:fadeSpeed];
            [self fadeView:(UIView*)self.byteUI toAlpha:1.0f withSpeed:fadeSpeed];
            
            // tracking
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"Page Visited" properties:@{
                                                         @"Component": @"Keyboard",
                                                         @"Page":@"Channel Selection"
                                                         }];

            
        }
        
        [self updateFrequentBytes];

        
    }
    
    
    
    
    [self toggleBlurEffect];
}

-(void) copyVideo
{
    NSLog(@"_videoPath %@",self.videoPath);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int savedPlatform = [[defaults objectForKey:@"savedPlatform"] intValue];
    NSString *channel = [[self.byteUI.platformObjects objectAtIndex:savedPlatform] objectAtIndex:0];
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Channel Selected" properties:@{
                                                 @"Component": @"Keyboard",
                                                 @"Channel":channel
                                                 }];

    
    switch (savedPlatform) {
        default:
        case 0:
        {
            // 0 imessage
            
            [self.statusLabel setText:@"COPYING..."];
            
            NSData *data = [NSData dataWithContentsOfURL:self.videoPath];
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setData:data forPasteboardType:@"public.mpeg-4"];
            
            [self performSelector:@selector(onVideoCopyReady) withObject:self afterDelay:copyingDelay];
            /*
             id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
             [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"video"
             action:@"save_for_imessage"
             label:_videoName
             value:nil] build]];
             */
        }
            break;
        case 1:
        case 2:
        {
            // 2 whatsapp
            
            [self.statusLabel setText:@"COPYING..."];
            
            NSData *data = [NSData dataWithContentsOfURL:self.videoPath];
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setData:data forPasteboardType:@"public.mpeg-4"];
            
            NSLog(@"data is :- %@",[pasteBoard dataForPasteboardType:@"public.mpeg-4"]);
            
            [self performSelector:@selector(onVideoCopyReady) withObject:self afterDelay:copyingDelay];
            
            
            NSString    * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:data];
            savePath = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
            UIDocumentInteractionController *_documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
            _documentInteractionController.UTI = @"net.whatsapp.movie";
            _documentInteractionController.delegate = (id)self;
            [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:_contentView animated: YES];
            
            
//            NSString *URLString=self.videoPath;
//            
//            NSURL *VideoURL=[NSURL URLWithString:URLString];
//            
//            NSMutableArray *activityItems= [NSMutableArray arrayWithObjects:VideoURL, @"Hey, check out this video I've shared with you, it's awesome!", nil];
//            
//            self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//            self.activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypePrint,
//                                                                  UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,
//                                                                  UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,
//                                                                  UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,
//                                                                  UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
//            
//            [self presentViewController:self.activityViewController animated:YES completion:nil];
//            
            
            /*
             id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
             [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"video"
             action:@"save_for_imessage"
             label:_videoName
             value:nil] build]];
             */
        }
            break;
        case 3:
        case 4:
        {
            // 1 facebook messenger
            // 2 whatsapp
            // 3 twitter
            // 4 camera roll∫
            
            [self.statusLabel setText:@"SAVING TO CAMERA\nROLL..."];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:self.videoPath];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
                NSURL *tempURL = [documentsURL URLByAppendingPathComponent:[self.videoPath lastPathComponent]];
                [data writeToURL:tempURL atomically:YES];
                
                
                
//                UISaveVideoAtPathToSavedPhotosAlbum(tempURL.path, nil, NULL, NULL);     //commented line in original
                
                
                
                
                __block PHFetchResult *photosAsset;
                __block PHAssetCollection *collection;
                __block PHObjectPlaceholder *placeholder;
                
                // Find the album
                PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
                fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"BYTE.ME"];
                collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                      subtype:PHAssetCollectionSubtypeAny
                                                                      options:fetchOptions].firstObject;
                // Create the album
                if (!collection)
                {
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetCollectionChangeRequest *createAlbum = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"BYTE.ME"];
                        placeholder = [createAlbum placeholderForCreatedAssetCollection];
                    } completionHandler:^(BOOL success, NSError *error) {
                        if (success)
                        {
                            PHFetchResult *collectionFetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[placeholder.localIdentifier]
                                                                                                                        options:nil];
                            collection = collectionFetchResult.firstObject;
                            
                            // Save to the album
                            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                //[PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
                                PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:tempURL];
                                placeholder = [createAssetRequest placeholderForCreatedAsset];
                                
                                photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                                PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection
                                                                                                                                              assets:photosAsset];
                                [albumChangeRequest addAssets:@[placeholder]];
                                
                            } completionHandler:^(BOOL success, NSError *error) {
                                if (success)
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        // code here
                                        [self performSelector:@selector(onVideoCopyReady) withObject:self afterDelay:copyingDelay];
                                        
                                    });
                                }
                                else
                                {
                                    NSLog(@"copying [error show:----%@", error);
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        // code here
                                        [self performSelector:@selector(onVideoCopyError) withObject:self afterDelay:copyingDelay];
                                        
                                    });
                                    
                                }
                            }];

                        }
                        else
                        {
                            //NSLog(@"%@", error);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // code here
                                [self performSelector:@selector(onVideoCopyError) withObject:self afterDelay:copyingDelay];
                                
                            });
                            
                        }
                    }];
                }
                else
                {
                    // Save to the album
                    // __block PHObjectPlaceholder *placeholder;
                    
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        //[PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
                        PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:tempURL];
                        placeholder = [createAssetRequest placeholderForCreatedAsset];
                        
                        photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection
                                                                                                                                      assets:photosAsset];
                        [albumChangeRequest addAssets:@[placeholder]];
                        
                    } completionHandler:^(BOOL success, NSError *error) {
                        if (success)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // code here
                                [self performSelector:@selector(onVideoCopyReady) withObject:self afterDelay:copyingDelay];
                                
                            });
                        }
                        else
                        {
                            //NSLog(@"%@", error);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // code here
                                [self performSelector:@selector(onVideoCopyError) withObject:self afterDelay:copyingDelay];
                                
                            });
                            
                        }
                    }];
                }
                
         
                
                
               
                
                
            }];
            
            
        }
            break;
    }
    
   
    
}



-(void) onVideoCopyError
{
    [self.statusLabel setText:@"OOPS, SOMETHING\nWENT WRONG\nPLEASE TRY AGAIN..."];
    [self fadeView:(UIView*)self.closeButton toAlpha:1.0f withSpeed:fadeSpeed];
}


-(void) toggleByteUIPressEnd:(NSNotification *)notis
{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleByteUIPressEnd:) object: nil];
        
        self.isByteUIVisible = NO;
        [self.byteUI setGestureEnabled:NO];
        
        [self fadeView:(UIView*)self.statusLabel toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.platformCollectionView toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.saveButton toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.closeButton toAlpha:0 withSpeed:fadeSpeed*0.7f];
        [self fadeView:(UIView*)self.byteUI toAlpha:0 withSpeed:fadeSpeed];
        [self fadeView:(UIView*)self.icon toAlpha:0 withSpeed:fadeSpeed*0.7f];
        
        [self toggleBlurEffect];
}

-(void) toggleBlurEffect
{
    
    if(self.isByteUIVisible)
        [self fadeView:(UIView*)self.visualEffectView toAlpha:1.0f withSpeed:fadeSpeed*0.5f];
    else
        [self fadeView:(UIView*)self.visualEffectView toAlpha:0 withSpeed:fadeSpeed*0.5f];
}

-(void) onVideoCopyReady
{
    //NSLog(@"onVideoCopyReady");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int savedPlatform = [[defaults objectForKey:@"savedPlatform"] intValue];
    
    switch (savedPlatform) {
        default:
        case 0:
        {
            // 0 imessage
            [self.statusLabel setText:@"SUCCESSFULLY\nCOPIED!"];
            
            self.iconYConstraint.constant = -45.0f;
            [self.icon setImage:[UIImage imageNamed:@"key_checkmark_outline"]];
            [self fadeView:(UIView*)self.icon toAlpha:1.0f withSpeed:fadeSpeed*0.7f];
            
            [self performSelector:@selector(onVideoSavedReady) withObject:nil afterDelay:savedDelay];
            
        }
            break;
        case 1:
        case 2:
        {
//            2 whatsapp
            [self.statusLabel setText:@"SUCCESSFULLY\nCOPIED!"];
            
            self.iconYConstraint.constant = -45.0f;
            [self.icon setImage:[UIImage imageNamed:@"key_checkmark_outline"]];
            [self fadeView:(UIView*)self.icon toAlpha:1.0f withSpeed:fadeSpeed*0.7f];
            
            [self performSelector:@selector(onVideoSavedReady) withObject:nil afterDelay:savedDelay];
            
        }
            break;

        case 3:
        case 4:
        {
            // 1 facebook messenger
            // 2 whatsapp
            // 3 twitter
            // 4 camera roll
            
            [self.statusLabel setText:@"SUCCESSFULLY\nSAVED!"];
            
            self.iconYConstraint.constant = -45.0f;
            [self.icon setImage:[UIImage imageNamed:@"key_checkmark_outline"]];
            [self fadeView:(UIView*)self.icon toAlpha:1.0f withSpeed:fadeSpeed*0.7f];
            
            [self performSelector:@selector(onVideoSavedReady) withObject:nil afterDelay:savedDelay];
        }
            break;
            
    }
    
}


-(void) onVideoSavedReady
{
    //NSLog(@"onVideoSavedReady");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int savedPlatform = [[defaults objectForKey:@"savedPlatform"] intValue];
    
    [self.icon setAlpha:0];
    
    switch (savedPlatform) {
        default:
        case 0:
        {
            // 0 imessage
            [self.statusLabel setText:@"PASTE INTO\niMESSAGE"];
            [self.byteUI setGestureEnabled:YES];
            
            self.iconYConstraint.constant = -45.0f;
            [self.icon setImage:[UIImage imageNamed:@"icon_message"]];
            [self fadeView:(UIView*)self.icon toAlpha:1.0f withSpeed:fadeSpeed*0.7f];
            
            [self performSelector:@selector(toggleByteUIPressEnd:) withObject:nil afterDelay:autoHideDelay];
            
        }
            break;
        case 1:
        case 2:
        {
            // 2 whatsapp
            [self.statusLabel setText:@"PASTE INTO\nWhatsapp"];
            [self.byteUI setGestureEnabled:YES];
            
            self.iconYConstraint.constant = -45.0f;
            [self.icon setImage:[UIImage imageNamed:@"icon_whatsapp"]];
            [self fadeView:(UIView*)self.icon toAlpha:1.0f withSpeed:fadeSpeed*0.7f];
            
            [self performSelector:@selector(toggleByteUIPressEnd:) withObject:nil afterDelay:autoHideDelay];
            
        }
            break;
        case 3:
        case 4:
        {
            // 1 facebook messenger
            // 2 whatsapp
            // 3 twitter
            // 4 camera roll
            
            [self.statusLabel setText:@"INSERT FROM\nCAMERA ROLL"];
            [self.byteUI setGestureEnabled:YES];
            
            self.iconYConstraint.constant = -45.0f;
            [self.icon setImage:[UIImage imageNamed:@"icon_camera"]];
            [self fadeView:(UIView*)self.icon toAlpha:1.0f withSpeed:fadeSpeed*0.7f];
            
            [self performSelector:@selector(toggleByteUIPressEnd:) withObject:nil afterDelay:autoHideDelay];
            
        }
            break;
            
    }
    
}

- (BOOL)testFullAccess
{
    
   // NSLog(@"testFullAccess");
    
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.RPRAdvisoryltd.Audio"];
    NSString *testFilePath = [[containerURL path] stringByAppendingPathComponent:@"testFullAccess"];
    
    NSError *fileError = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:testFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:testFilePath error:&fileError];
    }
    
    if (fileError == nil) {
      //  NSLog(@"testFullAccess no error");

        
        NSString *testString = @"testing, testing, 1, 2, 3...";
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:testFilePath
                                                               contents: [testString dataUsingEncoding:NSUTF8StringEncoding]
                                                             attributes:nil];
        
        
      // NSLog(@"testFullAccess no error %d",success );

        return success;
    } else {
        
        //NSLog(@"testFullAccess error %@",fileError);

        return NO;
    }
}

- (IBAction)onSaveButtonDown:(id)sender
{
    [self.byteUI setGestureEnabled:NO];
    
    [self fadeView:(UIView*)self.platformCollectionView toAlpha:0 withSpeed:fadeSpeed*0.7f];
    [self fadeView:(UIView*)self.saveButton toAlpha:0 withSpeed:fadeSpeed*0.7f];
    [self fadeView:(UIView*)self.icon toAlpha:0 withSpeed:fadeSpeed*0.7f];
    [self fadeView:(UIView*)self.closeButton toAlpha:0 withSpeed:fadeSpeed*0.7f];
    [self fadeView:(UIView*)self.statusLabel toAlpha:1.0f withSpeed:fadeSpeed*0.7f];
    
    [self performSelector:@selector(copyVideo) withObject:self afterDelay:fadeSpeed];
    
}
- (IBAction)onCloseButtonDown:(id)sender {
    
   // NSLog(@"onCloseButtonDown");
    [self toggleByteUIPressEnd:nil];
}

- (IBAction)handleChangeKeyboard:(id)sender {
    AudioServicesPlaySystemSound(1104);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleChangeKeyboadButton" object:nil userInfo:nil];
}


-(void) toggleSaveButtonPress:(NSNotification *)notis
{
    [self onSaveButtonDown:nil];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}


@end
