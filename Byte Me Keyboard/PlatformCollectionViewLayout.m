//
//  PlatformCollectionViewLayout.m
//  Byte Me
//
//  Created by Leandro Marques on 21/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "PlatformCollectionViewLayout.h"

#import "CInterpolator.h"
#import "CBetterCollectionViewLayoutAttributes.h"
#import "Constants.h"

// If we decide to make this vertical we could use these macros to help make it painless...
//#define XORY(axis, point) ((axis) ? (point.y) : (point.x))
//#define WORH(axis, size) ((axis) ? (size.height) : (size.width))

@interface PlatformCollectionViewLayout ()
@property (readwrite, nonatomic, strong) NSIndexPath *currentIndexPath;

@property (readwrite, nonatomic, assign) CGFloat centerOffset;
@property (readwrite, nonatomic, assign) NSInteger cellCount;
@property (readwrite, nonatomic, strong) CInterpolator *positionoffsetInterpolator;
@end

@implementation PlatformCollectionViewLayout

+ (Class)layoutAttributesClass
{
    return([CBetterCollectionViewLayoutAttributes class]);
}

- (id)init
{
    if ((self = [super init]) != NULL)
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.cellSize = (CGSize){ 85.0f, 115.0f };
    self.cellSpacing = 87.0f;
    self.snapToCells = YES;
    
    
  
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.centerOffset = (self.collectionView.bounds.size.width - (self.cellCount *self.cellSpacing)) * 0.5f;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return(YES);
}

- (CGSize)collectionViewContentSize
{
    const CGSize theSize = {
        .width = self.cellSpacing * self.cellCount + self.centerOffset * 2.0f,
        .height = self.collectionView.bounds.size.height,
    };
    return(theSize);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *theLayoutAttributes = [NSMutableArray array];
    
    NSInteger theStart = MIN(MAX((NSInteger)floorf(CGRectGetMinX(rect) / self.cellSpacing) - 2, 0), self.cellCount);
    NSInteger theEnd = MIN(MAX((NSInteger)ceilf(CGRectGetMaxX(rect) / self.cellSpacing) + 2, 0), self.cellCount);
    
    for (NSInteger N = theStart; N != theEnd; ++N)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:N inSection:0];
        
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (theAttributes != NULL)
        {
            [theLayoutAttributes addObject:theAttributes];
        }
    }
  
    return(theLayoutAttributes);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    const CGFloat theRow = indexPath.row;
    const CGRect theViewBounds = self.collectionView.bounds;
    
    CBetterCollectionViewLayoutAttributes *theAttributes = [CBetterCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    theAttributes.size = self.cellSize;
    
    const CGFloat theDelta = ((theRow + 0.5f) * self.cellSpacing + self.centerOffset - theViewBounds.size.width * 0.5f - self.collectionView.contentOffset.x) / self.cellSpacing;

    if (roundf(theDelta) == 0)
        self.currentIndexPath = indexPath;
    
    const CGFloat thePosition = (theRow + 0.5f) * (self.cellSpacing) ;
    theAttributes.center = (CGPoint){ thePosition + self.centerOffset, CGRectGetMidY(theViewBounds) };
    return(theAttributes);
}



- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGPoint theTargetContentOffset = proposedContentOffset;
    
    if (self.snapToCells == YES)
    {
        
        theTargetContentOffset.x = roundf(theTargetContentOffset.x / self.cellSpacing) * self.cellSpacing;
        theTargetContentOffset.x = MIN(theTargetContentOffset.x, (self.cellCount - 1) * self.cellSpacing);
    }
    return(theTargetContentOffset);
}


@end
