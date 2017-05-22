//
//  JKSubTableViewCellCell.m
//  ExpandTableView
//
//  Created by Jack Kwok on 7/5/13.
//  Copyright (c) 2013 Jack Kwok. All rights reserved.
//

#import "JKSubTableViewCellCell.h"
#import "Constants.h"
#import "Mixpanel.h"

@interface JKSubTableViewCellCell ()
@property (nonatomic) UIView *separatorLineView;
@end

@implementation JKSubTableViewCellCell
@synthesize titleLabel, iconImage, selectionIndicatorImg, sectionId;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [[self contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    if(!self)
        return self;
    
    self.contentView.backgroundColor = menuSubBackgroundColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = menuSubBackgroundColor;
    titleLabel.opaque = NO;
    titleLabel.textColor = menuSubLabelColor;
    self.titleLabel.textColor = menuSubLabelColor;

    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    
    self.selectionIndicatorImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:selectionIndicatorImg];
    
    /*
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(menuSeparatorMargin, self.contentView.frame.size.height-menuSeparatorThickness, self.contentView.frame.size.width-menuSeparatorMargin, menuSeparatorThickness)];
    separatorLineView.backgroundColor = menuSeparatorColor;
    [self.contentView addSubview:separatorLineView];
     */
    /*
    if(!self.separatorLineView)
    {
        float margin = 16.0f;
        self.separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(margin, self.contentView.frame.size.height-menuSeparatorThickness, 300.0f - margin*2.0f, menuSeparatorThickness)];
        self.separatorLineView.backgroundColor = menuBackgroundColor;
        [self.contentView addSubview:self.separatorLineView];
    }
*/

    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setupDisplay];
}

- (void) setupDisplay {
    
    CGRect contentRect = [self bounds];
    CGFloat contentAreaWidth = self.contentView.bounds.size.width;
    CGFloat contentAreaHeight = self.contentView.bounds.size.height;
    CGFloat checkMarkHeight = 0.0;
    CGFloat checkMarkWidth = 0.0;
    CGFloat iconHeight = 0.0; //  set this according to icon
    CGFloat iconWidth = 0.0;
    
    if (self.iconImage.image) {
        iconWidth = MIN(contentAreaWidth, self.iconImage.image.size.width);
        iconHeight = MIN(contentAreaHeight, self.iconImage.image.size.height);
    }
    if (self.selectionIndicatorImg.image) {
        checkMarkWidth = MIN(contentAreaWidth, self.selectionIndicatorImg.image.size.width);
        checkMarkHeight = MIN(contentAreaHeight, self.selectionIndicatorImg.image.size.height);
    }
    
    CGFloat sidePadding = 16.0;
    CGFloat icon2LabelPadding = -6.0f;
    CGFloat checkMarkPadding = 16.0;
    [self.contentView setAutoresizesSubviews:YES];
    
    self.iconImage.frame = CGRectMake(sidePadding, (contentAreaHeight - iconHeight)/2, iconWidth, iconHeight);
    //self.iconImage.backgroundColor = [UIColor blueColor];
    
    CGFloat XOffset = iconWidth + sidePadding + icon2LabelPadding;
    
    CGFloat labelWidth = contentAreaWidth - XOffset - checkMarkWidth - checkMarkPadding;
    self.titleLabel.frame = CGRectMake(XOffset, 0, labelWidth, contentAreaHeight);

    //self.titleLabel.backgroundColor = [UIColor purpleColor];
    //self.selectionIndicatorImg.backgroundColor = [UIColor yellowColor];
    
    self.selectionIndicatorImg.frame = CGRectMake(contentAreaWidth - checkMarkWidth - checkMarkPadding,
                                                      (contentRect.size.height/2)-(checkMarkHeight/2),
                                                      checkMarkWidth,
                                                      checkMarkHeight);
    
    //self.titleLabel.textColor = menuSubLabelColor;
    
    
}

- (void)setCellForegroundColor:(UIColor *) foregroundColor {
    //titleLabel.textColor = foregroundColor;
}

- (void)setCellBackgroundColor:(UIColor *) backgroundColor {
    //self.contentView.backgroundColor = menuSubBackgroundColor;
    //self.titleLabel.backgroundColor = menuSubBackgroundColor;

}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(selected)
    {
        //NSLog(@"setSelected %@", self.titleLabel.text);
        
        // tracking
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Sidenav Item Clicked" properties:@{
                                                             @"Component": @"Container",
                                                             @"Item":self.titleLabel.text
                                                             }];
    }
    
    [super setSelected:selected animated:animated];
    if(selected)
        [self highlightCell:selected];
    
  
}

-(void) highlightCell:(BOOL) selected
{
    if(selected)
    {
        self.contentView.backgroundColor = linkTintColor;
        self.titleLabel.backgroundColor = linkTintColor;
        self.titleLabel.textColor = menuSubBackgroundColor;
        
    }
    else
    {
        self.contentView.backgroundColor = menuSubBackgroundColor;
        self.titleLabel.backgroundColor = menuSubBackgroundColor;
        self.titleLabel.textColor = menuSubLabelColor;
        
    }

}


@end
