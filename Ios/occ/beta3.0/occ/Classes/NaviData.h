//
//  NaviData.h
//  occ
//
//  Created by zhangss on 13-9-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NaviData : NSObject

@property (nonatomic, strong) NSString *naviCout;             //最后一级导航 显示类目个数
@property (nonatomic, strong) NSNumber *naviID;               //导航ID
@property (nonatomic, strong) NSDictionary *naviRequestData;  //最后一级导航 请求Data
@property (nonatomic, strong) NSString *naviMethod;           //最后一级导航 请求URL
@property (nonatomic, strong) NSString *naviName;             //导航Title
@property (nonatomic, strong) NSString *naviIcon;             //导航图片
@property (nonatomic, strong) NSNumber *naviParendId;         //导航父节点ID
@property (nonatomic, strong) NSNumber *naviLevel;            //导航等级 1为根节点
@property (nonatomic, strong) NSNumber *naviIsParent;         //0:否 1:是

+ (NaviData *)naviDataWithDic:(NSDictionary *)dic;

@end
