//
//  CartManager.m
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "CartManager.h"

@implementation CartManager

#pragma mark -
#pragma mark Init
- (id)init
{
    self = [super init];
    if (self)
    {
        _cartProcessor = [[CartProcessor alloc] init];
        _cartProcessor.delegate = self;
    }
    return self;
}


@end
