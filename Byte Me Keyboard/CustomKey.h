//
//  CustomKey.h
//  Byte Me
//
//  Created by Leandro Marques on 15/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomKey : UIButton
@property (nonatomic) IBInspectable BOOL isNotMagnifiable;
@property (nonatomic) IBInspectable BOOL usesDarkTheme;
@property (nonatomic) IBInspectable BOOL isTopRow;
@property (nonatomic) IBInspectable BOOL isSideMagnified;
@property (nonatomic) IBInspectable BOOL isImage;
@property (nonatomic) IBInspectable BOOL isShiftable;
@property (nonatomic) IBInspectable BOOL isShiftKey;
@property (nonatomic) IBInspectable BOOL isLeftEdge;
@property (nonatomic) IBInspectable BOOL isRightEdge;
@property (nonatomic) IBInspectable NSString *imageNormal;
@property (nonatomic) IBInspectable NSString *imageHighlight;

-(void) toggleShift:(BOOL) shift;
-(void) toggle123:(BOOL) numeric;
-(void) toggleSymbols:(BOOL) symbols;
-(void) toggleHightlighted:(BOOL) highlighted;
-(NSString *) getKeyStringValue;
-(void) toggleSearchEnabled:(BOOL) enabled;
@end
