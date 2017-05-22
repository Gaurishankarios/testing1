//
//  GridContentView.m
//  Byte Me
//
//  Created by Leandro Marques on 12/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "GridContentView.h"
#import "GridCollectionViewCell.h"
#import "GridHeaderCollectionViewCell.h"
#import "Constants.h"

@interface GridContentView ()
@property (nonatomic) NSDictionary *featuredData;
@property (nonatomic) NSMutableArray *displayData;
@property (nonatomic) id delegate;
@property (nonatomic) BOOL hasHeader;


@end

@implementation GridContentView

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
    
    self.delegate = delegate;
    self.featuredData = data;
    
    // labels
    
    
    
    self.bytesData = [[NSMutableArray alloc] init];
    self.displayData = [[NSMutableArray alloc] init];

    NSDictionary *bytes = [data objectForKey:@"bytes"];
    NSDictionary *header = [data objectForKey:@"header"];
    NSString *colour = [data objectForKey:@"colour"];
    NSString *background = [data objectForKey:@"background"];

    if(header)
    {
       // NSLog(@"header");

        /*
        [self.self.bytesData addObject:
         [NSArray arrayWithObjects:
          [NSNumber numberWithInt:2],
          header,
          nil]];
         */
        
        self.hasHeader = YES;
        
        [self.displayData addObject:
          header];
        self.bytesCollectionTopMarginConstraint.constant = -10.0f;
    }
    else
        self.bytesCollectionTopMarginConstraint.constant = 10.0f;


    
    if(bytes)
    {
        //NSLog(@"bytes ok");
        
        NSDictionary *bytes_list_items = [bytes objectForKey:@"items"];
        NSNumber *bytes_list_total = [bytes objectForKey:@"total"];
        
        if(bytes_list_items)
        {
            // NSLog(@"bytes_list_items ok");
            
            if(bytes_list_total)
            {
                  //NSLog(@"bytes_list_total ok");
                
                if([bytes_list_total intValue] > 0)
                {
                    
                    
                      // NSLog(@"bytes_list_total > 0 ok");
                    
                    for (NSString *item in bytes_list_items)
                    //for (int i=1; i <= [bytes_list_total intValue]; i++)
                    {
                        //NSString *item = [NSString stringWithFormat:@"%d",i];
                        
                        NSMutableDictionary *byte_item = [[bytes_list_items objectForKey:item] mutableCopy];
                        if(colour)
                            [byte_item setObject:colour forKey:@"colour"];
                        if(background)
                            [byte_item setObject:background forKey:@"background"];
                        
                        
                        //NSLog(@"carousel_item %@", carousel_item);
                        
                        [self.displayData addObject:byte_item];
                        [self.bytesData addObject:byte_item];
                        /*
                        [self.self.bytesData addObject:
                         [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:1],
                          byte_item,
                          nil]];
                         */

                        
                    }
                    
                    //NSLog(@"bytes_list_total > 0 done");

                    
                    //[self.bytesCollection reloadData];
                    
                }
                else
                {
                     // NSLog(@"bytes_list_total = 0");
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
         // NSLog(@"no bytes");
       // [self.bytesCollection reloadData]; // clear old assets & data
    }
    
    
    
    [self.bytesCollection reloadData];

    
    
}


#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.displayData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = [[self.displayData objectAtIndex:[indexPath row]] objectForKey:@"type"];
    
    if(type)
    {
        GridHeaderCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GridHeader" forIndexPath:indexPath];
        [cell initHeaderWithObject:[self.displayData objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else
    {
        GridCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GridByte" forIndexPath:indexPath];
        [cell initCellWithObject:[self.displayData objectAtIndex:indexPath.row]];
        
        return cell;

    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"didSelectItemAtIndexPath");
    
   // [self.delegate performSegueWithIdentifier:@"ShowByte" sender: [self.bytesData objectAtIndex:[indexPath row]]];
    
    
    UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if([cell isKindOfClass:[GridCollectionViewCell class]])
    {
       // NSLog(@"didSelectItemAtIndexPath GridCollectionViewCell");
        
        self.selected = (int)[indexPath row];
        
       if(self.hasHeader)
            self.selected -= 1;
        
        [self.delegate performSegueWithIdentifier:@"ShowByte" sender: self];
    }
    //else
      //  NSLog(@"didSelectItemAtIndexPath GridHeaderCollectionViewCell");
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didDeselectItemAtIndexPath");
}


 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
    
    // NSLog(@"collectionViewLayout %f SCREEN_HEIGHT %f",SCREEN_WIDTH,SCREEN_HEIGHT);
     NSString *type = [[self.displayData objectAtIndex:[indexPath row]] objectForKey:@"type"];
     
     if(type)
     {
         return CGSizeMake(SCREEN_WIDTH, headerCelltHeight);

     }
     else
     {
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


/*
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    NSString *type = [[self.displayData objectAtIndex:section] objectForKey:@"type"];
    
    if(type)
        return 0.0f;
    else
        return 10.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}
*/

@end

