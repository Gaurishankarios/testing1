//
//  KeyboardUIView.m
//  Byte Me
//
//  Created by Leandro Marques on 12/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "KeyboardUIView.h"
#import "Constants.h"
#import "CustomKey.h"
@import AudioToolbox;

@interface KeyboardUIView ()
@property  (nonatomic) BOOL isShiftEnabled;
@property  (nonatomic) BOOL isNumericEnabled;
@property  (nonatomic) BOOL isSymbolEnabled;
@property (nonatomic, strong) NSTimer *backspaceTimer;

@end

@implementation KeyboardUIView

- (void)awakeFromNib {
    //[self setBackgroundColor:linkTintColor];
    [self setBackgroundColor:mainBkgColor];

    [self switchKeybordState];
    
    [self.backspaceButton1 addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressBackSpace:)]];
    [self.backspaceButton2 addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressBackSpace:)]];

   
}


-(void) switchKeybordState
{
    [self.lettersRow1 setHidden:self.isNumericEnabled];
    [self.lettersRow2 setHidden:self.isNumericEnabled];
    [self.lettersRow3 setHidden:self.isNumericEnabled];
    
    [self.numbersRow1 setHidden:!self.isNumericEnabled];
    [self.numbersRow2 setHidden:!self.isNumericEnabled];
    [self.numbersRow3 setHidden:!self.isNumericEnabled];
    
    [self.symbolsRow1 setHidden:!self.isNumericEnabled];
    [self.symbolsRow2 setHidden:!self.isNumericEnabled];
    
    if(self.isNumericEnabled)
    {
        [self.numbersRow1 setHidden:self.isSymbolEnabled];
        [self.numbersRow2 setHidden:self.isSymbolEnabled];
        
        [self.symbolsRow1 setHidden:!self.isSymbolEnabled];
        [self.symbolsRow2 setHidden:!self.isSymbolEnabled];
    }
    
    [self.numericButton toggle123:self.isNumericEnabled];
    [self.symbolButton toggleSymbols:self.isSymbolEnabled];

}

-(void) changeShiftState:(BOOL) shift
{
    for(UIView* v in self.subviews)
    {
        for(id b in v.subviews)
        {
            if([b isKindOfClass:[CustomKey class]])
            {
                CustomKey *key = (CustomKey*) b;
                
                if(key.isShiftable)
                    [key toggleShift:shift];
                
                if(key.isShiftKey)
                    [key toggleHightlighted:shift];
            }
        }
    }

}


- (IBAction)handleShiftPress:(id)sender
{
    AudioServicesPlaySystemSound(1104);

    self.isShiftEnabled = !self.isShiftEnabled ;
    [self changeShiftState:self.isShiftEnabled];
}

- (IBAction)handle123Press:(id)sender
{
    AudioServicesPlaySystemSound(1104);

    self.isNumericEnabled = !self.isNumericEnabled ;
    self.isSymbolEnabled = NO;
    [self switchKeybordState];
}


- (IBAction)handleSymbolPress:(id)sender
{
    AudioServicesPlaySystemSound(1104);

    self.isSymbolEnabled = !self.isSymbolEnabled ;
    [self switchKeybordState];
}

- (IBAction)handleBackspacePress:(id)sender
{
    [self.backspaceButton1 setHighlighted:YES];
    [self.backspaceButton2 setHighlighted:YES];

    id<KeyboardUIViewDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(keyboardUIView:didPressBackspace:)]) {
        [strongDelegate keyboardUIView:self didPressBackspace:sender];
    }
}

- (IBAction)handleSpacePress:(id)sender
{
    id<KeyboardUIViewDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(keyboardUIView:didPressSpace:)]) {
        [strongDelegate keyboardUIView:self didPressSpace:sender];
    }
}

- (IBAction)handleSearchPress:(id)sender
{
    id<KeyboardUIViewDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(keyboardUIView:didPressSearch:)]) {
        [strongDelegate keyboardUIView:self didPressSearch:sender];
    }
}

- (IBAction)handleGlobePress:(id)sender
{
    id<KeyboardUIViewDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(keyboardUIView:didPressGlobe:)]) {
        [strongDelegate keyboardUIView:self didPressGlobe:sender];
    }
}



- (IBAction)handleKeyPress:(CustomKey*)sender
{
    id<KeyboardUIViewDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(keyboardUIView:didPressKey:)]) {
        [strongDelegate keyboardUIView:self didPressKey:sender];
    }
    
    if( self.isShiftEnabled)
    {
        self.isShiftEnabled = !self.isShiftEnabled ;
        [self changeShiftState:self.isShiftEnabled];
    }

}


- (void)pressBackSpace:(UILongPressGestureRecognizer *)inGestureRecognizer
{
    if(inGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if(_backspaceTimer == nil)
        {
            _backspaceTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(handleBackspacePress:) userInfo:nil repeats:YES];
        }
        
       
        
    }
    if(inGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [_backspaceTimer invalidate];
        _backspaceTimer = nil;
        [self.backspaceButton1 setHighlighted:NO];
        [self.backspaceButton2 setHighlighted:NO];

        
    }
}

-(void) dealloc
{
    
    for (UIGestureRecognizer *recognizer in self.backspaceButton1.gestureRecognizers) {
        [self.backspaceButton1  removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer *recognizer in self.backspaceButton2.gestureRecognizers) {
        [self.backspaceButton2  removeGestureRecognizer:recognizer];
    }
}

       
       
@end
