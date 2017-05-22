//
//  SettingsManager.m
//  Byte Me
//
//  Created by Leandro Marques on 01/07/2014.
//  Copyright (c) 2014 NetDevo Limited. All rights reserved.
//

#import "SettingsManager.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "DecodedString.h"
#import "Mixpanel.h"
#import "RequestQueue.h"

@interface SettingsManager ()
@property (nonatomic) BOOL firstScreen;
@end


@implementation SettingsManager
@synthesize currentPageId, hasTutorialDone;

#pragma mark Singleton Methods

+ (id)sharedSettings {
    static SettingsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        [self loadSettings];
        
        
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                          object:nil
                                                           queue:mainQueue
                                                      usingBlock:^(NSNotification *note) {
                                                          // executes after screenshot
                                                          // tracking
                                                          Mixpanel *mixpanel = [Mixpanel sharedInstance];
                                                          [mixpanel track:@"Screenshot Taken" properties:@{
                                                                                                       @"Component": @"Container"
                                                                                                       }];

                                                      }];

    }
    return self;
}


- (void) saveSettings
{
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.RPRAdvisoryltd.Audio"];

    [prefs setBool:YES forKey:@"firstRun"];
    [prefs setBool:self.hasTutorialDone forKey:@"hasTutorialDone"];
    [prefs setObject:self.bytes forKey:@"myBytes"];
    [prefs setObject:self.bytesEnabled forKey:@"bytesEnabled"];
    [prefs setObject:self.bytesFrequent forKey:@"bytesFrequent"];
    [prefs setObject:self.savedSearches forKey:@"savedSearches"];
    [prefs synchronize];
}

- (void) loadSettings
{
    
    [RequestQueue mainQueue].maxConcurrentRequestCount = 32;
    
    self.firstScreen = YES;
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.RPRAdvisoryltd.Audio"];

    if([prefs boolForKey:@"firstRun"])
    {
        self.hasTutorialDone = [prefs boolForKey:@"hasTutorialDone"];
        self.bytes = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"myBytes"] copyItems:YES];
        self.bytesEnabled = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"bytesEnabled"] copyItems:YES];
        self.bytesFrequent = [[NSMutableDictionary alloc] initWithDictionary:[prefs objectForKey:@"bytesFrequent"] copyItems:YES];
        self.savedSearches = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"savedSearches"] copyItems:YES];

    }
    else
        [self setDefaultSettings];
    
}

-(BOOL) addNewByte:(NSDictionary *)byte
{
    if(![self isByteAdded:byte])
    {   NSMutableDictionary *newByte = [byte mutableCopy];
        int timestamp = [[NSDate date] timeIntervalSince1970];
        [newByte setObject:[NSNumber numberWithInt:timestamp] forKey:@"date_added"];
        [self.bytes setValue:newByte forKey:[byte objectForKey:@"id"]];
        [self saveSettings];
        return YES;
    }
    else
        return NO;
}

-(BOOL) enableByte:(NSDictionary *)byte
{
    if([self isByteAdded:byte])
    {
        if(![self isByteEnabled:byte])
        {
            // tracking
            NSString *title = [byte objectForKey:@"title"];
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"Byte Added" properties:@{
                                                         @"Component": @"Container",
                                                         @"Byte":[NSString stringWithFormat: @"Byte %@",title]
                                                         }];
            
            [self.bytesEnabled setValue:byte forKey:[byte objectForKey:@"id"]];
            [self saveSettings];
            return YES;
        }
        return NO;

    }
    else
        return NO;
}

-(BOOL) disableByte:(NSDictionary *)byte
{
    if([self isByteAdded:byte])
    {
        if([self isByteEnabled:byte])
        {
            // tracking
            NSString *title = [byte objectForKey:@"title"];
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"Byte Removed" properties:@{
                                                         @"Component": @"Container",
                                                         @"Byte":[NSString stringWithFormat: @"Byte %@",title]
                                                         }];

            
            [self.bytesEnabled removeObjectForKey:[byte objectForKey:@"id"]];
            [self saveSettings];
            return YES;
        }
        return NO;
        
    }
    else
        return NO;
}

-(BOOL) isByteAdded:(NSDictionary *) byte
{
    for(NSDictionary *d in self.bytes)
    {
        if([d isEqual:[byte objectForKey:@"id"]])
            return YES;
    }
    
    return NO;
}

-(BOOL) isByteEnabled:(NSDictionary *) byte
{
    for(NSDictionary *d in self.bytesEnabled)
    {
        if([d isEqual:[byte objectForKey:@"id"]])
            return YES;
    }
    
    return NO;
}


-(BOOL) isFrenquentByteEnabled:(NSDictionary *) byte
{
    for(NSDictionary *d in self.bytesFrequent)
    {
        if([d isEqual:[byte objectForKey:@"id"]])
            return YES;
    }
    
    return NO;
}


-(BOOL) addNewFrequentByte:(NSDictionary *)byte
{
    if(![self isFrenquentByteEnabled:byte])
    {   NSMutableDictionary *newByte = [byte mutableCopy];
        int timestamp = [[NSDate date] timeIntervalSince1970];
        [newByte setObject:[NSNumber numberWithInt:timestamp] forKey:@"date_added"];
        [self.bytesFrequent setValue:newByte forKey:[byte objectForKey:@"id"]];
        
        int limit = 10;
        // check limit of autoremove overflow
        if((int)[self.bytesFrequent count] > limit)
        {
            // sort bytes by added
            NSArray *bytes_frequent_sorted_reverse = [self.bytesFrequent keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
                
                if ([[obj1 objectForKey:@"date_added"]integerValue] > [[obj2 objectForKey:@"date_added"] integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([[obj1 objectForKey:@"date_added"] integerValue] < [[obj2 objectForKey:@"date_added"] integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            for (int i=0; i < limit; i++)
            {
                int iSorted = [[bytes_frequent_sorted_reverse objectAtIndex:i] intValue];
                NSString *item = [NSString stringWithFormat:@"%d",iSorted];
                [self.bytesFrequent removeObjectForKey:item];
            }
        }
        [self saveSettings];

        
        return YES;
    }
    else
        return NO;
}

-(int) getBytesAddedCount
{
    return (int)[self.bytes count];
}

-(int) getBytesEnabledCount
{
    return (int)[self.bytesEnabled count];
}

-(NSDictionary*) getBytes
{
    NSDictionary *b = [NSDictionary dictionaryWithDictionary:self.bytes];
    return b;
}

-(void) setDefaultSettings
{
    self.bytes = [[NSMutableDictionary alloc] init];
    self.bytesEnabled = [[NSMutableDictionary alloc] init];
    self.bytesFrequent = [[NSMutableDictionary alloc] init];
    self.savedSearches = [[NSMutableArray alloc] init];
    self.hasTutorialDone = NO;
    
    [self saveSettings];
}

-(BOOL) isFirstScreen
{
    BOOL r = self.firstScreen;
    
    if(self.firstScreen)
        self.firstScreen = NO;
        
    return r;
}


-(void) loadStockBytes
{
   // NSLog(@"loadStockBytes ");
    
    NSURL *tagsStockURL = [NSURL URLWithString:[API_URL stringByAppendingString:@"stock.json"]];
   // NSLog(@"tagsStockURL %@",tagsStockURL);
    
    NSError *errorLoad = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:tagsStockURL options:NSDataReadingUncached error:&errorLoad];
    
    if (errorLoad) {
        NSLog(@"%@", [errorLoad localizedDescription]);
    } else {
        //NSLog(@"Data has loaded successfully.");
        
        NSError *errorParse = nil;
        NSDictionary *dataDictionary = [NSJSONSerialization
                                        JSONObjectWithData:jsonData options:0 error:&errorParse];
        
        if (errorParse) {
            NSLog(@"%@", [errorParse localizedDescription]);
        } else {
        
            NSDictionary *data = [dataDictionary objectForKey:@"data"];
            NSDictionary *stock_list = [data objectForKey:@"items"];
            NSNumber *stock_list_total = [data objectForKey:@"total"];
            
            if(data)
            {
                // NSLog(@"data ok");
                
                if(stock_list)
                {
                     //NSLog(@"stock_list ok");
                    
                    if(stock_list_total)
                    {
                          //NSLog(@"stock_list_total ok");
                        
                        if([stock_list_total intValue] > 0)
                        {
                            for (NSString *i in stock_list)
                            {
                                NSMutableDictionary *item = [stock_list objectForKey:i];
                                //NSLog(@"item %@",item);
                                
                                if([self addNewByte:item])
                                    [self enableByte:item];
                            }

                       }
                       // else NSLog(@"stock_list_total = 0");
                    }
                   // else NSLog(@"no stock_list_total");
                }
                //else NSLog(@"no stock_list");
                
            }
           // else NSLog(@"no data");
            
        }
    }
        
}


-(NSMutableArray *) loadTags
{
    if(self.tags)
        return self.tags;
    else
    {
        self.tags = [[NSMutableArray alloc] init];
        
        NSLog(@"loadTags ");
        
        NSURL *tagsDataURL = [NSURL URLWithString:[API_URL stringByAppendingString:@"tags.json"]];
        //NSLog(@"tagsDataURL %@",tagsDataURL);
        
        NSError *errorLoad = nil;
        NSData *jsonData = [NSData dataWithContentsOfURL:tagsDataURL options:NSDataReadingUncached error:&errorLoad];
        
        if (errorLoad) {
            NSLog(@"%@", [errorLoad localizedDescription]);
        } else {
            //NSLog(@"Data has loaded successfully.");
            
            NSError *errorParse = nil;
            NSDictionary *dataDictionary = [NSJSONSerialization
                                            JSONObjectWithData:jsonData options:0 error:&errorParse];
            
            if (errorParse) {
                NSLog(@"%@", [errorParse localizedDescription]);
            } else {
                /* tags model
                 data
                    version
                    items
                        id
                            name
                 
                    total
                 */
                
                NSDictionary *data = [dataDictionary objectForKey:@"data"];
                NSDictionary *tags_list = [data objectForKey:@"items"];
                NSNumber *tags_list_total = [data objectForKey:@"total"];
                
                if(data)
                {
                    // NSLog(@"data ok");
                    
                    if(tags_list)
                    {
                        // NSLog(@"tags_list ok");
                        
                        if(tags_list_total)
                        {
                            //  NSLog(@"tags_list_total ok");
                            
                            if([tags_list_total intValue] > 0)
                            {
                                for (int i=1; i <= [tags_list_total intValue]; i++)
                                {
                                    NSString *item = [NSString stringWithFormat:@"%d",i];
                                    
                                    NSString *tag_item = [DecodedString decodedStringWithString:[[tags_list objectForKey:item] objectForKey:@"name"]];
                                    [self.tags addObject:tag_item];
                                }                            }
                            else
                            {
                                NSLog(@"tags_list_total = 0");
                            }
                        }
                        else
                        {
                            NSLog(@"no tags_list_total");
                        }
                    }
                    else
                    {
                        NSLog(@"no tags_list");
                    }
                }
                else
                {
                    NSLog(@"no data");
                }
                
            }
        }
        
        return self.tags;
    }
}


-(NSMutableArray *) loadActiveTags
{
    [self loadSettings];
    
    NSMutableArray *tagsProcessed = [[NSMutableArray alloc] init];
  
    if((int)[self.bytesEnabled count] > 0)
    {
        for(NSDictionary *b in self.bytesEnabled)
        {
            
            NSDictionary *byte = [self.bytesEnabled objectForKey:b];
            NSDictionary *tags = [byte objectForKey:@"tags"];
            NSNumber *tags_total = [tags objectForKey:@"total"];
            
            //NSLog(@"byte %@",byte);
            
            if((int)[tags_total intValue] > 0)
            {
                NSDictionary *tag_list_items = [tags objectForKey:@"items"];
                if(tag_list_items)
                {
                    for (int i=1; i <= [tags_total intValue]; i++)
                    {
                        NSString *item = [NSString stringWithFormat:@"%d",i];
                        NSDictionary *tag_item = [tag_list_items objectForKey:item];
                        if(![self isTagAlreadyAdded:[tag_item objectForKey:@"name"] list:tagsProcessed])
                            [tagsProcessed addObject:[tag_item objectForKey:@"name"]];
                    }
                }
            }
        }
    }
    
    return tagsProcessed;
}

-(NSMutableDictionary *) loadActiveBytes
{
    [self loadSettings];
    
    NSMutableDictionary *bytesProcessed = [[NSMutableDictionary alloc] init];
    
    if((int)[self.bytesEnabled count] > 0)
    {
        for(NSString *b in self.bytesEnabled)
        {
            NSMutableDictionary *byte = [[self.bytesEnabled objectForKey:b] mutableCopy];
            NSDictionary *tags = [byte objectForKey:@"tags"];
            NSNumber *tags_total = [tags objectForKey:@"total"];
            NSMutableArray *tags_array = [[NSMutableArray alloc] init];
            
            if((int)[tags_total intValue] > 0)
            {
                NSDictionary *tag_list_items = [tags objectForKey:@"items"];
                if(tag_list_items)
                {
                    for (int i=1; i <= [tags_total intValue]; i++)
                    {
                        NSString *item = [NSString stringWithFormat:@"%d",i];
                        NSDictionary *tag_item = [tag_list_items objectForKey:item];
                        NSDictionary *new_tag = [NSDictionary dictionaryWithObject:[tag_item objectForKey:@"name"] forKey:@"name"];
                        [tags_array addObject:new_tag];                    }
                }
            }
            
            [byte setValue:tags_array forKey:@"tags"];
            [bytesProcessed setValue:byte forKey:b];
        }
    }
    
    return bytesProcessed;
}


-(BOOL) isTagAlreadyAdded:(NSString*)tag list:(NSMutableArray*) list
{
    for (NSString *t in list)
    {
        if([t isEqualToString:tag])
            return YES;
    }
    
    return NO;
}

-(BOOL) addSearchTerm:(NSString*)searchTerm
{
    for(NSString *s in self.savedSearches)
        if([s isEqualToString:searchTerm])
            return NO;
    
    [self.savedSearches insertObject:searchTerm atIndex:0];
    [self saveSettings];
    
    return YES;
}

-(void) clearSavedSearches
{
    self.savedSearches = nil;
    self.savedSearches = [[NSMutableArray alloc] init];
    [self saveSettings];
}


-(UIColor*) getColourFromObject:(NSDictionary*) object defaultColout:(UIColor*) defaultColout
{
    return [self getKeyColourFromObject:object key:@"colour" defaultColout:defaultColout];
}

-(UIColor*) getBackgroundFromObject:(NSDictionary*) object defaultColout:(UIColor*) defaultColout
{
    return [self getKeyColourFromObject:object key:@"background" defaultColout:defaultColout];
}

-(UIColor*) getKeyColourFromObject:(NSDictionary*) object key:(NSString*)key defaultColout:(UIColor*) defaultColout
{
    NSString *colour = [object objectForKey:key];
    
    if(colour)
    {
        if([colour isEqual:[NSNull null]] || [colour isEqualToString:@"<null>"] || [colour isEqualToString:@"null"] || [colour isEqualToString:@""])
            return defaultColout;
        else
        {
            NSArray *colourSplit1 = [colour componentsSeparatedByString: @"("];
            NSArray *colourSplit2 = [[colourSplit1 objectAtIndex:1] componentsSeparatedByString: @")"];
            NSArray *colourSplit3 = [[colourSplit2 objectAtIndex:0] componentsSeparatedByString: @","];
            
            float colourR = [[colourSplit3 objectAtIndex:0] floatValue];
            float colourG = [[colourSplit3 objectAtIndex:1] floatValue];
            float colourB = [[colourSplit3 objectAtIndex:2] floatValue];
            float colourA = 1.0f;//[[colourSplit3 objectAtIndex:3] floatValue];
            
            return [UIColor colorWithRed:colourR/255.0f
                                   green:colourG/255.0f
                                    blue:colourB/255.0f
                                   alpha:colourA];
        }
    }
    else
        return defaultColout;
}


-(NSString*)getRGBAfromUIColor:(UIColor*) color
{
    CGColorRef colorRef = color.CGColor;
    // rgba(230,30,42,1)
    return [NSString stringWithFormat:@"rgba(%f,%f,%f,%f)",[CIColor colorWithCGColor:colorRef].red*255.0f ,[CIColor colorWithCGColor:colorRef].green*255.0f , [CIColor colorWithCGColor:colorRef].blue*255.0f ,[CIColor colorWithCGColor:colorRef].alpha];

}

-(NSMutableArray *) getFormatedBytesSearchResultsWithArray:(NSMutableArray*)array
{
    NSMutableArray *bytesProcessed = [[NSMutableArray alloc] init];
   
    if((int)[array count] == 0)
    {
        // no items
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:@"No Results Found\nCheck the Byte.Me store for more" forKey:@"title"];
        [data setObject:@"-2" forKey:@"id"];
        [data setObject:@"message" forKey:@"type"];
        [data setObject:[self getRGBAfromUIColor:myBytesColor]  forKey:@"colour"];
        [data setObject:[self getRGBAfromUIColor:myBytesBackgroundColor]  forKey:@"background"];
        NSMutableDictionary *newCategory = [self addNewCategoryWithData:data];
        [bytesProcessed addObject:newCategory];
    }
    else
    {
        for(NSDictionary *byte in array)
        {
            [self addToSearchReultsWithByte:byte results:bytesProcessed];
        }
    }
    
    return bytesProcessed;
}

-(NSMutableArray *) getBytesEnabledForKeyboard
{
    [self loadSettings];
    
    NSMutableArray *bytesProcessed = [[NSMutableArray alloc] init];

    // frequenlty used
    // categories
        // subcategories
            // bytes
        // bytes
    
   // NSLog(@"self.bytesEnabled %@",self.bytesEnabled);
    
    // bytesProcessed model
    // main @[@"title", @"cover", @"ext", title color, bkg color center,  bkg color edge, @[]]
    // sub and byte @[@"title", @"cover", @"ext", @"video", title color, @[]]
    
    /*
     keyboard model
        id
        title
        cover1x
        cover2x
        cover3x
        colour
        background
        children (bytes or categories)
            items
                item
                    id
                    path_id
                    title
                    cover1x
                    cover2x
                    cover3x
                    video
                    colour (same as caetgory)
                    colour
                    background
                    children (bytes or categories)
                        items
                        total
            total
     */

    if((int)[self.bytesEnabled count] == 0)
    {
        // no items
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:@"No Active Bytes" forKey:@"title"];
        [data setObject:@"-2" forKey:@"id"];
        [data setObject:@"category" forKey:@"type"];
        [data setObject:[self getRGBAfromUIColor:myBytesColor]  forKey:@"colour"];
        [data setObject:[self getRGBAfromUIColor:myBytesBackgroundColor]  forKey:@"background"];
        NSMutableDictionary *newCategory = [self addNewCategoryWithData:data];
        [bytesProcessed addObject:newCategory];
    }
    else
    {
        
        NSMutableDictionary *dataFrequent = [[NSMutableDictionary alloc] init];
        [dataFrequent setObject:@"Recently Used" forKey:@"title"];
        [dataFrequent setObject:@"0" forKey:@"id"];
        [dataFrequent setObject:@"category" forKey:@"type"];
        [dataFrequent setObject:[self getRGBAfromUIColor:recentBytesColor]  forKey:@"colour"];
        [dataFrequent setObject:[self getRGBAfromUIColor:recentBytesBackgroundColor]  forKey:@"background"];
        
        NSMutableDictionary *frequentCategory = [self addNewCategoryWithData:dataFrequent];
        
        NSMutableArray *newFrequentChildren = [[NSMutableArray alloc] init];
        
        [self addFrequentBytesWithChildren:newFrequentChildren];
        
        [frequentCategory setObject:newFrequentChildren  forKey:@"children"];
        [bytesProcessed addObject:frequentCategory];

        for(NSDictionary *b in self.bytesEnabled)
        {
            NSDictionary *byte = [self.bytesEnabled objectForKey:b];
            [self addCategoryWithByte:byte proccessedArray:bytesProcessed];
        }
        /*
        NSMutableDictionary *dataSettings = [[NSMutableDictionary alloc] init];
        [dataSettings setObject:@"My Settings" forKey:@"title"];
        [dataSettings setObject:@"-1" forKey:@"id"];
        [dataSettings setObject:@"category" forKey:@"type"];
        [dataSettings setObject:[self getRGBAfromUIColor:myBytesColor]  forKey:@"colour"];
        [dataSettings setObject:[self getRGBAfromUIColor:myBytesBackgroundColor]  forKey:@"background"];
        
        NSMutableDictionary *newCategorySettings = [self addNewCategoryWithData:dataSettings];
        
        //NSLog(@"children does not exist");
        NSMutableArray *newSettingsChildren = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dataSettingsCover = [[NSMutableDictionary alloc] init];
        [dataSettingsCover setObject:@"My Settings" forKey:@"title"];
        [dataSettingsCover setObject:@"-1" forKey:@"id"];
        [dataSettingsCover setObject:@"category" forKey:@"type"];
        [dataSettingsCover setObject:[self getRGBAfromUIColor:myBytesColor]  forKey:@"colour"];
        [dataSettingsCover setObject:[self getRGBAfromUIColor:myBytesBackgroundColor]  forKey:@"background"];
        
        [self addToChildrenCoverWithData:dataSettingsCover children:newSettingsChildren];

        
        NSMutableDictionary *dataMyBytes = [[NSMutableDictionary alloc] init];
        [dataMyBytes setObject:@"My Bytes" forKey:@"title"];
        [dataMyBytes setObject:@"-1" forKey:@"id"];
        [dataMyBytes setObject:@"category" forKey:@"type"];
        [dataMyBytes setObject:[self getRGBAfromUIColor:myBytesColor] forKey:@"colour"];
        [dataMyBytes setObject:[self getRGBAfromUIColor:myBytesBackgroundColor] forKey:@"background"];

        [self addToChildrenCoverWithData:dataMyBytes children:newSettingsChildren];
        
        [newCategorySettings setObject:newSettingsChildren  forKey:@"children"];
        [bytesProcessed addObject:newCategorySettings];
         */
    }
  
   // NSLog(@"bytesProcessed %@",bytesProcessed);
    

    // my bytes (link back) TBC
    return bytesProcessed;
}

-(void) addFrequentBytesWithChildren:(NSMutableArray*)children
{
    NSMutableDictionary *dataFrequentCover = [[NSMutableDictionary alloc] init];
    [dataFrequentCover setObject:@"Recently Used" forKey:@"title"];
    [dataFrequentCover setObject:@"0" forKey:@"id"];
    [dataFrequentCover setObject:@"category" forKey:@"type"];
    [dataFrequentCover setObject:[self getRGBAfromUIColor:recentBytesColor]  forKey:@"colour"];
    [dataFrequentCover setObject:[self getRGBAfromUIColor:recentBytesBackgroundColor]  forKey:@"background"];
    [dataFrequentCover setObject:@"Recently Used"  forKey:@"path"];
    
    [self addToChildrenCoverWithData:dataFrequentCover children:children];
    
    // sort bytes by added
    NSArray *bytes_frequent_sorted_reverse = [self.bytesFrequent keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        if ([[obj1 objectForKey:@"date_added"]integerValue] > [[obj2 objectForKey:@"date_added"] integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[obj1 objectForKey:@"date_added"] integerValue] < [[obj2 objectForKey:@"date_added"] integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSArray* bytes_frequent_sorted = [[bytes_frequent_sorted_reverse reverseObjectEnumerator] allObjects];
    
    for (int i=0; i < (int)[self.bytesFrequent count]; i++)
    {
        int iSorted = [[bytes_frequent_sorted objectAtIndex:i] intValue];
        
        NSString *item = [NSString stringWithFormat:@"%d",iSorted];
        NSDictionary *byte = [self.bytesFrequent objectForKey:item];
        [self addToChildrenWithByte:byte children:children];
    }

}

-(void) addCategoryWithByte:(NSDictionary*) byte proccessedArray:(NSMutableArray*) proccessedArray
{
    //NSLog(@"path_id %@",[byte objectForKey:@"path_id"]);
    // break path id
    NSArray *pathIdArray = [[byte objectForKey:@"path_id"] componentsSeparatedByString: @"/"];
    //NSArray *pathArray = [[byte objectForKey:@"path"] componentsSeparatedByString: @"/"];
    
    // path_id 0 and 1 exist
    // create or append to category or subcategory
    // path_id > 1
    // create or append to category/subcategory
    
    [self addParentCategoryWithByte:byte proccessedArray:proccessedArray index:0];

    if((int)[pathIdArray count]>=2)
    {
        BOOL isAdded = NO;
        
        // create or append to category
        for(NSMutableDictionary *p in proccessedArray)
        {
            if([[p objectForKey:@"id"] isEqualToString:[pathIdArray objectAtIndex:0]])
            {
                // apprend byte
                NSMutableArray *children = (NSMutableArray*)[p objectForKey:@"children"];
                
                if(children)
                {
                    [self addParentCategoryWithByte:byte proccessedArray:children index:1];
                    isAdded = YES;
                }
                else
                {
                    //NSLog(@"children does not exist");
                    NSMutableArray *newCategoryBytes = [[NSMutableArray alloc] init];
                    [self addParentCategoryWithByte:byte proccessedArray:newCategoryBytes index:1];
                    [p setObject:newCategoryBytes forKey:@"children"];
                    
                    isAdded = YES;
                    
                }
                
                break;
            }
            
        }

        
        
    }
}

-(void) addParentCategoryWithByte:(NSDictionary*) byte proccessedArray:(NSMutableArray*) proccessedArray index:(int) index
{
    NSArray *pathIdArray = [[byte objectForKey:@"path_id"] componentsSeparatedByString: @"/"];
    NSArray *pathArray = [[byte objectForKey:@"path"] componentsSeparatedByString: @"/"];
  
    BOOL isAdded = NO;
    
    // create or append to category
    for(NSMutableDictionary *p in proccessedArray)
    {
        if([[p objectForKey:@"id"] isEqualToString:[pathIdArray objectAtIndex:index]])
        {
            // apprend byte
            NSMutableArray *children = (NSMutableArray*)[p objectForKey:@"children"];
            
            if(children)
            {
                if((int)[pathIdArray count] <= 1 || index > 0)
                    [self addToChildrenWithByte:byte children:children];
                
                isAdded = YES;
            }
            else
            {
                //NSLog(@"children does not exist");
                NSMutableArray *newCategoryBytes = [[NSMutableArray alloc] init];
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                [data setObject:[pathArray objectAtIndex:index] forKey:@"title"];
                [data setObject:[byte objectForKey:@"colour"] forKey:@"colour"];
                [data setObject:[byte objectForKey:@"background"] forKey:@"background"];
                [data setObject:@"category" forKey:@"type"];
                if(index > 0)
                [data setObject:[NSString stringWithFormat:@"%@/%@",[pathArray objectAtIndex:0], [pathArray objectAtIndex:index]]  forKey:@"path"];
                else
                    [data setObject:[pathArray objectAtIndex:index]  forKey:@"path"];

                [self addToChildrenCoverWithData:data children:newCategoryBytes];
                
                if((int)[pathIdArray count] <= 1|| index > 0)
                    [self addToChildrenWithByte:byte children:newCategoryBytes];
                
                [p setObject:newCategoryBytes forKey:@"children"];
                
                isAdded = YES;
                
            }
            
            
            break;
        }
        
    }
    
    //NSLog(@"Category does not exist");
    // create new
    if(!isAdded)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:[pathArray objectAtIndex:index] forKey:@"title"];
        [data setObject:[pathIdArray objectAtIndex:index] forKey:@"id"];
        [data setObject:[byte objectForKey:@"colour"] forKey:@"colour"];
        [data setObject:[byte objectForKey:@"background"] forKey:@"background"];
        [data setObject:@"category" forKey:@"type"];
        if(index > 0)
            [data setObject:[NSString stringWithFormat:@"%@/%@",[pathArray objectAtIndex:0], [pathArray objectAtIndex:index]]  forKey:@"path"];
        else
            [data setObject:[pathArray objectAtIndex:index]  forKey:@"path"];

        NSMutableDictionary *newCategory = [self addNewCategoryWithData:data];
        
        NSMutableArray *newCategoryBytes = [[NSMutableArray alloc] init];
        
        [self addToChildrenCoverWithData:data children:newCategoryBytes];
        
        if((int)[pathIdArray count] <= 1 || index > 0)
            [self addToChildrenWithByte:byte children:newCategoryBytes];
        
        [newCategory setObject:newCategoryBytes forKey:@"children"];
        
        [proccessedArray addObject:newCategory];
    }
    

}

-(NSMutableDictionary*) addNewCategoryWithData:(NSDictionary*) data
{
    NSMutableDictionary *newCategory = [[NSMutableDictionary alloc] init];
    [newCategory setObject:[data objectForKey:@"id"] forKey:@"id"];
    [newCategory setObject:[data objectForKey:@"title"] forKey:@"title"];
    [newCategory setObject:[data objectForKey:@"type"] forKey:@"type"];
    [newCategory setObject:@"keyboard_generic_biscuit_thumb" forKey:@"cover"];
    [newCategory setObject:@"keyboard_generic_biscuit_thumb.png" forKey:@"cover1x"];
    [newCategory setObject:@"keyboard_generic_biscuit_thumb@2x.png" forKey:@"cover2x"];
    [newCategory setObject:@"keyboard_generic_biscuit_thumb@3x.png" forKey:@"cover3x"];
    [newCategory setObject:[data objectForKey:@"colour"] forKey:@"colour"];
    [newCategory setObject:[data objectForKey:@"background"] forKey:@"background"];

    return newCategory;
}

-(void) addToChildrenCoverWithData:(NSDictionary*) data children:(NSMutableArray*)children
{
    NSMutableDictionary *newCover = [[NSMutableDictionary alloc] init];
    [newCover setObject:@"0" forKey:@"id"];
    [newCover setObject:[data objectForKey:@"title"] forKey:@"title"];
    [newCover setObject:[data objectForKey:@"type"]  forKey:@"type"];
    [newCover setObject:@"keyboard_generic_biscuit_thumb" forKey:@"cover"];
    [newCover setObject:@"keyboard_generic_biscuit_thumb.png" forKey:@"cover1x"];
    [newCover setObject:@"keyboard_generic_biscuit_thumb@2x.png" forKey:@"cover2x"];
    [newCover setObject:@"keyboard_generic_biscuit_thumb@3x.png" forKey:@"cover3x"];
    [newCover setObject:[data objectForKey:@"colour"] forKey:@"colour"];
    [newCover setObject:[data objectForKey:@"background"] forKey:@"background"];
    [newCover setObject:[data objectForKey:@"path"] forKey:@"path"];

    [children addObject:newCover];
    
}

-(void) addToChildrenWithByte:(NSDictionary*) byte children:(NSMutableArray*)children
{
    NSMutableDictionary *newByte = [[NSMutableDictionary alloc] init];
    [newByte setObject:[byte objectForKey:@"id"] forKey:@"id"];
    [newByte setObject:[byte objectForKey:@"path_id"] forKey:@"path_id"];
    [newByte setObject:[byte objectForKey:@"title"] forKey:@"title"];
    [newByte setObject:@"byte" forKey:@"type"];
    [newByte setObject:[byte objectForKey:@"cover1x"] forKey:@"cover1x"];
    [newByte setObject:[byte objectForKey:@"cover2x"] forKey:@"cover2x"];
    [newByte setObject:[byte objectForKey:@"cover3x"] forKey:@"cover3x"];
    [newByte setObject:[byte objectForKey:@"video"] forKey:@"video"];
    [newByte setObject:[byte objectForKey:@"colour"]  forKey:@"colour"];
    [newByte setObject:[byte objectForKey:@"background"]  forKey:@"background"];
    [children addObject:newByte];

}


-(void) addToSearchReultsWithByte:(NSDictionary*) byte results:(NSMutableArray*)results
{
    NSMutableDictionary *newCategory = [[NSMutableDictionary alloc] init];
    [newCategory setObject:[byte objectForKey:@"id"] forKey:@"id"];
    [newCategory setObject:[byte objectForKey:@"path_id"] forKey:@"path_id"];
    [newCategory setObject:[byte objectForKey:@"title"] forKey:@"title"];
    [newCategory setObject:@"category" forKey:@"type"];
    [newCategory setObject:[byte objectForKey:@"cover1x"] forKey:@"cover1x"];
    [newCategory setObject:[byte objectForKey:@"cover2x"] forKey:@"cover2x"];
    [newCategory setObject:[byte objectForKey:@"cover3x"] forKey:@"cover3x"];
    [newCategory setObject:[byte objectForKey:@"colour"]  forKey:@"colour"];
    [newCategory setObject:[byte objectForKey:@"background"]  forKey:@"background"];


    NSMutableDictionary *newByte = [[NSMutableDictionary alloc] init];
    [newByte setObject:[byte objectForKey:@"id"] forKey:@"id"];
    [newByte setObject:[byte objectForKey:@"path_id"] forKey:@"path_id"];
    [newByte setObject:[byte objectForKey:@"title"] forKey:@"title"];
    [newByte setObject:@"byte" forKey:@"type"];
    [newByte setObject:[byte objectForKey:@"cover1x"] forKey:@"cover1x"];
    [newByte setObject:[byte objectForKey:@"cover2x"] forKey:@"cover2x"];
    [newByte setObject:[byte objectForKey:@"cover3x"] forKey:@"cover3x"];
    [newByte setObject:[byte objectForKey:@"video"] forKey:@"video"];
    [newByte setObject:[byte objectForKey:@"colour"]  forKey:@"colour"];
    [newByte setObject:[byte objectForKey:@"background"]  forKey:@"background"];
    
    NSMutableArray *newCategoryBytes = [[NSMutableArray alloc] init];
    
    [newCategoryBytes addObject:newByte];
    [newCategory setObject:newCategoryBytes forKey:@"children"];
    [results addObject:newCategory];

    
}






@end
