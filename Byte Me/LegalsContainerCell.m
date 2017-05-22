//
//  LegalsContainerCell.m
//  Byte Me
//
//  Created by Leandro Marques on 02/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "LegalsContainerCell.h"
#import "Constants.h"

@implementation LegalsContainerCell

- (void)awakeFromNib {
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setText:(NSString *)text
{
    [self.textView setText:text];
    [self.textView setTextColor:copyTextColor];
    [self.textView setFont:[UIFont fontWithName:@"Quicksand-Regular" size:legalsFontSize]];
}

@end
