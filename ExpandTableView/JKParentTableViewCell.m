//
//  JKParentTableViewCell.m
//  ExpandTableView
//
//  Created by Jack Kwok on 7/5/13.
//  Copyright (c) 2013 Jack Kwok. All rights reserved.
//

#import "JKParentTableViewCell.h"
#import "Constants.h"
#import "Mixpanel.h"

@interface JKParentTableViewCell ()
@property (nonatomic) UIView *separatorLineView;
@end

@implementation JKParentTableViewCell

@synthesize label,iconImage,selectionIndicatorImgView,parentIndex,selectionIndicatorImg, sectionId;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [[self contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    if(!self) {
        return self;
    }
    self.contentView.backgroundColor = menuBackgroundColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = menuBackgroundColor;
    label.opaque = NO;
    label.textColor = menuLabelColor;
    label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:label];
    
    
    self.selectionIndicatorImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //[self.selectionIndicatorImgView setContentMode:UIViewContentModeCenter];
    [self.contentView addSubview:selectionIndicatorImgView];
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    //self.iconImage.image = [self.iconImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[self.iconImage setContentMode:UIViewContentModeCenter];
    [self.contentView addSubview:iconImage];
    
    [self.iconImage setTintColor:menuIconColor];
    
    self.iconImageLeft = [[UIImageView alloc] initWithFrame:CGRectZero];
    //self.iconImage.image = [self.iconImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[self.iconImage setContentMode:UIViewContentModeCenter];
    [self.contentView addSubview:self.iconImageLeft];
    
    [self.iconImageLeft setTintColor:menuIconColor];

    
    if(!self.separatorLineView)
    {
        float margin = 16.0f;
        self.separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(margin, self.contentView.frame.size.height-menuSeparatorThickness, 300.0f - margin*2.0f, menuSeparatorThickness)];
        self.separatorLineView.backgroundColor = menuSubBackgroundColor;
        [self.contentView addSubview:self.separatorLineView];
    }

    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setupDisplay];
}

- (void)setupDisplay {
    CGRect contentRect = [self bounds];
    CGFloat contentAreaWidth = self.contentView.bounds.size.width;
    CGFloat contentAreaHeight = self.contentView.bounds.size.height;
    CGFloat checkMarkHeight = 0.0;
    CGFloat checkMarkWidth = 0.0;
    CGFloat iconHeight = 0.0; //  set this according to icon
    CGFloat iconWidth = 0.0;
    CGFloat iconLeftHeight = 0.0; //  set this according to icon
    CGFloat iconLeftWidth = 0.0;
    if (self.iconImage.image) {
        iconWidth = MIN(contentAreaWidth, self.iconImage.image.size.width);
        iconHeight = MIN(contentAreaHeight, self.iconImage.image.size.height);
    }
    if (self.selectionIndicatorImgView.image) {
        checkMarkWidth = MIN(contentAreaWidth, self.selectionIndicatorImgView.image.size.width);
        checkMarkHeight = MIN(contentAreaHeight, self.selectionIndicatorImgView.image.size.height);
    }
    if (self.iconImageLeft.image) {
        iconLeftWidth = MIN(contentAreaWidth, self.iconImageLeft.image.size.width);
        iconLeftHeight = MIN(contentAreaHeight, self.iconImageLeft.image.size.height);
    }
    //iconWidth = iconHeight = 32.0f;

    
    CGFloat sidePadding = 6.0;
    CGFloat icon2LabelPadding = -6.0;
    CGFloat checkMarkPadding = 16.0;
    [self.contentView setAutoresizesSubviews:YES];

    self.iconImageLeft.frame = CGRectMake(0, (contentAreaHeight - iconLeftHeight)/2, iconLeftWidth, iconLeftHeight);
    self.iconImage.frame = CGRectMake(contentAreaWidth-sidePadding-iconWidth, (contentAreaHeight - iconHeight)/2, iconWidth, iconHeight);

    CGFloat XOffset = iconLeftWidth + icon2LabelPadding ;
    //CGFloat XOffset = sidePadding + icon2LabelPadding;

    CGFloat labelWidth = contentAreaWidth - XOffset - checkMarkWidth - checkMarkPadding;
    self.label.frame = CGRectMake(XOffset, 0, labelWidth, contentAreaHeight);
    //self.label.backgroundColor = [UIColor redColor];
    self.selectionIndicatorImgView.frame = CGRectMake(contentAreaWidth - checkMarkWidth - checkMarkPadding,
                                                 (contentRect.size.height/2)-(checkMarkHeight/2),
                                                 checkMarkWidth,
                                                 checkMarkHeight);
}

- (void)rotateIconToExpanded {
    [UIView beginAnimations:@"rotateDisclosure" context:nil];
    [UIView setAnimationDuration:0.2];
    iconImage.transform = CGAffineTransformMakeRotation(M_PI * 1.0);
   // [self.iconImage setTintColor:globalBackgroundColor];
    self.label.textColor = menuSubLabelColor;
    [UIView commitAnimations];
    
    if(self.separatorLineView)
       [self.separatorLineView setHidden:YES];
    
    //[self highlightCell:YES];

}

- (void)rotateIconToCollapsed {
    [UIView beginAnimations:@"rotateDisclosure" context:nil];
    [UIView setAnimationDuration:0.2];
    iconImage.transform = CGAffineTransformMakeRotation(M_PI * 2.0);
   // [self.iconImage setTintColor:menuIconColor];
    self.label.textColor = menuLabelColor;

    [UIView commitAnimations];
    
    if(self.separatorLineView)
        [self.separatorLineView setHidden:NO];
    
    //[self highlightCell:NO];

}

- (void)selectionIndicatorState:(BOOL) visible {
    
  
    //
    /*
    if (!self.selectionIndicatorImg) {
        self.selectionIndicatorImg = [UIImage imageNamed:@"checkmark"];
    }
    self.selectionIndicatorImgView.image = self.selectionIndicatorImg;  // probably better to init this elsewhere
    if (visible) {
        self.selectionIndicatorImgView.hidden = NO;
    } else {
        self.selectionIndicatorImgView.hidden = YES;
    }
     */
}

- (void)setCellForegroundColor:(UIColor *) foregroundColor {
    //self.label.textColor = foregroundColor;
}

- (void)setCellBackgroundColor:(UIColor *) backgroundColor {
   // self.contentView.backgroundColor = backgroundColor;
}



- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    if(selected)
    {
       //NSLog(@"setSelected JKParentTableViewCell %@", self.label.text);
        // tracking
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Sidenav Item Clicked" properties:@{
                                                     @"Component": @"Container",
                                                     @"Item": self.label.text
                                                     }];
    }
    
    [super setSelected:selected animated:animated];
   
}


-(void) highlightCell:(BOOL) selected
{
    if(selected)
    {

        self.contentView.backgroundColor = linkTintColor;
        self.label.backgroundColor = linkTintColor;
        self.label.textColor = menuBackgroundColor;
        
        if(self.separatorLineView)
            [self.separatorLineView setHidden:YES];
       
    }
    else
    {

        self.contentView.backgroundColor = menuBackgroundColor;
        self.label.backgroundColor = menuBackgroundColor;
        self.label.textColor = menuLabelColor;
        
        if(self.separatorLineView)
            [self.separatorLineView setHidden:NO];
      
    }
    
}



@end
