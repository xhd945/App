//
//  BusinessManager.m
//  occ
//
//  Created by zhangss on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "BusinessManager.h"
#import "NaviManager.h"
#import "SearchManager.h"
#import "CartManager.h"
#import "UserManager.h"
#import "AddressManager.h"

@implementation BusinessManager

static BusinessManager *sharedManager = nil;
+ (BusinessManager *)sharedManager
{
    if (sharedManager == nil)
    {
        @synchronized(self)
        {
            if (sharedManager == nil)
            {
                sharedManager = [[BusinessManager alloc] init];
            }
        }
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if (sharedManager == nil)
    {
        @synchronized(self)
        {
            if (sharedManager == nil)
            {
                sharedManager = [super allocWithZone:zone];
            }
        }
    }
    return sharedManager;
}


- (id)init
{
    if (self = [super init])
    {
        [sharedManager initWithBusiness];
    }
    return self;
}


- (void)initWithBusiness
{
    //Manager初始化
    _naviManager = [[NaviManager alloc] init];
    _searchManager = [[SearchManager alloc] init];
    _cartManager = [[CartManager alloc] init];
    _userManager = [[UserManager alloc] init];
    _addressrManager = [[AddressManager alloc] init];
}

@end
