//
//  AdvertisementSeat.m
//  occ
//
//  Created by zhangss on 13-9-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "AdvertisementSeat.h"
#import "Advertisement.h"

@implementation AdvertisementSeat

+ (AdvertisementSeat *)advertisementSeatWithDic:(NSDictionary *)seatDic
{
    AdvertisementSeat *adSeat = [[AdvertisementSeat alloc] init];
    adSeat.seatType = [seatDic objectForKey:KEY_ADTYPE];
    adSeat.seatWidth = [seatDic objectForKey:KEY_ADWIDTH];
    adSeat.seatHeight = [seatDic objectForKey:KEY_ADHEIGHT];
    adSeat.channelID = [seatDic objectForKey:@"channelId"];
    adSeat.channelOider = [seatDic objectForKey:@"channelOrder"];
    adSeat.seatID = [seatDic objectForKey:KEY_ID];
    
    //广告列表
    NSArray *adList = [seatDic objectForKey:KEY_ADVERTISEMENTLIST];
    NSMutableArray *adListArr = [NSMutableArray arrayWithCapacity:adList.count];
    for (NSDictionary *adDic in adList)
    {
        Advertisement *adver = [Advertisement advertisementWithDic:adDic];
        [adListArr addObject:adver];
    }
    adSeat.adList = adListArr;
    
    return adSeat;
}

@end
