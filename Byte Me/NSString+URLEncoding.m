
//
//  NSString+URLEncoding.m
//  Byte Me
//
//  Created by Leandro Marques on 29/01/2016.
//  Copyright © 2016 NetDevo Limited. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                              // (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                (CFStringRef)@"!*'\"();:@$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}
@end
