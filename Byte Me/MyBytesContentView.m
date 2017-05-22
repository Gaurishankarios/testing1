//
//  MyBytesContentView.m
//  Byte Me
//
//  Created by Leandro Marques on 21/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "MyBytesContentView.h"
#import "MyBytesCollectionViewCell.h"
#import "MyBytesCollectionHeaderCell.h"
#import "Constants.h"
#import "SettingsManager.h"

@interface MyBytesContentView ()
@property (nonatomic) NSDictionary *featuredData;
@property (nonatomic) NSMutableArray *bytesData;
@property (nonatomic) id delegate;


@end

@implementation MyBytesContentView

- (void)awakeFromNib {
    
    
    /*
     CGRect screenRect = [[UIScreen mainScreen] bounds];
     CGFloat screenWidth = screenRect.size.width;
     
     // separator
     UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(categorySeparatorMargin, self.bounds.size.height-menuSeparatorThickness,screenWidth-(2.0f*categorySeparatorMargin), menuSeparatorThickness)];
     separatorLineView.backgroundColor = categorySeparatorColor;
     [self addSubview:separatorLineView];
     */
    
    
}

-(void) initGridWithDicitionary:(NSDictionary *) data delegate:(id) delegate
{
    
    //NSLog(@"initFeaturedWithDicitionary %@", data);
    self.delegate = delegate;
    self.featuredData = data;
    
    // labels
    
    
    
    self.bytesData = [[NSMutableArray alloc] init];
    NSDictionary *bytes = [data objectForKey:@"bytes"];
    
    // header
    [self.bytesData addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               @"header", @"name",
                               @"header", @"target",
                               nil]
     ];
    
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
                    // sort bytes by added
                    NSArray *bytes_list_items_sorted_reverse = [bytes_list_items keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
                        
                        if ([[obj1 objectForKey:@"date_added"]integerValue] > [[obj2 objectForKey:@"date_added"] integerValue]) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        
                        if ([[obj1 objectForKey:@"date_added"] integerValue] < [[obj2 objectForKey:@"date_added"] integerValue]) {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    }];
                    
                    NSArray* bytes_list_items_sorted = [[bytes_list_items_sorted_reverse reverseObjectEnumerator] allObjects];
                    
                    NSMutableArray *enabledBytes = [[NSMutableArray alloc] init];
                    NSMutableArray *disabledBytes = [[NSMutableArray alloc] init];
                    
                    for (int i=0; i < [bytes_list_total intValue]; i++)
                    {
                        int iSorted = [[bytes_list_items_sorted objectAtIndex:i] intValue];
                        
                        NSString *item = [NSString stringWithFormat:@"%d",iSorted];
                        
                        NSDictionary *byte_item = [bytes_list_items objectForKey:item];
                        
                        if([[SettingsManager sharedSettings] isByteEnabled:byte_item])
                            [enabledBytes addObject:byte_item];
                        else
                            [disabledBytes addObject:byte_item];
                    }
                    
                    
                    for (NSDictionary *i in enabledBytes)
                    {
                        [self.bytesData addObject:i];
                    }
                    
                    for (NSDictionary *i in disabledBytes)
                    {
                        [self.bytesData addObject:i];
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
            // NSLog(@"no bytes_list_items");
        }
        
        
    }
    else
    {
        //  NSLog(@"no bytes");
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
    if([indexPath row] == 0)
    {
        MyBytesCollectionHeaderCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MyByteHeader" forIndexPath:indexPath];
        [cell initHeader];
        return cell;

    }
    else
    {
        MyBytesCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MyByte" forIndexPath:indexPath];
        [cell initCellWithObject:[self.bytesData objectAtIndex:indexPath.row]];
        return cell;

    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"didSelectItemAtIndexPath");
    
    //[self.delegate performSegueWithIdentifier:@"ShowByte" sender: [self.bytesData objectAtIndex:[indexPath row]]];
    if([indexPath row] > 0)
    {
        MyBytesCollectionViewCell *byte = (MyBytesCollectionViewCell*)[self.bytesCollection cellForItemAtIndexPath:indexPath];
        [byte changeStatus];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didDeselectItemAtIndexPath");
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // NSLog(@"collectionViewLayout %f SCREEN_HEIGHT %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    if([indexPath row] == 0)
    {
        return CGSizeMake(SCREEN_WIDTH, myBytesHeaderCellHeight);
    }
    else
    {
        //CGFloat cellwidth = floor((SCREEN_WIDTH-(4.0f*gridCellPadding))/3.0f);
        //CGFloat cellHeight = 20.0f+(cellwidth/4.0f)*3.0f;
        
        CGFloat cellwidth = [self getCellWidth];
        //CGFloat cellwidth = floor((SCREEN_WIDTH-(4.0f*gridCellPadding))/3.0f);
        // CGFloat cellHeight = 20.0f+(cellwidth/4.0f)*3.0f;
        CGFloat cellHeight = (cellwidth/4.0f)*3.0f;

        return CGSizeMake(cellwidth, cellHeight);
    }
}

-(CGFloat) getCellWidth
{
    // return floor((SCREEN_WIDTH-(0.0f*gridCellPadding))/3.9f); // 3.3f
    
    // changed to fixed width in pts
    // NSLog(@" SCREEN_WIDTH %f",SCREEN_WIDTH);
    
    if(SCREEN_WIDTH > 320.0f)
        return 110.0f;
    else
        return 90.0f;
    
}



@end

