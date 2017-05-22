//
//  AlphaNumericViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 19/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "AlphaNumericViewController.h"
#import "Constants.h"
#import "KeyboardUIView.h"
#import "CustomKey.h"
#import "Mixpanel.h"

@import AudioToolbox;


@interface AlphaNumericViewController ()

@end

@implementation AlphaNumericViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:mainBkgColor];
    //[self.searchButton toggleSearchEnabled:NO];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    if(![self testFullAccess])
    {
        [self.msgView setBackgroundColor:linkTintColor];
        [self.msgLabel setText:@"BYTE.ME Keyboard setup incomplete. Turn on Full Access in Settings"];
        [self.msgLabel setTextColor:globalBackgroundColor];
        self.msgHeightConstraint.constant = 40;
    }
    else
        self.msgHeightConstraint.constant = 0;

    [super viewWillAppear:animated];
    
    // tracking
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Page Visited" properties:@{
                                                 @"Component": @"Keyboard",
                                                 @"Page":@"Alpha Numeric Keyboard"
                                                 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressKey:(CustomKey *)key
{
   // NSLog(@"didPressKey %@", [key getKeyStringValue]);
    AudioServicesPlaySystemSound(1104);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleKeyPressed" object:[key getKeyStringValue] userInfo:nil];

   // NSString *text = [self.searchBar text];
    //[self.searchBar setText: [text stringByAppendingString:[key getKeyStringValue]]];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"handleSearchTextUpdate" object:nil userInfo:nil];
    
    //[self updateSerchButton];
    
}


-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressBackspace:(CustomKey *)key
{
   // NSLog(@"didPressBackspace ");
    AudioServicesPlaySystemSound(1104);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleBackspaceButton" object:nil userInfo:nil];
}

-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressSpace:(CustomKey *)key
{
    //NSLog(@"didPressSpace ");
    AudioServicesPlaySystemSound(1104);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleSpacePressed" object:nil userInfo:nil];
}

-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressSearch:(CustomKey *)key
{
    //NSLog(@"didPressSearch ");
    AudioServicesPlaySystemSound(1104);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleReturnPressed" object:nil userInfo:nil];
}


-(void) keyboardUIView:(KeyboardUIView *)KeyboardUIView didPressGlobe:(CustomKey *)key
{
    AudioServicesPlaySystemSound(1104);
    
    //NSLog(@"didPressGlobe ");
    if(![self testFullAccess])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"handleChangeKeyboadButton" object:nil userInfo:nil];
    else
        [self dismissViewControllerAnimated:YES completion:nil];

    
    //[self.navigationController popViewControllerAnimated:YES];

}

-(void) updateSerchButton
{
    /*
    NSLog(@"updateSerchButton");
    NSString *text = [self.searchBar text];
    
    if ([text length] > 0)
    {
        // enable button
        [self.searchButton toggleSearchEnabled:YES];
    } else
    {
        // disable button
        [self.searchButton toggleSearchEnabled:NO];
    }
     */
}


- (BOOL)testFullAccess
{
    
  //  NSLog(@"testFullAccess");
    
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.RPRAdvisoryltd.Audio"];
    NSString *testFilePath = [[containerURL path] stringByAppendingPathComponent:@"testFullAccess"];
    
    NSError *fileError = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:testFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:testFilePath error:&fileError];
    }
    
    if (fileError == nil) {
       // NSLog(@"testFullAccess no error");
        
        
        NSString *testString = @"testing, testing, 1, 2, 3...";
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:testFilePath
                                                               contents: [testString dataUsingEncoding:NSUTF8StringEncoding]
                                                             attributes:nil];
        
        
      // NSLog(@"testFullAccess no error %d",success );
        
        return success;
    } else {
        
       // NSLog(@"testFullAccess error %@",fileError);
        
        return NO;
    }
}


@end

