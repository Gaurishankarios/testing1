//
//  CustomKey.m
//  Byte Me
//
//  Created by Leandro Marques on 15/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "CustomKey.h"
#import "Constants.h"

@interface CustomKey ()
@property  (nonatomic) UIView *magnifiedView;
@property  (nonatomic) UIView *originalView;
@property  (nonatomic) UILabel *magnifiedViewLabel;
@property  (nonatomic) UIColor *backgroundNormalColour;
@property  (nonatomic) UIColor *labelNormalColour;

@end

@implementation CustomKey


- (void)awakeFromNib
{
    self.layer.cornerRadius = keyboardKeyBorderRadius;
    self.layer.masksToBounds = YES;
    //[self setFont:[UIFont fontWithName:@"Quicksand-Regular" size:keyboardKeyFontSize]];
    [self setTitleColor:linkTintColor forState:UIControlStateHighlighted];
    [self setTitleColor:keyboardKeyLabelColor forState:UIControlStateNormal];
    self.labelNormalColour = keyboardKeyLabelColor;
    
    if(self.isShiftable)
        [self toggleShift:NO];
    
    if(self.isImage)
    {
        UIImage *imageHighlight = [[UIImage imageNamed:self.imageHighlight] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self setImage:imageHighlight forState:UIControlStateHighlighted];
        
        UIImage *image = [[UIImage imageNamed:self.imageNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self setImage:image forState:UIControlStateNormal];
        
        [self setTintColor:keyboardKeyLabelColor];
        
        self.backgroundNormalColour = keyboardImageKeyBackgroundColor;
        [self.layer setBackgroundColor:[self.backgroundNormalColour CGColor]];

    }
    else
    {
        if(self.usesDarkTheme)
            self.backgroundNormalColour = keyboardImageKeyBackgroundColor;
        else
            self.backgroundNormalColour = globalBackgroundColor;

        [self.layer setBackgroundColor:[self.backgroundNormalColour CGColor]];

    }
    

    
}

- (void)setHighlighted:(BOOL)highlighted
{
    
    if(self.isImage)
    {
        if(!self.isShiftKey)
        {
            [super setHighlighted:highlighted];
            
            if(highlighted)
                [self.layer setBackgroundColor:[globalBackgroundColor CGColor]];
            else
                [self.layer setBackgroundColor:[self.backgroundNormalColour CGColor]];
        }
    }
    else
    {
        if(self.isNotMagnifiable)
        {
            if(self.usesDarkTheme)
            {
                if(highlighted)
                {
                    [self setTitleColor:keyboardKeyLabelColor forState:UIControlStateHighlighted];
                    [self setTitleColor:keyboardKeyLabelColor forState:UIControlStateNormal];

                    [self.layer setBackgroundColor:[globalBackgroundColor CGColor]];
                }
                else
                {
                    [self setTitleColor:self.labelNormalColour forState:UIControlStateHighlighted];
                    [self setTitleColor:self.labelNormalColour forState:UIControlStateNormal];
                    
                    [self.layer setBackgroundColor:[self.backgroundNormalColour CGColor]];
                }
            }
            else
            {

                if(highlighted)
                    [self.layer setBackgroundColor:[keyboardImageKeyBackgroundColor CGColor]];
                else
                    [self.layer setBackgroundColor:[self.backgroundNormalColour CGColor]];
            }
        }
        else
        {
            if(highlighted)
            {

                [self setTintColor:linkTintColor];
                
                if(!self.magnifiedView)
                {
                    CGFloat magHeight = self.frame.size.height*1.5f;
                    
                    CGFloat magY = self.superview.superview.frame.origin.y+self.superview.frame.origin.y+self.frame.origin.y-magHeight-keyboardKeyBorderRadius;
                    
                    if(self.isTopRow)
                    {
                        magHeight = self.frame.size.height;

                        magY = self.superview.superview.frame.origin.y+self.superview.frame.origin.y+self.frame.origin.y-magHeight-keyboardKeyBorderRadius;
                    }
                    
                    CGFloat magX = -self.frame.size.width*0.25f+self.frame.origin.x;
                    CGFloat marginX = self.frame.size.width*0.25f;

                    if(self.isLeftEdge)
                    {
                        magX = self.frame.origin.x;
                        marginX = 0;
                    }
                    
                    if(self.isRightEdge)
                    {
                        magX = -self.frame.size.width*0.5f+self.frame.origin.x;
                        marginX = self.frame.size.width*0.5f;;
                    }
                    
                    

                    
                    self.magnifiedView = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                  magX,
                                                                                  magY,
                                                                                  self.frame.size.width*1.5f,
                                                                                  magHeight)];
                    self.magnifiedView.backgroundColor = globalBackgroundColor;
                    self.magnifiedView.layer.cornerRadius = keyboardKeyBorderRadius;

                    self.magnifiedView.layer.masksToBounds = YES;
                    
                    
                    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.magnifiedView.bounds];
                    self.magnifiedView.layer.masksToBounds = NO;
                    self.magnifiedView.layer.shadowColor = [UIColor blackColor].CGColor;
                    self.magnifiedView.layer.shadowOffset = CGSizeMake(0.0f, 2.f);
                    self.magnifiedView.layer.shadowOpacity = 0.5f;
                    self.magnifiedView.layer.shadowPath = shadowPath.CGPath;
                    
                    
                    
                    
                    if(!self.originalView)
                    {
                        self.originalView = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                            marginX,
                                                                                            self.magnifiedView.frame.size.height-keyboardKeyBorderRadius*2.0,
                                                                                            self.frame.size.width,
                                                                                            self.frame.size.height+2.0*keyboardKeyBorderRadius)];
                        self.originalView.backgroundColor = globalBackgroundColor;
                        self.originalView.layer.cornerRadius = keyboardKeyBorderRadius;
                        
                        self.originalView.layer.masksToBounds = YES;
                        
                        [self.magnifiedView addSubview:self.originalView];

                        
                    }
                    else
                        [self.originalView setHidden:NO];
                    
                    
                    if(!self.magnifiedViewLabel)
                    {
                        self.magnifiedViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                                            0,
                                                                                            0,
                                                                                            self.magnifiedView.frame.size.width,
                                                                                            magHeight)];
                        [self.magnifiedViewLabel setText: [self titleLabel].text];
                        [self.magnifiedViewLabel setFont:[UIFont systemFontOfSize:25.0f]];
                        [self.magnifiedViewLabel setTextAlignment:NSTextAlignmentCenter];
                        [self.magnifiedViewLabel setTextColor:keyboardKeyLabelColor];
                        [self.magnifiedView addSubview:self.magnifiedViewLabel];
                        
                    }
                    else
                        [self.magnifiedViewLabel setText: [self titleLabel].text];

                    
                    [self.superview.superview.superview addSubview:self.magnifiedView];
                    [self.magnifiedView setHidden:NO];

                }
                else
                    [self.magnifiedView setHidden:NO];
                
                
            }
            else
            {
                [self setTintColor:keyboardKeyLabelColor];
                
                if(self.magnifiedView)
                    [self.magnifiedView setHidden:YES];
            }
        }
    }
    
}

-(void) toggleShift:(BOOL) shift
{
    if(self.isShiftable)
    {
        NSString *l = [[self titleLabel].text lowercaseString];
        
        if(shift)
            l = [[self titleLabel].text uppercaseString];
      
        [self setTitle:l forState:UIControlStateNormal];
        [self setTitle:l forState:UIControlStateHighlighted];
    }
}

-(void) toggle123:(BOOL) numeric
{
        NSString *l = @"123";
        
        if(numeric)
            l = @"ABC";
        
        [self setTitle:l forState:UIControlStateNormal];
        [self setTitle:l forState:UIControlStateHighlighted];
}

-(void) toggleSymbols:(BOOL) symbols
{
    NSString *l = @"#+=";
    
    if(symbols)
        l = @"123";
    
    [self setTitle:l forState:UIControlStateNormal];
    [self setTitle:l forState:UIControlStateHighlighted];
}

-(void) toggleHightlighted:(BOOL) highlighted
{
    [super setHighlighted:highlighted];
    
    if(highlighted)
        [self.layer setBackgroundColor:[globalBackgroundColor CGColor]];
    else
        [self.layer setBackgroundColor:[self.backgroundNormalColour CGColor]];
}

-(NSString *) getKeyStringValue
{
    return [self titleLabel].text;
}


-(void) toggleSearchEnabled:(BOOL) enabled
{
    
    if(enabled)
    {
        [self setEnabled:enabled];
        //[self.layer setBackgroundColor:[globalBackgroundColor CGColor]];
        self.backgroundNormalColour = linkTintColor;
        [self.layer setBackgroundColor:[self.backgroundNormalColour CGColor]];
        [self setTitleColor:globalBackgroundColor forState:UIControlStateNormal];
        [self setTitleColor:keyboardKeyLabelColor forState:UIControlStateHighlighted];
        
        self.labelNormalColour = globalBackgroundColor;

    }
    else
    {
        [self setEnabled:enabled];
        self.backgroundNormalColour = keyboardImageKeyBackgroundColor;
        [self.layer setBackgroundColor:[self.backgroundNormalColour CGColor]];
        [self setTitleColor:keyboardKeyLabelDisabledColor forState:UIControlStateDisabled];
        [self setTitleColor:keyboardKeyLabelColor forState:UIControlStateHighlighted];

    }
}

@end
