//
//  MainCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 07/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "MainCollectionViewCell.h"
#import "ByteCollectionViewCell.h"
#import "CBetterCollectionViewLayoutAttributes.h"
#import "Constants.h"
#import "SubCollectionViewCell.h"

#import "CCoverflowVerticalCollectionViewLayout.h"
#import "CInterpolator.h"
#import "MainView.h"
#import "SettingsManager.h"
#import "DecodedString.h"

@interface MainCollectionViewCell ()
@property (nonatomic) NSArray *items;
@property (readwrite, nonatomic, strong) CInterpolator *positionoffsetInterpolator;
@property (readwrite, nonatomic, strong) CInterpolator *positionoffsetByteInterpolator;
@property (readwrite, nonatomic, strong) CALayer *shieldLayer;

@end


@implementation MainCollectionViewCell


- (void)awakeFromNib {
    _positionoffsetInterpolator = [[CInterpolator interpolatorWithDictionary:@{
                                                                               @(-1.0f):               @(-200),
                                                                               @(-0.2f - FLT_EPSILON): @(  0.0f),
                                                                               }] interpolatorWithReflection:YES];
    _positionoffsetByteInterpolator = [[CInterpolator interpolatorWithDictionary:@{
                                                                                   @(-1.0f):               @(150.0f)
                                                                                   }] interpolatorWithReflection:YES];
    
    [_shadow setBackgroundColor:cellShadowColor];
    _shadow.layer.cornerRadius = tileBorderRadius;
    _shadow.layer.masksToBounds = YES;
    
    _image.layer.cornerRadius = tileBorderRadius;
    _image.layer.masksToBounds = YES;
    
    _shield.layer.cornerRadius = tileBorderRadius;
    _shield.layer.masksToBounds = YES;



}

-(void) prepareForReuse
{
   // NSLog(@" prepareForReuse %@",self.items  );
    
    
    self.items = nil;
    
    [self.image setImage: nil];
    [self.collectionView reloadData];
    
    
}



- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    
    [super applyLayoutAttributes:layoutAttributes];
    
    CBetterCollectionViewLayoutAttributes *theLayoutAttributes = (CBetterCollectionViewLayoutAttributes *)layoutAttributes;
    if (self.shieldLayer == NULL)
    {
        self.shieldLayer = [self makeShieldLayer];
        [_shield.layer addSublayer:self.shieldLayer];
    }
    
    self.shieldLayer.opacity = theLayoutAttributes.shieldAlpha;
}


- (CALayer *)makeShieldLayer
{
    CALayer *theShield = [CALayer layer];
    theShield.frame = self.bounds;
    theShield.backgroundColor = [UIColor blackColor].CGColor;
    return(theShield);
}



-(void) initScrollOffsets
{
    [self scrollViewDidScroll:_collectionView];
}



//-(void) initCellWithData:(NSArray *)data
-(void) initCellWithData:(NSMutableDictionary *)data
{
    //NSLog(@"data %@",data);
    // 0:title, 1:bkg, 2:badge, 3:title text color, 4:tint color, 5:tint color edge, 6:sub objects arr
    
    //_items = data[6];
    _items = [data objectForKey:@"children"];

    [_image setImage: nil];

    if(_items.count > 0)
    {
        
        // hide bkg, label, badge
        [_image setHidden:YES];
        [_label setHidden:YES];
        [_shadow setHidden:YES];
        [_message setHidden:YES];
        //_themeColor = data[4];
        //_themeColorEdge = data[5];
        
        
        _themeColor = [[SettingsManager sharedSettings] getBackgroundFromObject:data defaultColout:categoryLabelColor];
        _themeColorEdge = [[SettingsManager sharedSettings] getBackgroundFromObject:data defaultColout:categoryLabelColor];
        _keyColor = [[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor];
        
        //_themeColor = [[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor];
        //_themeColorEdge = [[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor];
        
        //[_collectionView reloadData];
        //[self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
        

    }
    else
    {
        NSString *type = [data objectForKey:@"type"];
        
        if([type isEqualToString:@"message"])
        {
            // hide bkg, label, badge
            [_image setHidden:YES];
            [_label setHidden:YES];
            [_shadow setHidden:YES];
            [_message setHidden:NO];
            [_message setText: [DecodedString decodedStringWithString:[data objectForKey:@"title"]]];
            [_message setTextColor:globalBackgroundColor];
            
            _themeColor = [[SettingsManager sharedSettings] getBackgroundFromObject:data defaultColout:categoryLabelColor];
            _themeColorEdge = [[SettingsManager sharedSettings] getBackgroundFromObject:data defaultColout:categoryLabelColor];
            _keyColor = [[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor];
        }
        else
        {
            // if cover
            // show bkg, label, badge
            [_image setHidden:NO];
            [_label setHidden:NO];
            //[_shadow setHidden:NO];
            [_shadow setHidden:YES];
            [_message setHidden:YES];
            
            //NSString *imagePath = [self getFormattedImagePath:data[1] extension:data[2]];
            
            NSString *imagePath = [data objectForKey:@"cover"];
            
            
            if(![imagePath isEqualToString:@""])
            {
                
                //[_image setImage: [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath] scale:[UIScreen mainScreen].scale]];
                [_image setImage: [[UIImage imageNamed:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [_image setTintColor:globalBackgroundColor];
            }
            
            [self.image setContentMode:UIViewContentModeScaleToFill];
            
            
            //[_label setText: data[0]];
            [_label setText: [DecodedString decodedStringWithString:[data objectForKey:@"title"]]];
            
            
            //[_label setTextColor:data[3]];
            [_label setTextColor:globalBackgroundColor];
            
            //_themeColor = data[4];
            //_themeColorEdge = data[5];
            _themeColor = [[SettingsManager sharedSettings] getBackgroundFromObject:data defaultColout:categoryLabelColor];
            _themeColorEdge = [[SettingsManager sharedSettings] getBackgroundFromObject:data defaultColout:categoryLabelColor];
            _keyColor = [[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor];
            
            [_image setBackgroundColor:[[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor]];
        }

        
       

        //NSLog(@"_image  %@ _image.image %@", _image, _image.image);

        
    }
    
    [_collectionView reloadData];
    [self performSelector:@selector(initScrollOffsets) withObject:self afterDelay:0.01f];

}


-(NSString *) getFormattedImagePath:(NSString *)file extension:(NSString*) ext
{
    
    int s = (int) roundf([UIScreen mainScreen].scale);
    
    switch (s) {
        default:
        case 1:
            return [[NSBundle mainBundle] pathForResource:file ofType:ext];
            break;
        case 2:
            return [[NSBundle mainBundle] pathForResource:[file stringByAppendingString:@"@2x" ] ofType:ext];
            break;
        case 3:
            return [[NSBundle mainBundle] pathForResource:[file stringByAppendingString:@"@3x" ] ofType:ext];
            break;
    }
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SubCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SubCell" forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    cell.delegate = self;
    cell.parentCollectionView = _collectionView;
    [cell initCellWithData:_items[row]];
    return cell;
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self moveParentCell:scrollView];
    [self moveByteCell:scrollView];

    
}


-(void) moveByteCell:(UIScrollView *)scrollView
{
    CGFloat theRow = [self getSelectedItemIndex];
    CGRect theViewBounds = _parentCollectionView.bounds;
    CGFloat cellSpacing = cellSpacingConst;
    CGFloat refPosition =  333.0f;//340.5f;
    CGFloat centerOffset = (_parentCollectionView.bounds.size.height - cellSpacing) * 0.5f;
    
    // Delta is distance from center of the view in cellSpacing units...
    CGFloat theDelta = ((theRow + 0.5f) * cellSpacing + centerOffset - theViewBounds.size.height * 0.5f - scrollView.contentOffset.y) / cellSpacing;
    
    CGFloat thePosition =  fabs([_positionoffsetByteInterpolator interpolatedValueForKey:theDelta]);
    
    
    thePosition += refPosition;
    
    for(int i=0; i <[_collectionView numberOfItemsInSection:0]; i++)
    {
        
        SubCollectionViewCell *cell = (SubCollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        /*
        if(theRow == i)
            [cell toggleSubCellsHidden:NO hideBytes:NO];
        else
            [cell toggleSubCellsHidden:NO hideBytes:YES];
        */
        
        for(int j=1; j <[cell.collectionView numberOfItemsInSection:0]; j++)
        {

            ByteCollectionViewCell *subcell = (ByteCollectionViewCell*)[cell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];

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
                
                subcell.center = CGPointMake(thePosition+(comp*150.0f), subcell.center.y);

            }
            else
                [subcell toggleCellHidden:YES];
        }
    }

}


-(void) moveParentCell:(UIScrollView *)scrollView
{
    CGFloat theRow = 0;
    CGRect theViewBounds = _parentCollectionView.bounds;
    CGFloat cellSpacing = cellSpacingConst;
    CGFloat centerOffset = (_parentCollectionView.bounds.size.height - cellSpacing) * 0.5f;
    
    CGFloat theDelta = ((theRow + 0.5f) * cellSpacing + centerOffset - theViewBounds.size.height * 0.5f - scrollView.contentOffset.y) / cellSpacing;
    
    CGFloat thePosition =  CGRectGetMidY(theViewBounds)+[_positionoffsetInterpolator interpolatedValueForKey:theDelta];
    
    for(int i=0; i <[_parentCollectionView numberOfItemsInSection:0]; i++)
    {
        
        UICollectionViewCell *cell = [_parentCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if(cell != self)
            cell.center = CGPointMake(cell.center.x, thePosition);
    }
    
    CGFloat refY = _image.frame.size.height*0.75f;
    CGFloat offY = scrollView.contentOffset.y;
    
    if(offY > refY)
        offY = refY;
    
   // [_delegate interpolateFromCenterColor:mainBkgColor to:_themeColor edgeFrom:mainBkgColor edgeTo:_themeColorEdge progress:offY/refY];
   // [_delegate updateUIButtons:globalBackgroundColor to:_keyColor progress:offY/refY];
    
    //NSLog(@"_themeColor %@ _themeColorEdge %@", _themeColor, _themeColorEdge);
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self getSelectedItemMain];
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll:scrollView];
    [self getSelectedItemMain];
    [_parentCollectionView setScrollEnabled:YES];
}

- (int)getSelectedItemIndex
{
    NSIndexPath *theIndexPath = ((CCoverflowVerticalCollectionViewLayout *)_collectionView.collectionViewLayout).currentIndexPath;
    if (theIndexPath == NULL)
        return 0;
    else
        return (int)theIndexPath.row;
}


- (void)getSelectedItemMain
{
    int selected = [self getSelectedItemIndex];
    
   // NSLog(@"SUB SELECTED %d",selected);
    if(selected == 0)
    {
        [_parentCollectionView setScrollEnabled:YES];
    }
    else
    {
        [_parentCollectionView setScrollEnabled:NO];
    }
    
    for(int i=0; i <[_collectionView numberOfItemsInSection:0]; i++)
    {
        
        SubCollectionViewCell *sub = (SubCollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(i == selected)
        {
            //[sub enabledGestures:YES];
            //[sub playVideo];
        }
        else
        {
            [sub stopVideo];
            //[sub enabledGestures:NO];

        }
    }

}

-(void) toggleSubCellsHidden:(BOOL) hidden hideBytes:(BOOL) bytes
{
    for(int i=1; i <[_collectionView numberOfItemsInSection:0]; i++)
    {
        
        SubCollectionViewCell *cell = (SubCollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        [cell toggleSubCellsHidden:hidden hideBytes:bytes];
        
    }

}

-(void) toogleScrollEnabled:(BOOL) enable
{
    [self.collectionView setScrollEnabled:enable];
}

@end
