//
//  Shop.m
//  occ
//
//  Created by zhangss on 13-9-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Shop.h"
#import "Goods.h"

#define kShopName @"shopName"
#define kShopBrief @"brief"
#define kShopIntroduction @"introduction"
#define kShopType @"classification"
#define kShopLogo @"logo"
#define kShopImage @"image"
#define kShopRating @"evaluation"
#define kShopFavourNum @"favourNum"
#define kShopViewNum @"pageviewNum"
#define kID @"id"
#define kShopID @"shopId"
#define kShopItemNum @"itemNum"
#define kShopItemList @"itemList"
#define kShopFavourID @"id"
#define kShopCategoryList @"categoryList"

@implementation Shop

+ (Shop *)shopWithDic:(NSDictionary *)dic
{
    Shop *shop = [[Shop alloc] init];
    if ([dic objectForKey:kShopName] && [[dic objectForKey:kShopName] length] > 0)
    {
        shop.shopName = [dic objectForKey:kShopName];
    }
    else if ([dic objectForKey:@"name"] && [[dic objectForKey:@"name"] length] > 0)
    {
        shop.shopName = [dic objectForKey:@"name"];
    }
    
    if ([dic objectForKey:kShopBrief] && [[dic objectForKey:kShopBrief] length] > 0)
    {
        shop.shopBrief = [dic objectForKey:kShopBrief];
    }
    else if ([dic objectForKey:kShopIntroduction] && [[dic objectForKey:kShopIntroduction] length] > 0)
    {
        shop.shopBrief = [dic objectForKey:kShopIntroduction];
    }
    
    if ([dic objectForKey:kShopLogo] && [[dic objectForKey:kShopLogo] length] > 0)
    {
        shop.shopImage = [dic objectForKey:kShopLogo];
    }
    else if ([dic objectForKey:kShopImage] && [[dic objectForKey:kShopImage] length] > 0)
    {
        shop.shopImage = [dic objectForKey:kShopImage];
    }
    
    if ([dic objectForKey:kShopID])
    {
        shop.shopID = [dic objectForKey:kShopID];
    }
    else if ([dic objectForKey:kID])
    {
        shop.shopID = [dic objectForKey:kID];
    }
    
    if ([dic objectForKey:kShopCategoryList])
    {
        shop.shopCategoryList = [dic objectForKey:kShopCategoryList];
    }

    shop.shopType = [dic objectForKey:kShopType];
    shop.shopRating = [dic objectForKey:kShopRating];
    shop.shopFavourNum = [dic objectForKey:kShopFavourNum];
    shop.shopViewNum = [dic objectForKey:kShopViewNum];
    shop.shopFavourID = [dic objectForKey:kShopFavourID];
    
    NSArray *itemList = [dic objectForKey:kShopItemList];
    if (itemList && [itemList isKindOfClass:[NSArray class]])
    {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *item in itemList)
        {
            Goods *goods = [Goods goodsWithDic:item];
            [array addObject:goods];
        }
        shop.shopItemList = array;
    }
    
    shop.shopItemNum = [dic objectForKey:kShopItemNum];
    return shop;
}

@end
