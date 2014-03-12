//
//  Activity.m
//  occ
//
//  Created by zhangss on 13-9-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Activity.h"

#define kActivityName  @"name"
#define kActivityImage @"image"
#define kActivityIntro @"introduction"
#define kActivityType  @"isPlazaActivity"
#define kActivityID    @"id"

@implementation Activity

+ (Activity *)activityWithDic:(NSDictionary *)dic
{
    Activity *activity = [[Activity alloc] init];
    activity.activityName = [dic objectForKey:kActivityName];
    activity.activityImageUrl = [dic objectForKey:kActivityImage];
    activity.activityIntroduction = [dic objectForKey:kActivityIntro];
    activity.activityType = [dic objectForKey:kActivityType];
    activity.activityID = [dic objectForKey:kActivityID];
    return activity;
}

@end
