//
//  FooterContainerCell.m
//  Byte Me
//
//  Created by Leandro Marques on 21/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "FooterContainerCell.h"
#import "Constants.h"

@implementation FooterContainerCell

- (void)awakeFromNib {
    // Initialization code
    //[self setSelectionStyle:UITableViewCellSelectionStyleNone];

    [self.label setTextColor:footerLabelColor];
    [self setBackgroundColor:footerBackgroundColor];
    
    [self.arrow setTextColor:footerLabelColor];
    [self.arrow setFont:[UIFont fontWithName:@"Quicksand-Bold" size:footerArrowFontSize]];
    [self setBackgroundColor:footerBackgroundColor];
    [self.arrow setText:[@">" uppercaseString]];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)]];
}

- (void)tapCell:(UITapGestureRecognizer *)inGestureRecognizer
{

    if(self.delegate)
        [self.delegate showMyBytes];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
