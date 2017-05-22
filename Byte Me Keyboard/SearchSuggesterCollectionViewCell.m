//
//  SearchSuggesterCollectionViewCell.m
//  Byte Me
//
//  Created by Leandro Marques on 18/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "SearchSuggesterCollectionViewCell.h"
#import "Constants.h"


@interface SearchSuggesterCollectionViewCell ()
@property (nonatomic) IBOutlet UILabel *label;
@end


@implementation SearchSuggesterCollectionViewCell


-(void) awakeFromNib
{
    
    [self.layer setBackgroundColor:[keyboardImageKeyBackgroundColor CGColor]];
    self.layer.cornerRadius = keyboardKeyBorderRadius;
    self.layer.masksToBounds = YES;
    [self.label setFont:[UIFont systemFontOfSize:keyboardSuggesterCellFontSize]];

    [self.label setTextColor:keyboardKeyLabelColor];

}

-(void) setLabelWithString:(NSString*) string
{
    [self.label setText:string];
    //self.label.numberOfLines = 0;
    //self.label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.label sizeToFit];
}

-(void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        //[self.label setTextColor:keyboardImageKeyBackgroundColor];
        [self.layer setBackgroundColor:[globalBackgroundColor CGColor]];
    }
    else
    {
        //[self.label setTextColor:keyboardKeyLabelColor];
        [self.layer setBackgroundColor:[keyboardImageKeyBackgroundColor CGColor]];
    }
}

@end
