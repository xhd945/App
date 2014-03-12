//
//  Brand.m
//  occ
//
//  Created by zhangss on 13-9-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Brand.h"

#define KEY_BRANDLIST @"shopList"
#define KEY_BRANDNAME @"enName"
#define KEY_BRANDICON @"icon"
#define KEY_BRANDID   @"id"

@implementation Brand

+ (Brand *)brandWithDic:(NSDictionary *)dic
{
    Brand *brand = [[Brand alloc] init];
    brand.brandID = [dic objectForKey:KEY_BRANDID];
    brand.brandName = [dic objectForKey:KEY_BRANDNAME];
    brand.brandIconUrl = [dic objectForKey:KEY_BRANDICON];
    return brand;
}

@end
