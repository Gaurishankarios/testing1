//
//  KeyboardMainViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 17/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "KeyboardMainViewController.h"
//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"
#import "Constants.h"
#import "MainView.h"
#import "CustomKey.h"
#import "Mixpanel.h"

@import AudioToolbox;

@interface KeyboardMainViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) NSTimer *backspaceTimer;
//@property (strong, nonatomic) IBOutlet MainView *mainView;

@end




@implementation KeyboardMainViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];

    
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
    
    //[_backspaceKeyboardBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressBackSpace:)]];
    

    //
   // NSLog(@"KeyboardMainViewController viewDidLoad");
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // NSLog(@"KeyboardMainViewController viewWillAppear");
    //[self.mainView initScrollOffsets];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeKeyboadButton:) name:@"handleChangeKeyboadButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackspaceButton:) name:@"handleBackspaceButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyPressed:) name:@"handleKeyPressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReturnPressed:) name:@"handleReturnPressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSpacePressed:) name:@"handleSpacePressed" object:nil];
    
    [self performSegueWithIdentifier:@"ShowKeyboardBytes" sender:nil];

    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear");
    //[self.mainView initView];
    

    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //NSLog(@"KeyboardMainViewController viewWillDisappear");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self dismissViewControllerAnimated:NO completion:nil];


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
       // [_backspaceKeyboardBtn setHighlighted:NO];
        
    }
}




- (IBAction)searchButtonDown:(id)sender {
   // [_searchBtn setHighlighted:YES];
    
    //NSLog(@"Hello");
    //NSString *customURL = @"byteMeHome://";
    /*
     [self.extensionContext openURL:[NSURL URLWithString:customURL] completionHandler:^(BOOL success) {
     NSLog(@"fun=%s after completion. success=%d", __func__, success);
     }];
     */
    /*
     UIResponder *responder = self;
     while(responder){
     if ([responder respondsToSelector: @selector(OpenURL:)]){
     [responder performSelector: @selector(OpenURL:) withObject: [NSURL URLWithString:customURL]];
     }
     responder = [responder nextResponder];
     }*/
}

-(IBAction) backspaceKeyPressed: (UIButton*) sender {
    //[_backspaceKeyboardBtn setHighlighted:YES];
    
    AudioServicesPlaySystemSound(1104);
    [self.textDocumentProxy deleteBackward];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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

- (void)handleChangeKeyboadButton:(NSNotification *)notis
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSelector:@selector(advanceToNextInputMode)];
    
}

- (void)handleBackspaceButton:(NSNotification *)notis
{
    NSLog(@"handleBackspaceButton %@",self);
    //[_backspaceKeyboardBtn setHighlighted:YES];
    AudioServicesPlaySystemSound(1104);
    [self.textDocumentProxy deleteBackward];
    
    NSLog(@"self.textDocumentProxy %@",self.textDocumentProxy);


    
}

-(void) handleKeyPressed: (NSNotification*) notis
{
    NSLog(@"handleKeyPressed");

    NSString *text = (NSString*) notis.object;
    [self.textDocumentProxy insertText:text];
    AudioServicesPlaySystemSound(1104);
}

-(void) handleSpacePressed: (NSNotification*) notis
{
    AudioServicesPlaySystemSound(1104);
    [self.textDocumentProxy insertText:@" "];
}

-(void) handleReturnPressed: (NSNotification*) notis
{
    AudioServicesPlaySystemSound(1104);
    [self.textDocumentProxy insertText:@"\n"];
}




-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

