//
//  PageViewController.m
//  Byte Me
//
//  Created by Leandro Marques on 28/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) setTitleLabel:(NSString *)t description:(NSString *)d colour:(UIColor*)c
{    
    NSDictionary *titleDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Quicksand-Bold" size:30.0] forKey:NSFontAttributeName];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:t attributes: titleDict];
    NSDictionary *descDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Quicksand-Bold" size:18.0] forKey:NSFontAttributeName];
    
    NSMutableAttributedString *desc = [[NSMutableAttributedString alloc]initWithString: d attributes:descDict];
    [title appendAttributedString:desc];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    [title addAttribute:NSForegroundColorAttributeName value:c range:(NSMakeRange(0, title.length))];
    [title addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:(NSMakeRange(0, title.length))];
    
    _label.attributedText = title;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
