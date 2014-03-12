//
//  Goods.m
//  occ
//
//  Created by zhangss on 13-9-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Goods.h"

#define kGoodsName @"name"
#define kGoodsImage @"image"
#define kGoodsIsFavour @"isFavour"
#define kGoodsIsCart @"isCart"
#define kGoodsID @"itemId"
#define kGoodsListPrice @"listPrice"
#define kGoodsPLPrice @"plPrice"
#define kGoodsSellNum @"sellNumMonth"
#define kGoodsType @"type"
#define kGoodsFavourID @"favourId"
#define kGoodsFavourNum @"favourNum"

@implementation Goods

+ (Goods *)goodsWithDic:(NSDictionary *)dic
{
    Goods *goods = [[Goods alloc] init];
    
    if ([dic objectForKey:kGoodsName] && [[dic objectForKey:kGoodsName] length] > 0)
    {
        goods.goodsName = [dic objectForKey:kGoodsName];
    }
    else if ([dic objectForKey:@"itemName"] && [[dic objectForKey:@"itemName"] length] > 0)
    {
        goods.goodsName = [dic objectForKey:@"itemName"];
    }
    
    goods.goodsType = [dic objectForKey:kGoodsType];
    
    if ([dic objectForKey:kGoodsImage] && [[dic objectForKey:kGoodsImage] length] > 0)
    {
        goods.goodsImage = [dic objectForKey:kGoodsImage];
    }
    else if ([dic objectForKey:@"picturePath"] && [[dic objectForKey:@"picturePath"] length] > 0)
    {
        goods.goodsImage = [dic objectForKey:@"picturePath"];
    }
    
    goods.goodsIsFavour = [dic objectForKey:kGoodsIsFavour];
    goods.goodsIsCart = [dic objectForKey:kGoodsIsCart];
    goods.goodsListPrice = [dic objectForKey:kGoodsListPrice];
    goods.goodsPLPrice = [dic objectForKey:kGoodsPLPrice];
    
    if ([dic objectForKey:kGoodsSellNum])
    {
        goods.goodsSellNum = [dic objectForKey:kGoodsSellNum];
    }
    else if ([dic objectForKey:@"sellNum"])
    {
        goods.goodsSellNum = [dic objectForKey:@"sellNum"];
    }
    
    if ([dic objectForKey:kGoodsID])
    {
        goods.goodsID = [dic objectForKey:kGoodsID];
    }
    else if ([dic objectForKey:@"id"])
    {
        goods.goodsID = [dic objectForKey:@"id"];
    }
    
    goods.goodsFavourID = [dic objectForKey:kGoodsFavourID];
    goods.goodsFavourNum = [dic objectForKey:kGoodsFavourNum];
    return goods;
}

@end
