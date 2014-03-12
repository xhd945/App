//
//  AdvertisementSeat.h
//  occ
//
//  Created by zhangss on 13-9-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 广告位置 数据结构
 */

@interface AdvertisementSeat : NSObject

@property (nonatomic, strong)NSString *seatType;        //广告位类型
@property (nonatomic, strong)NSNumber *seatWidth;       //广告位宽度
@property (nonatomic, strong)NSNumber *seatHeight;      //广告位高度
@property (nonatomic, strong)NSNumber *channelID;       // long
@property (nonatomic, strong)NSNumber *channelOider;    //
@property (nonatomic, strong)NSNumber *seatID;          //广告位ID
@property (nonatomic, strong)NSArray  *adList;          //广告位广告内容

+ (AdvertisementSeat *)advertisementSeatWithDic:(NSDictionary *)dic;

@end
