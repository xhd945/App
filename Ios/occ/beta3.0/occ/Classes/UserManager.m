//
//  UserManager.m
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "UserManager.h"
#import "OCCDefine.h"
#import "NaviManager.h"

@implementation UserManager

#pragma mark -
#pragma mark Init
- (id)init
{
    self = [super init];
    if (self)
    {
        _userProcessor = [[UserProcessor alloc] init];
        _userProcessor.delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark Favorite List
/******************************************************************************
 函数名称 : requestMyFavoriteList
 函数描述 : 请求用户的收藏列表
 输入参数 : 类型:OCCSearchClassiFication(Shop/Item) Page:页码 及 TGC:用户标示
 输出参数 : 无
 返回值 : 无
 备注 : 1.
 添加人: zhangss
 ******************************************************************************/
- (void)requestMyFavoriteList:(NSDictionary *)dic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_userProcessor loadMyFavoriteListData:dic];
                   });
}

- (NSArray *)parseMyFavoriteList:(NSDictionary *)dic
{
    if ([dic objectForKey:KEY_ITEMLIST])
    {
        //获取商品列表
        return [[BusinessManager sharedManager].naviManager parseGoodsListData:dic];
    }
    else if ([dic objectForKey:KEY_SHOPLIST])
    {
        //获取店铺列表
        return [[BusinessManager sharedManager].naviManager parseShopListData:dic];
    }
    else
    {
        return [NSArray array];
    }
}

- (void)loadMyFavoriteListDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    
    NSArray *favourList = nil;
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功解析数据
        NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
        favourList = [self parseMyFavoriteList:resultDic];
    }
    else
    {
        //失败
        favourList = [NSArray array];
    }
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (favourList)
    {
        [returnDic setObject:favourList forKey:kReturnDataKey];
    }
    [self notificationOnMainWith:OCC_NOTIFI_USER_FAVORITELIST_RETURN object:nil userInfo:returnDic];

}

#pragma mark -
#pragma mark Delete Favorite
/******************************************************************************
 函数名称 : deleteMyFavoriteReuqest
 函数描述 : 删除收藏
 输入参数 : 类型:OCCSearchClassiFication(Shop/Item) 
           FavoriteList:id数组 及 TGC:用户标示
 输出参数 : 无
 返回值 : 无
 备注 : 1.
 添加人: zhangss
 ******************************************************************************/
- (void)deleteMyFavoriteReuqest:(NSDictionary *)dic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_userProcessor deleteMyFavorite:dic];
                   });
}

- (void)deleteMyFavoriteCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    NSDictionary *requestData = [dic objectForKey:kRequestDataKey];
    
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
    }
    else
    {
        //失败读取旧数据展示
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_USER_DELETEFAVORITE_RETURN object:[requestData valueForKey:kRequestObjectKey] userInfo:dic];
    
}


#pragma mark -
#pragma mark Add Goods To Cart
/******************************************************************************
 函数名称 : addGoodsToCart
 函数描述 : 加入商品到购物车
 输入参数 : TGC:用户标示
           itemList操作数据数组{id:商品id buyNum数量 type类型}
 输出参数 : 无
 返回值 : 无
 备注 : 1.
 添加人: zhangss
 ******************************************************************************/
- (void)addGoodsToCart:(NSDictionary *)dic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_userProcessor addGoodsToCartReuqest:dic];
                   });
}

- (void)addOneGoodsToCart:(NSDictionary *)dic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_userProcessor addOneGoodsToCartReuqest:dic];
                   });
}

- (void)addGoodsToCartReuqestCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
//    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
    }
    else
    {
        //失败读取旧数据展示
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_USER_ADDGOODSTOCART_RETURN object:nil userInfo:dic];
}

#pragma mark -
#pragma mark Add Favorite
/******************************************************************************
 函数名称 : addToFavorite
 函数描述 : 添加店铺或者商品到收藏
 输入参数 : 类型:OCCSearchClassiFication(Shop/Item) TGC:用户标示 id:店铺或者商品id
 输出参数 : 无
 返回值 : 无
 备注 : 1.
 添加人: zhangss
 ******************************************************************************/
- (void)addToFavoriteRequest:(NSDictionary *)dic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_userProcessor addToFavoriteRequest:dic];
                   });
}

- (void)addToFavoriteRequestCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    NSDictionary *requestData = [dic objectForKey:kRequestDataKey];
//    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
    }
    else
    {
        //失败读取旧数据展示
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_USER_ADDFAVORITE_RETURN object:[requestData valueForKey:kRequestObjectKey] userInfo:dic];
}

@end
