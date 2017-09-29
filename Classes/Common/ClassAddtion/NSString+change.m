//
//  NSString+change.m
//  Desea
//
//  Created by wenbin on 14-2-24.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "NSString+change.h"

@implementation NSString (change)

- (NSData *)dataFromHexString
{
    const char *chars = [self UTF8String];
    int i = 0, len = self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}
@end
