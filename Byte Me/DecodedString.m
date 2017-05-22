//
//  DecodedString.m
//  Byte Me
//
//  Created by Leandro Marques on 20/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "DecodedString.h"

@implementation DecodedString

+ (NSString *) decodedStringWithString:(NSString*) s
{
  
    /*
   NSAttributedString *as = [[NSAttributedString alloc] initWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];

    return [as string];
     */
    
    
    return s;
}

@end
