//
//  SearchSuggestionViewCell.h
//  Byte Me
//
//  Created by Leandro Marques on 29/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSuggestionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelAction;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *iconRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelActionLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopMarginConstraint;

-(void) setLabelText:(NSString *)text;
-(void) setLabelText:(NSString *)text icon:(NSString*) image;
-(void) setHeaderLabelText:(NSString *)text;
-(void) setHeaderLabelText:(NSString *)text icon:(NSString*) image;
-(void) setTipLabelText:(NSString *)text actionText:(NSString *)actionText icon:(NSString*) image;
@end
