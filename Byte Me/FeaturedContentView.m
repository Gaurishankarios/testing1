//
//  FeaturedContentView.m
//  Byte Me
//
//  Created by Leandro Marques on 08/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "FeaturedContentView.h"
#import "FeaturedCollectionViewCell.h"
#import "Constants.h"
#import "DecodedString.h"
#import "SettingsManager.h"

@interface FeaturedContentView ()
@property (nonatomic) id delegate;
@property (nonatomic) UIView *separatorLineView;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end


@implementation FeaturedContentView


- (void)awakeFromNib {
    
        
    [self.seeAllButton.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:seeAllLabelFontSize]];
    
    
    [self.seeAllButton setTitle:[seeAllLabel uppercaseString] forState:UIControlStateNormal];
    [self.seeAllButton setTintColor:categoryLabelColor];
    
    [self.categoryLabel setTextColor:categoryLabelColor];
    [self.categoryLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:categoryLabelFontSize]];
    
    [self.icon setImage:[[UIImage imageNamed:@"key_dot"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    // separator
    if(!self.separatorLineView)
    {
        self.separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(categorySeparatorMargin, featuredCellHeight-menuSeparatorThickness,SCREEN_WIDTH-(2.0f*categorySeparatorMargin), menuSeparatorThickness)];
        self.separatorLineView.backgroundColor = categorySeparatorColor;
        [self addSubview:self.separatorLineView];
    }
}

  

-(void) initFeaturedWithDicitionary:(NSDictionary *) data delegate:(id) delegate last:(BOOL) last
{
   // NSLog(@"initFeaturedWithDicitionary  %@", data);

    [self.separatorLineView setHidden:last];
    
    self.delegate = delegate;
    self.featuredData = data;
    
    // labels
    NSString *label = [[DecodedString decodedStringWithString:[data objectForKey:@"name"]] uppercaseString];
    [self.categoryLabel setText:label];
    
    
    [self.icon setTintColor:[[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor]];

    
    //[self.seeAllButton setTintColor:[[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor]];
    //[self.categoryLabel setTextColor:[[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categoryLabelColor]];
    //self.separatorLineView.backgroundColor = [[SettingsManager sharedSettings] getColourFromObject:data defaultColout:categorySeparatorColor];

    
    self.bytesData = [[NSMutableArray alloc] init];
    NSDictionary *bytes = [data objectForKey:@"bytes"];
    NSString *colour = [data objectForKey:@"colour"];
    NSString *background = [data objectForKey:@"background"];

    
    if(bytes)
    {
        //NSLog(@"bytes ok");
        
        NSDictionary *bytes_list_items = [bytes objectForKey:@"items"];
        NSNumber *bytes_list_total = [bytes objectForKey:@"total"];
        
        if(bytes_list_items)
        {
            // NSLog(@"carousel_list ok");
            
            if(bytes_list_total)
            {
                //  NSLog(@"carousel_list_total ok");
                
                if([bytes_list_total intValue] > 0)
                {
                    
                   
                    //   NSLog(@"carousel_list_items ok");
                    
                    //for (NSDictionary *item in bytes_list_items)
                    for (int i=1; i <= [bytes_list_total intValue]; i++)
                    {
                        NSString *item = [NSString stringWithFormat:@"%d",i];
                        
                        NSMutableDictionary *byte_item = [[bytes_list_items objectForKey:item] mutableCopy];
                        [byte_item setObject:colour forKey:@"colour"];
                        [byte_item setObject:background forKey:@"background"];
                        
                        //NSLog(@"carousel_item %@", carousel_item);
                        
                        [self.bytesData addObject:byte_item];
                        
                    }
                    
                  
                    //[self.bytesCollection reloadData];

                }
                else
                {
                  //  NSLog(@"bytes_list_total = 0");
                }
            }
            else
            {
               // NSLog(@"no bytes_list_total");
            }
        }
        else
        {
            //NSLog(@"no bytes_list_items");
        }
 
        
    }
    else
    {
       // NSLog(@"no bytes %@");
       // [self.bytesCollection reloadData]; // clear old assets & data
    }
    

    
    [self.bytesCollection reloadData];

    
    
}


#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.bytesData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FeaturedCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FeaturedByte" forIndexPath:indexPath];
   [cell initCellWithObject:[self.bytesData objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectItemAtIndexPath %@", [self.bytesData objectAtIndex:[indexPath row]]);
    
    self.selected = (int)[indexPath row];
    [self.delegate performSegueWithIdentifier:@"ShowByte" sender: self];
    
   // [self.delegate performSegueWithIdentifier:@"ShowByte" sender: [self.bytesData objectAtIndex:[indexPath row]]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didDeselectItemAtIndexPath");
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   // NSLog(@"collectionViewLayout %f SCREEN_HEIGHT %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    
    CGFloat cellwidth = [self getCellWidth];
    CGFloat cellHeight = (cellwidth/4.0f)*3.0f;
    
    return CGSizeMake(cellwidth, cellHeight);
}

-(CGFloat) getCellWidth
{
   // return floor((SCREEN_WIDTH-(0.0f*gridCellPadding))/3.9f); // 3.3f
    
    // changed to fixed width in pts
    
    return 96.0f;
}

/*

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    //NSLog(@"scrollViewWillEndDragging bounds %f  size %f", self.bytesCollection.bounds.size.width, self.bytesCollection.contentSize.width);
    
    CGFloat pageWidth = [self getCellWidth]+1.0f*gridCellPadding;
    ; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset)
    {
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    }
    else
    {
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    }
    
    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.width)
        newTargetOffset = scrollView.contentSize.width;
    
    
    targetContentOffset->x = currentOffset;
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
}

*/



@end

