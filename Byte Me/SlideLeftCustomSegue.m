//
//  SlideLeftCustomSegue.m
//  Byte Me
//
//  Created by Leandro Marques on 13/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "SlideLeftCustomSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlideLeftCustomSegue

- (void)perform{
    
    __block UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    __block UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];

}

@end
