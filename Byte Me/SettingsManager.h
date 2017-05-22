//
//  SettingsManager.h
//  Byte Me
//
//  Created by Leandro Marques on 01/07/2014.
//  Copyright (c) 2014 NetDevo Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SettingsManager : NSObject
@property (nonatomic) NSMutableDictionary *bytes;
@property (nonatomic) NSMutableDictionary *bytesEnabled;
@property (nonatomic) NSMutableDictionary *bytesFrequent;

@property (nonatomic) NSMutableArray *tags;
@property (nonatomic) NSMutableArray *activeTags;
@property (nonatomic) NSMutableArray *savedSearches;
@property (nonatomic) int currentPageId;
@property (nonatomic) BOOL hasTutorialDone;


+(id) sharedSettings;
-(void) saveSettings;
-(BOOL) isFirstScreen;
-(void) loadStockBytes;

-(BOOL) addNewByte:(NSDictionary *)byte;
-(BOOL) enableByte:(NSDictionary *)byte;
-(BOOL) disableByte:(NSDictionary *)byte;

-(BOOL) isByteAdded:(NSDictionary *)byte;
-(BOOL) isByteEnabled:(NSDictionary *)byte;
-(NSDictionary*) getBytes;

-(BOOL) addNewFrequentByte:(NSDictionary *)byte;
-(void) addFrequentBytesWithChildren:(NSMutableArray*)children;

-(int) getBytesAddedCount;
-(int) getBytesEnabledCount;
-(NSMutableArray *) loadTags;
-(NSMutableArray *) loadActiveTags;
-(NSMutableDictionary *) loadActiveBytes;
-(NSMutableArray *) getFormatedBytesSearchResultsWithArray:(NSMutableArray*)array;

-(BOOL) addSearchTerm:(NSString*)searchTerm;
-(void) clearSavedSearches;
-(UIColor*) getColourFromObject:(NSDictionary*) object defaultColout:(UIColor*) defaultColout;
-(UIColor*) getBackgroundFromObject:(NSDictionary*) object defaultColout:(UIColor*) defaultColout;
-(NSString*)getRGBAfromUIColor:(UIColor*) color;
-(NSMutableArray *) getBytesEnabledForKeyboard;
@end
