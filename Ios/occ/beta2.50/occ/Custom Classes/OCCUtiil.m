//
//  OCCUtiil.m
//  occ
//
//  Created by RS on 13-10-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCUtiil.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <SystemConfiguration/CaptiveNetwork.h>  

#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "KeychainItemWrapper.h"

@implementation OCCUtiil

//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

//sha1加密方式
+ (NSString *)getSha1String:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//sha256加密方式
+ (NSString *)getSha256String:(NSString *)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//sha384加密方式
+ (NSString *)getSha384String:(NSString *)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//sha512加密方式
+ (NSString*) getSha512String:(NSString*)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

#pragma mark MAC
+ (NSString *) getMacaddressWithSeperator:(NSString*)sep
{
    
    int                    mib[6];
    
    size_t                len;
    
    char                *buf;
    
    unsigned char        *ptr;
    
    struct if_msghdr    *ifm;
    
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    
    mib[1] = AF_ROUTE;
    
    mib[2] = 0;
    
    mib[3] = AF_LINK;
    
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        
        printf("Error: if_nametoindex error/n");
        
        return NULL;
        
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        
        printf("Error: sysctl, take 1/n");
        
        return NULL;
        
    }
    
    if ((buf = malloc(len)) == NULL) {
        
        printf("Could not allocate memory. error!/n");
        
        return NULL;
        
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        
        printf("Error: sysctl, take 2");
        
        return NULL;
        
    }
    
    ifm = (struct if_msghdr *)buf;
    
    sdl = (struct sockaddr_dl *)(ifm + 1);
    
    ptr = (unsigned char *)LLADDR(sdl);
    
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%@%02x%@%02x%@%02x%@%02x%@%02x", *ptr, sep, *(ptr+1), sep, *(ptr+2), sep, *(ptr+3), sep, *(ptr+4),sep, *(ptr+5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

+ (NSString *) getMacaddress
{
    return [OCCUtiil getMacaddressWithSeperator:@":"];
}

- (id)fetchWifiSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

+ (NSString*)getWifiSSID
{
    NSString *ssid = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];
        }
    }
    return ssid;
}

+ (NSString*)getWifiBSSID
{
    NSString *bssid = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            bssid = [dict valueForKey:@"BSSID"];
        }
    }
    return bssid;
}

+ (NSString*) getWifiIp
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

+ (NSString*) getWifiMac
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if(version<7.0f)
    {
        NSString *mac=[OCCUtiil getMacaddress];
        return mac;
    }
    
    NSString *macAddr=[self getMacFromMallData];
    if (macAddr!=nil&&[macAddr length]>0)
    {
        return macAddr;
    }
    
    NSString *wifiIp=[OCCUtiil getWifiIp];
    if (wifiIp==nil)
    {
        wifiIp=@"";
    }
    
    return wifiIp;
}

/*
 从服务器异步获取MAll信息地址
 */
+ (void) getMallDataASync
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSString *wifiIp=[OCCUtiil getWifiIp];
                       if (wifiIp==nil)
                       {
                           wifiIp=@"";
                       }
                       
                       NSDictionary *obj =[NSDictionary dictionaryWithObjectsAndKeys:
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [NSString stringWithFormat:@"%d",[[Singleton sharedInstance]mall]], @"mall",
                                                  wifiIp,@"ip",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       NSURL *url = [NSURL URLWithString:[getWifiProp_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                       
                       ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
                       [request setRequestMethod:@"POST"];
                       [request setShouldAttemptPersistentConnection:NO];
                       [request setTimeOutSeconds:TIME_OUT_TIME_INTERVAL];
                       [request setNumberOfTimesToRetryOnTimeout:2];
                       [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
                       [request setPostValue:reqdata forKey:@"data"];
                       [request startSynchronous];
                       
                       NSError *error = [request error];
                       if (error)
                       {
                           NSLog(@"Failed %@ with code %d and with url=%@",
                                 [error domain],
                                 [error code],
                                 url);
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root!=nil&&[[root objectForKey:@"code"]intValue]==0)
                       {
                           NSDictionary *mallData=[root objectForKey:@"data"];
                           if (mallData!=nil)
                           {
                               [[Singleton sharedInstance]setMallData:mallData];
                           }
                       }
                   });
}

+ (NSString*) getMacFromMallData
{
    NSDictionary *mallData=[Singleton sharedInstance].mallData;
    if (mallData!=nil)
    {
        NSString *macAddr=[mallData objectForKey:@"mac"];
        if (macAddr!=nil&&[macAddr length]>0)
        {
            return macAddr;
        }
    }
    
    [OCCUtiil getMallDataASync];
    return @"";
}

+ (NSString*) getWifiFromMallData
{
    NSDictionary *mallData=[Singleton sharedInstance].mallData;
    if (mallData!=nil)
    {
        NSString *wifiUrl=[mallData objectForKey:@"WIFI_URL"];
        if (wifiUrl!=nil&&[wifiUrl length]>0)
        {
            return wifiUrl;
        }
    }
    
    [OCCUtiil getMallDataASync];
    return @"";
}

@end
