//
//  CustomByteSegue.m
//  Byte Me
//
//  Created by Leandro Marques on 26/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "CustomByteSegue.h"

@implementation CustomByteSegue
/*
- (void) perform{
    
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    [UIView transitionFromView:source.view
                        toView:destination.view
                      duration:0.50f
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:nil];
}
 */

-(void)perform {
    
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationController = self.destinationViewController;

    CATransition* transition = [CATransition animation];
    transition.duration = .3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
 
   [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
    
    
}
 @end
