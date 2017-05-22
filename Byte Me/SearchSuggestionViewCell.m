//
//  SearchSuggestionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 29/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "SearchSuggestionViewCell.h"
#import "Constants.h"

@interface SearchSuggestionViewCell ()
@property (nonatomic) UIView *separator;
@end

@implementation SearchSuggestionViewCell

- (void)awakeFromNib {
   
    [self.label setHidden:YES];
    [self.label setTextColor:searchSuggestionLabelColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:searchSuggestionLabelFontSize]];
    
    [self.icon setHidden:YES];
    [self.iconRight setHidden:YES];
    
    [self.labelAction setHidden:YES];
    [self.labelMessage setHidden:YES];

    // separator
    if(!self.separator)
    {
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(searchSuggestionMargin, searchSuggestionCelltHeight-menuSeparatorThickness,SCREEN_WIDTH-(2.0f*searchSuggestionMargin), menuSeparatorThickness)];
        self.separator.backgroundColor = menuSeparatorColor;
        [self addSubview:self.separator];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setLabelText:(NSString *)text
{
    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [self setBackgroundColor:searchSuggestionBackgroundColor];

    [self.label setText:text];
    [self.label setTextColor:searchSuggestionLabelColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:searchSuggestionLabelFontSize]];
    [self.label setHidden:NO];

    
    [self.labelAction setHidden:YES];
    [self.labelMessage setHidden:YES];
    
    [self.icon setHidden:YES];
    [self.iconRight setHidden:YES];
    
    [self.separator setHidden:NO];
    
    self.labelLeftMarginConstraint.constant = 10.0f;
    self.labelActionLeftMarginConstraint.constant = 10.0f;
    self.iconTopMarginConstraint.constant = 0.0f;

}

-(void) setTipLabelText:(NSString *)text actionText:(NSString *)actionText icon:(NSString*) image
{
    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [self setBackgroundColor:searchSuggestionBackgroundColor];

    [self.label setHidden:YES];

    [self.labelMessage setText:text];
    [self.labelMessage setTextColor:searchSuggestionHeaderIconColor];
    [self.labelMessage setFont:[UIFont fontWithName:@"Quicksand-Bold" size:searchSuggestionLabelFontSize]];
    [self.labelMessage setHidden:NO];

    [self.labelAction setText:actionText];
    [self.labelAction setTextColor:linkTintColor];
    [self.labelAction setFont:[UIFont fontWithName:@"Quicksand-Bold" size:searchSuggestionLabelFontSize]];
    [self.labelAction setHidden:NO];

    [self.icon setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.icon setTintColor:linkTintColor];
    [self.icon setHidden:NO];
    
    [self.iconRight setHidden:YES];
    
    [self.separator setHidden:YES];
    
    self.labelLeftMarginConstraint.constant = 10.0f;
    self.labelActionLeftMarginConstraint.constant = self.icon.frame.size.width + 6.0f;
    self.iconTopMarginConstraint.constant = 15.0f;
    
}

-(void) setLabelText:(NSString *)text icon:(NSString*) image
{
    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [self setBackgroundColor:searchSuggestionBackgroundColor];

    [self.label setText:text];
    [self.label setTextColor:searchSuggestionLabelColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:searchSuggestionLabelFontSize]];
    [self.label setHidden:NO];

    
    [self.labelAction setHidden:YES];
    [self.labelMessage setHidden:YES];

    [self.icon setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.icon setTintColor:searchSuggestionLabelColor];
    [self.icon setHidden:NO];

    [self.iconRight setImage:[[UIImage imageNamed:@"key_arrow_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.iconRight setTintColor:categorySeparatorColor];
    [self.iconRight setHidden:NO];

    [self.separator setHidden:NO];
    
    self.labelLeftMarginConstraint.constant = self.icon.frame.size.width + 6.0f;
    self.labelActionLeftMarginConstraint.constant = 10.0f;
    self.iconTopMarginConstraint.constant = 0.0f;
}

-(void) setHeaderLabelText:(NSString *)text
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:searchSuggestionHeaderBackgroundColor];

    [self.label setText:text];
    [self.label setTextColor:searchSuggestionHeaderIconColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:searchSuggestionLabelFontSize]];
    [self.label setHidden:NO];

    
    [self.labelAction setHidden:YES];
    [self.labelMessage setHidden:YES];
    
    [self.icon setHidden:YES];
    [self.iconRight setHidden:YES];
    
    [self.separator setHidden:YES];
    
    self.labelLeftMarginConstraint.constant = 10.0f;
    self.labelActionLeftMarginConstraint.constant = 10.0f;
    self.iconTopMarginConstraint.constant = 0.0f;


}

-(void) setHeaderLabelText:(NSString *)text icon:(NSString*) image
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:searchSuggestionHeaderBackgroundColor];

    [self.label setText:text];
    [self.label setTextColor:searchSuggestionHeaderIconColor];
    [self.label setFont:[UIFont fontWithName:@"Quicksand-Bold" size:searchSuggestionLabelFontSize]];
    [self.label setHidden:NO];

    
    [self.labelAction setHidden:YES];
    [self.labelMessage setHidden:YES];
    
    [self.icon setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.icon setTintColor:searchSuggestionHeaderIconColor];
    [self.icon setHidden:NO];

    [self.iconRight setHidden:YES];
    
    [self.separator setHidden:YES];
    
    self.labelLeftMarginConstraint.constant = self.icon.frame.size.width + 8.0f;
    self.labelActionLeftMarginConstraint.constant = 10.0f;
    self.iconTopMarginConstraint.constant = 0.0f;
}

@end
