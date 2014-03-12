//
//  Activity.h
//  occ
//
//  Created by zhangss on 13-9-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property(nonatomic, strong) NSString *activityName;         //活动名称
@property(nonatomic, strong) NSString *activityIntroduction; //活动介绍 HTML语句
@property(nonatomic, strong) NSString *activityImageUrl;     //活动图片
@property(nonatomic, strong) NSNumber *activityID;           //活动ID
@property(nonatomic, strong) NSNumber *activityType;         //0商家活动 1:广场活动

+ (Activity *)activityWithDic:(NSDictionary *)dic;

@end
