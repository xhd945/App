//
//  Advertisement.m
//  occ
//
//  Created by zhangss on 13-9-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Advertisement.h"

@implementation Advertisement

+ (Advertisement *)advertisementWithDic:(NSDictionary *)adDic
{
    Advertisement *adver = [[Advertisement alloc] init];
    adver.adDis = [adDic objectForKey:KEY_ADDIS];
    adver.adImageUrl = [adDic objectForKey:KEY_ADIMAGE];
    adver.adLink = [adDic objectForKey:KEY_ADLINK];
    adver.adID = [adDic objectForKey:KEY_ID];
    adver.adSeatID = [adDic objectForKey:@"adseatId"];
    adver.adType = [adDic objectForKey:KEY_TYPE];
    return adver;
}

@end
