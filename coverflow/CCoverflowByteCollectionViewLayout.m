//
//  CCoverflowByteCollectionViewLayout.m
//  Byte Me
//
//  Created by Leandro Marques on 13/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "CCoverflowByteCollectionViewLayout.h"

#import "CInterpolator.h"
#import "CBetterCollectionViewLayoutAttributes.h"
#import "Constants.h"

@interface CCoverflowByteCollectionViewLayout ()
@property (readwrite, nonatomic, strong) NSIndexPath *currentIndexPath;

@property (readwrite, nonatomic, assign) CGFloat centerOffset;
@property (readwrite, nonatomic, assign) NSInteger cellCount;
@property (readwrite, nonatomic, strong) CInterpolator *scaleInterpolator;
@property (readwrite, nonatomic, strong) CInterpolator *positionoffsetInterpolator;
//@property (readwrite, nonatomic, strong) CInterpolator *rotationInterpolator;
//@property (readwrite, nonatomic, strong) CInterpolator *zOffsetInterpolator;
@property (readwrite, nonatomic, strong) CInterpolator *darknessInterpolator;
@end

@implementation CCoverflowByteCollectionViewLayout

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

    self.cellSize = (CGSize){ 401.0f, cellHeightConst };
    self.cellSpacing = cellSpacingConst;
    self.snapToCells = YES;
    
    self.positionoffsetInterpolator = [[CInterpolator interpolatorWithDictionary:@{
                                                                                   @(-0.8f):               @(-self.cellSpacing * 0.25f),
                                                                                   @(-0.2f - FLT_EPSILON): @(  0.0f),
                                                                                   }] interpolatorWithReflection:YES];
    /*
    self.rotationInterpolator = [[CInterpolator interpolatorWithDictionary:@{
                                                                             @(-0.5f):  @(0.0f), // 50.0f
                                                                             @(-0.0f): @( 0.0f),
                                                                             }] interpolatorWithReflection:YES];
     */
    
    self.scaleInterpolator = [[CInterpolator interpolatorWithDictionary:@{
                                                                          @(-1.0f): @(0.8f), // 0.9f
                                                                          @(-0.5f): @(1.0f),
                                                                          }] interpolatorWithReflection:NO];
    
    //	self.zOffsetInterpolator = [[CInterpolator interpolatorWithDictionary:@{
    //		@(-9.0f):               @(9.0f),
    //		@(-1.0f - FLT_EPSILON): @(1.0f),
    //		@(-1.0f):               @(0.0f),
    //		}] interpolatorWithReflection:NO];
    
    
    self.darknessInterpolator = [[CInterpolator interpolatorWithDictionary:@{
                                                                             @(-0.8f): @(0.45f), // 0.4f
                                                                             @(-0.3f): @(0.0f),
                                                                             }] interpolatorWithReflection:NO];
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.centerOffset = (self.collectionView.bounds.size.width - self.cellSpacing) * 0.5f;
    
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
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
    
    // Cells...
    // TODO -- 3 is a bit of a fudge to make sure we get all cells... Ideally we should compute the right number of extra cells to fetch...
    NSInteger theStart = MIN(MAX((NSInteger)floorf(CGRectGetMinX(rect) / self.cellSpacing) - 3, 0), self.cellCount);
    NSInteger theEnd = MIN(MAX((NSInteger)ceilf(CGRectGetMaxX(rect) / self.cellSpacing) + 3, 0), self.cellCount);
    
    for (NSInteger N = theStart; N != theEnd; ++N)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:N inSection:0];
        
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (theAttributes != NULL)
        {
            [theLayoutAttributes addObject:theAttributes];
        }
    }
    
    // Decorations...
    //[theLayoutAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:@"title" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    return(theLayoutAttributes);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Capture some commonly used variables...
    const CGFloat theRow = indexPath.row;
    const CGRect theViewBounds = self.collectionView.bounds;
    
    CBetterCollectionViewLayoutAttributes *theAttributes = [CBetterCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    theAttributes.size = self.cellSize;
    
    // #########################################################################
    
    // Delta is distance from center of the view in cellSpacing units...
    const CGFloat theDelta = ((theRow + 0.5f) * self.cellSpacing + self.centerOffset - theViewBounds.size.width * 0.5f - self.collectionView.contentOffset.x) / self.cellSpacing;
    
    // TODO - we should write a getter for this that calculates the value. Setting it constantly is wasteful.
    if (roundf(theDelta) == 0)
    {
        self.currentIndexPath = indexPath;
    }
    
    // #########################################################################
    
    const CGFloat thePosition = (theRow + 0.5f) * (self.cellSpacing) + [self.positionoffsetInterpolator interpolatedValueForKey:theDelta];
    theAttributes.center = (CGPoint){ thePosition + self.centerOffset, CGRectGetMidY(theViewBounds) };
    
    // #########################################################################
    
    CATransform3D theTransform = CATransform3DIdentity;
    //theTransform.m34 = 1.0f / -850.0f; // Magic Number is Magic.
    
    const CGFloat theScale = [self.scaleInterpolator interpolatedValueForKey:theDelta];
    theTransform = CATransform3DScale(theTransform, theScale, theScale, 1.0f);
    
    /*
    const CGFloat theRotation = [self.rotationInterpolator interpolatedValueForKey:theDelta];
    theTransform = CATransform3DTranslate(theTransform, self.cellSize.width * (theDelta > 0.0f ? 0.5f : -0.5f), 0.0f, 0.0f);
    theTransform = CATransform3DRotate(theTransform, theRotation * (CGFloat)M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    theTransform = CATransform3DTranslate(theTransform, self.cellSize.width * (theDelta > 0.0f ? -0.5f : 0.5f), 0.0f, 0.0f);
    
    
     const CGFloat theZOffset = [self.zOffsetInterpolator interpolatedValueForKey:theDelta];
    theTransform = CATransform3DTranslate(theTransform, 0.0, 0.0, theZOffset);
      */
    
    theAttributes.transform3D = theTransform;
    
    // #########################################################################
    
    theAttributes.shieldAlpha = [self.darknessInterpolator interpolatedValueForKey:theDelta];
    
    theAttributes.zIndex = self.cellCount - abs((int)self.currentIndexPath.row-(int)indexPath.row);
    
    // #########################################################################
    return(theAttributes);
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    theAttributes.center = (CGPoint){ .x = CGRectGetMidX(self.collectionView.bounds), .y = CGRectGetMaxY(self.collectionView.bounds) - 25};
    theAttributes.size = (CGSize){ cellWidthConst, cellHeightConst };
    theAttributes.zIndex = 1;
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
