//
//  Advertisement.h
//  occ
//
//  Created by zhangss on 13-9-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advertisement : NSObject

@property (nonatomic, strong)NSString *adDis;        //广告描述
@property (nonatomic, strong)NSString *adImageUrl;   //广告图片地址
@property (nonatomic, strong)NSNumber *adType;       //广告类型
@property (nonatomic, strong)NSString *adLink;       //广告链接地址
@property (nonatomic, strong)NSNumber *adSeatID;     //广告所属的广告位ID
@property (nonatomic, strong)NSNumber *adID;         //广告ID

+ (Advertisement *)advertisementWithDic:(NSDictionary *)dic;

@end
