//
//  NaviData.m
//  occ
//
//  Created by zhangss on 13-9-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NaviData.h"

#define kNaviCount    @"count"
#define kNaviData     @"data"
#define kNaviIcon     @"icon"
#define kNaviIsParent @"isParent"
#define kNaviLevel    @"level"
#define kNaviMethod   @"method"
#define kNaviName     @"name"
#define kNaviID       @"navId"
#define kNaviParentID @"parentId"


@implementation NaviData

+ (NaviData *)naviDataWithDic:(NSDictionary *)dic
{
    NaviData *naviData = [[NaviData alloc] init];
    naviData.naviCout = [dic objectForKey:kNaviCount];
    naviData.naviIcon = [dic objectForKey:kNaviIcon];
    naviData.naviID = [dic objectForKey:kNaviID];
    naviData.naviIsParent = [dic objectForKey:kNaviIsParent];
    naviData.naviLevel = [dic objectForKey:kNaviLevel];
    naviData.naviMethod = [dic objectForKey:kNaviMethod];
    naviData.naviName = [dic objectForKey:kNaviName];
    naviData.naviParendId = [dic objectForKey:kNaviParentID];
    naviData.naviRequestData = [dic objectForKey:kNaviData];
    return naviData;
}

@end
