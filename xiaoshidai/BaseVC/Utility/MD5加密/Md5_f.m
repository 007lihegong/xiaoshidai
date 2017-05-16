//
//  Md5_f.m
//  daisxg
//
//  Created by 技术部－XSD on 15/10/10.
//  Copyright (c) 2015年 技术部－XSD. All rights reserved.
//

#import "Md5_f.h"
#import "CommonCrypto/CommonDigest.h"

@implementation Md5_f


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

@end
