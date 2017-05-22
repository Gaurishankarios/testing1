//
//  KeyboardUIView.h
//  Byte Me
//
//  Created by Leandro Marques on 12/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomKey;
@protocol KeyboardUIViewDelegate;

@interface KeyboardUIView : UIView
@property (nonatomic, weak) IBOutlet id<KeyboardUIViewDelegate> delegate;

@property (nonatomic) IBOutlet UIView *lettersRow1;
@property (nonatomic) IBOutlet UIView *lettersRow2;
@property (nonatomic) IBOutlet UIView *lettersRow3;
@property (nonatomic) IBOutlet UIView *numbersRow1;
@property (nonatomic) IBOutlet UIView *numbersRow2;
@property (nonatomic) IBOutlet UIView *numbersRow3;
@property (nonatomic) IBOutlet UIView *symbolsRow1;
@property (nonatomic) IBOutlet UIView *symbolsRow2;
@property (nonatomic) IBOutlet CustomKey *symbolButton;
@property (nonatomic) IBOutlet CustomKey *numericButton;

- (IBAction)handleKeyPress:(CustomKey*)sender;
@property (nonatomic) IBOutlet CustomKey *backspaceButton1;
@property (nonatomic) IBOutlet CustomKey *backspaceButton2;
@end

@protocol KeyboardUIViewDelegate <NSObject>

- (void)keyboardUIView:(KeyboardUIView*)KeyboardUIView
             didPressKey:(CustomKey*)key;

- (void)keyboardUIView:(KeyboardUIView*)KeyboardUIView
           didPressBackspace:(CustomKey*)key;

- (void)keyboardUIView:(KeyboardUIView*)KeyboardUIView
     didPressSpace:(CustomKey*)key;

- (void)keyboardUIView:(KeyboardUIView*)KeyboardUIView
     didPressSearch:(CustomKey*)key;

- (void)keyboardUIView:(KeyboardUIView*)KeyboardUIView
        didPressGlobe:(CustomKey*)key;


@end