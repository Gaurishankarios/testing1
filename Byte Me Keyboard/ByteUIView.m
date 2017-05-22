//
//  ByteUIView.m
//  Byte Me
//
//  Created by Leandro Marques on 20/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "ByteUIView.h"
#import "PlatformCollectionViewCell.h"
#import "Constants.h"

/*
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
 */

@interface ByteUIView ()


@end

@implementation ByteUIView


- (void)awakeFromNib {
    
    if (self.gestureRecognizers.count == 0)
    {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)]];
    }
    
    [self setGestureEnabled:NO];
    
    _platformObjects = @[
                         @[@"iMessage", @"plat_imessage"],
                         @[@"Messenger", @"plat_messenger"],
                         @[@"WhatsApp", @"plat_whatsapp"],
                         @[@"Twitter", @"plat_twitter"],
                         @[@"Save", @"plat_camera_roll"]
                         //@[@"Copy", @"plat_clipboard"]

                         ];
    
}

- (void)tapCell:(UITapGestureRecognizer *)inGestureRecognizer
{
   //  NSLog(@"tapUIView");
    [self setGestureEnabled:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleByteUI" object:self userInfo:nil];
}

-(void) setGestureEnabled:(BOOL)enabled
{
    for(UIGestureRecognizer *g in self.gestureRecognizers)
        g.enabled = enabled;
}




#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_platformObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlatformCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PlatformCell" forIndexPath:indexPath];
    
    long row = [indexPath row];
    NSArray *data = _platformObjects[row];
    [cell.label setText:data[0]];
    cell.imageName = data[1];

    [cell.image setImage:[UIImage imageNamed:data[1]]];

    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int savedPlatform = [[defaults objectForKey:@"savedPlatform"] intValue];
    
    if(row == savedPlatform)
    {
        [cell setSelected:YES];
        [cv selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionTop];
    }
     */

    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int i = (int)[indexPath row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:i] forKey:@"savedPlatform"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleSaveButtonPress" object:self userInfo:nil];

    
    /*
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"platform" // Event category(required)
                                                          action:@"select"  // Event action (required)
                                                           label:_platformObjects[i][0]          // Event label
                                                           value:nil] build]];    // Event value
     */


}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    return CGSizeMake(80, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
     CGFloat leftInset=(collectionView.frame.size.width-80*[collectionView numberOfItemsInSection:section])/2;
    
    if(leftInset < 0)
        leftInset = 0;
    
    return UIEdgeInsetsMake(0, leftInset, 0, 0);
}

@end
