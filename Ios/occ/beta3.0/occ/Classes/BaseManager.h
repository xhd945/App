//
//  BaseManager.h
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseManager : NSObject

//公共方法
- (void)notificationOnMainWith:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

@end
