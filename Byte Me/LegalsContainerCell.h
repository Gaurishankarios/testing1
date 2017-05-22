//
//  LegalsContainerCell.h
//  Byte Me
//
//  Created by Leandro Marques on 02/02/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegalsContainerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *textView;
-(void) setText:(NSString *)text;

@end
