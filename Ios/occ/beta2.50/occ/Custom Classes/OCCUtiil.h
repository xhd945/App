//
//  OCCUtiil.h
//  occ
//
//  Created by RS on 13-10-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCCUtiil : NSObject

//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;

//sha1加密方式
+ (NSString *)getSha1String:(NSString *)srcString;

//sha256加密方式
+ (NSString *)getSha256String:(NSString *)srcString;

//sha384加密方式
+ (NSString *)getSha384String:(NSString *)srcString;

//sha512加密方式
+ (NSString*) getSha512String:(NSString*)srcString;

+ (NSString *) getMacaddressWithSeperator:(NSString*)sep;
+ (NSString *) getMacaddress;

+ (id)fetchSSIDInfo;
+ (NSString*)getWifiSSID;
+ (NSString*)getWifiBSSID;
+ (NSString*)getWifiIp;
+ (NSString*)getWifiMac;

+ (void) getMallDataASync;
+ (NSString*) getMacFromMallData;
+ (NSString*) getWifiFromMallData;

@end
