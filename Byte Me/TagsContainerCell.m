//
//  TagsContainerCell.m
//  Byte Me
//
//  Created by Leandro Marques on 18/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "TagsContainerCell.h"
#import "Constants.h"

@interface TagsContainerCell ()
@property (nonatomic, strong) NSMutableArray *tagModelArray;
@property (nonatomic, weak) IBOutlet UILabel *similarLabel;

@property (nonatomic, weak) UITextField    *addTagField;
@end


@implementation TagsContainerCell

- (void)awakeFromNib {
    // Initialization code
    [self.tagList setAutomaticResize:YES];

    [self initLabel];
    
}

-(void) initLabel
{
    [self.similarLabel setTextColor:similarLabelColor];
    [self.similarLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:15.0f]];
    [self.similarLabel setText:@"Similar"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void) initTagsWithObject:(NSDictionary*) object delegate:(id) delegate;
{
   // NSLog(@"initTagsWithObject %@", object);
   
    NSNumber *tag_list_total = [object objectForKey:@"total"];
    
    self.tagModelArray = [[NSMutableArray alloc] init];
    if([tag_list_total integerValue] > 0)
    {
        NSDictionary *tag_list_items = [object objectForKey:@"items"];
        if(tag_list_items)
        {
            for (int i=1; i <= [tag_list_total intValue]; i++)
            {
                NSString *item = [NSString stringWithFormat:@"%d",i];
                NSDictionary *tag_item = [tag_list_items objectForKey:item];
                [self.tagModelArray addObject:tag_item];
            }
            
        }
    }
      
    [self.tagList setTags:self.tagModelArray];
    [self.tagList setTagDelegate:delegate];
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
*/
@end
