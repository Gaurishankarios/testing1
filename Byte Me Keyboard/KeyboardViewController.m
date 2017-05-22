//
//  KeyboardViewController.m
//  Byte Me Keyboard
//
//  Created by Leandro Marques on 07/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "KeyboardViewController.h"
//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"
#import "Constants.h"
#import "MainView.h"
#import "Mixpanel.h"

@import AudioToolbox;

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) NSTimer *backspaceTimer;
@property (strong, nonatomic) IBOutlet MainView *mainView;
@property (nonatomic) BOOL refreshBytes;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    if(trackingVerbose)
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    [[GAI sharedInstance] trackerWithTrackingId:trackingID];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"keyboard"
                                                          action:@"launched"
                                                           label:nil
                                                           value:nil] build]];
    */

    
    //[_nextKeyboardBtn addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];

    [_backspaceKeyboardBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressBackSpace:)]];

   // NSLog(@"KeyboardViewController viewDidLoad");
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"KeyboardViewController viewWillAppear");
   // [self.mainView initScrollOffsets];
    
    
    
    if(![self.mainView testFullAccess])
    {
        //NSLog(@"NO FULL ACCESS ");
    }
    else
    {
    
        self.mainView.isViewVisible = YES;
        if(self.refreshBytes)
            [self.mainView resetBytes];
        
       // NSLog(@" home");
        // tracking
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Page Visited" properties:@{
                                                     @"Component": @"Keyboard",
                                                     @"Page":@"Home"
                                                     }];


    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   // NSLog(@"KeyboardViewController viewDidAppear %d",self.mainView.isViewLoaded);
    
    if(![self.mainView testFullAccess])
    {
        //NSLog(@"NO FULL ACCESS ");
        
        [self performSegueWithIdentifier:@"ShowAlphaNumericKeyboard" sender:nil];

    }
    else
    {

    
        self.mainView.isViewVisible = YES;

        if(!self.mainView.isViewLoaded)
        {

            [self.mainView initScrollOffsets];
            [self.mainView initView];
        }
        else
        {
            if(self.refreshBytes)
            {
                self.refreshBytes = NO;
               // [self.mainView initScrollOffsets];

            }
        }
    }

    
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   // NSLog(@"KeyboardViewController viewDidDisappear ");
    self.mainView.isViewVisible = NO;

}


- (void)pressBackSpace:(UILongPressGestureRecognizer *)inGestureRecognizer
{
    if(inGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if(_backspaceTimer == nil)
        {
            _backspaceTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(backspaceKeyPressed:) userInfo:nil repeats:YES];
        }

    }
    if(inGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [_backspaceTimer invalidate];
        _backspaceTimer = nil;
        [_backspaceKeyboardBtn setHighlighted:NO];

    }
}
- (IBAction)searchButtonDown:(id)sender {
   [_searchBtn setHighlighted:YES];
    
}



-(IBAction) backspaceKeyPressed: (UIButton*) sender {
    [_backspaceKeyboardBtn setHighlighted:YES];

    //AudioServicesPlaySystemSound(1104);
    //[self.textDocumentProxy deleteBackward];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleBackspaceButton" object:nil userInfo:nil];

}




- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
   // NSLog(@"prepareForSegue %@ %@", segue, sender);
    
    
    if([segue.identifier isEqualToString:@"ShowKeyboardSearch"])
    {
        self.refreshBytes = YES;
    }
    else
    {
        self.refreshBytes = NO;
    }
    
    // NSLog(@"prepareForSegue %@", sender);
    
    // configure the destination view controller:
    
  //  UINavigationController *navController = segue.destinationViewController;
    //ContentViewController *contentController = [navController childViewControllers].firstObject;
    
    //NSArray *sender_array = (NSArray*) sender;
    
    /*
     NSDictionary *sender_meta = [sender objectAtIndex:0];
     
     NSLog(@"name  %@", [sender_meta objectForKey:@"name"]);
     
     [navController.navigationBar.topItem setTitle:[sender_meta objectForKey:@"name"]];
     */
    
   // contentController.categoryData = sender;
   // [contentController initPage];
    
    /*
     UILabel* c = [(SWUITableViewCell *)sender label];
     UINavigationController *navController = segue.destinationViewController;
     ColorViewController* cvc = [navController childViewControllers].firstObject;
     if ( [cvc isKindOfClass:[ColorViewController class]] )
     {
     cvc.color = c.textColor;
     cvc.text = c.text;
     }
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
- (void)textWillChange:(id<UITextInput>)textInput {
}

- (void)textDidChange:(id<UITextInput>)textInput {
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}
 */

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (UIGestureRecognizer *recognizer in self.backspaceKeyboardBtn.gestureRecognizers) {
        [self.backspaceKeyboardBtn removeGestureRecognizer:recognizer];
    }
}


@end
