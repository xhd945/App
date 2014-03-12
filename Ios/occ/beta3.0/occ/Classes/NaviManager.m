 //
//  NaviManager.m
//  occ
//
//  Created by zhangss on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NaviManager.h"
#import "ReturnCodeModel.h"
#import "CommonMethods.h"
#import "OCCDefine.h"
#import "AdvertisementSeat.h"
#import "Advertisement.h"
#import "Brand.h"
#import "Activity.h"
#import "NaviData.h"
#import "Shop.h"
#import "Goods.h"

@implementation NaviManager

#pragma mark -
#pragma mark Init
- (id)init
{
    self = [super init];
    if (self)
    {
        _naviProcessor = [[NaviProcessor alloc] init];
        _naviProcessor.delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark Navi Check Version 版本更新
- (void)checkVersionRequest
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor loadVersionData];
                   });
}

- (void)loadVersionDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:VersionInfoFileName];
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
        [resultDic writeToFile:filePath atomically:YES];
    }
    else
    {
        //失败
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_CHECKVERSION_RETURN object:nil userInfo:dic];
}

#pragma mark -
#pragma mark Home Page Data
//获取本地数据
- (NSArray *)getLocalFrontPageData
{
    NSString *fileName=[NSString stringWithFormat:@"mall_%d_frontpage.plist",[[Singleton sharedInstance]mall]];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:fileName];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dic && [dic count] != 0)
    {
        return [self parseAdvertisementData:dic];
    }
    else
    {
        return nil;
    }
}

//解析数据
- (NSArray *)parseAdvertisementData:(NSDictionary *)dic
{
    NSArray *tempArr = [dic objectForKey:KEY_SEATLIST];
    NSMutableArray *seatArr = [NSMutableArray arrayWithCapacity:tempArr.count];
    for (NSDictionary *seatDic in tempArr)
    {
        AdvertisementSeat *adSeat = [AdvertisementSeat advertisementSeatWithDic:seatDic];
        [seatArr addObject:adSeat];
    }
    return seatArr;
}

//请求网络数据
- (void)requestFrontPage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor loadFrontPageData];
                   });
}

- (void)loadFrontPageDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    NSString *fileName=[NSString stringWithFormat:@"mall_%d_frontpage.plist",[[Singleton sharedInstance]mall]];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:fileName];
    
    NSArray *dataArr = [self parseAdvertisementData:resultDic];

    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
        [resultDic writeToFile:filePath atomically:YES];
    }
    else
    {
        //失败读取旧数据展示
        resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }

    //重组数据
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (dataArr)
    {
        [dataDic setObject:dataArr forKey:kReturnDataKey];
    }

    [self notificationOnMainWith:OCC_NOTIFI_FRONTPAGE_RETURN object:nil userInfo:dataDic];
}

#pragma mark -
#pragma mark Navi Data
- (NSArray *)getNaviDataFromLocalWithNaviID:(NSInteger)naviID
{
    NSString *fileName=[NSString stringWithFormat:@"mall_%d_nav_%d.plist",[[Singleton sharedInstance]mall],naviID];
    NSString* filePath=[CommonMethods getDataCachePathWithFileName:fileName];
    NSDictionary *data=[NSDictionary dictionaryWithContentsOfFile:filePath];
    if (data && [[data allKeys] count] != 0)
    {
        return [self parseNaviData:data];
    }
    else
    {
        return [NSArray array];
    }
}

- (NSArray *)parseNaviData:(NSDictionary *)dic
{
    NSArray *array = [dic objectForKey:KEY_NAVIGATIONLIST];
    NSMutableArray *naviDataArr = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSDictionary *dic in array)
    {
        NaviData *naviData = [NaviData naviDataWithDic:dic];
        [naviDataArr addObject:naviData];
    }
    return naviDataArr;
}

- (void)loadNaviData:(NSInteger)naviId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor loadNavData:naviId];
                   });
}

- (void)loadNavDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    NSDictionary *requestDic = [dic objectForKey:kRequestDataKey];
    
    NSString *fileName=[NSString stringWithFormat:@"mall_%d_nav_%d.plist",[[Singleton sharedInstance]mall],[[requestDic objectForKey:KEY_NAVID] integerValue]];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:fileName];
    
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
        [resultDic writeToFile:filePath atomically:YES];
    }
    else
    {
        //失败读取旧数据展示
        resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    
    NSArray *naviDataList = [self parseNaviData:resultDic];
    NSMutableDictionary *returnData = [NSMutableDictionary dictionaryWithDictionary:dic];
    [returnData setObject:naviDataList forKey:kReturnDataKey];
    
    [self notificationOnMainWith:OCC_NOTIFI_NAVI_DATA_RETURN object:nil userInfo:returnData];
}

#pragma mark -
#pragma mark Brand List
- (NSArray *)getBrandListDataFromLocal
{
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:[CommonMethods getDataCachePathWithFileName:BrandListFileName]];
    if (dataDic == nil || [[dataDic allKeys] count] == 0)
    {
        return [self parseBrandListData:dataDic];
    }
    else
    {
        return [NSArray array];
    }
}

- (NSArray *)parseBrandListData:(NSDictionary *)dic
{
    NSArray *array = [dic objectForKey:KEY_SHOPLIST];
    NSMutableArray *brandArr = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSDictionary *dic in array)
    {
        Brand *brand = [Brand brandWithDic:dic];
        [brandArr addObject:brand];
    }
    return brandArr;
}

- (void)loadBrandList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor loadBrandListData];
                   });
}

- (void)loadBrandListDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    
    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:BrandListFileName];
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
        [resultDic writeToFile:filePath atomically:YES];
    }
    else
    {
        //失败读取旧数据展示
        resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    
    //重组数据
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *brandListArr = [self parseBrandListData:resultDic];
    if (brandListArr)
    {
        [dataDic setObject:brandListArr forKey:kReturnDataKey];
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_NAVI_BRANDLIST_RETURN object:nil userInfo:dataDic];
}

#pragma mark -
#pragma mark Activity List
- (NSArray *)getActivityListForLocal
{
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:[CommonMethods getDataCachePathWithFileName:ActivityListFileName]];
    if (dataDic == nil || [[dataDic allKeys] count] == 0)
    {
        return [NSArray array];
    }
    else
    {
        return [self parseActivityListData:dataDic];
    }
}

- (NSArray *)parseActivityListData:(NSDictionary *)dic
{
    NSArray *activityList = [dic objectForKey:KEY_ACTIVITYLIST];
    NSMutableArray *returnArr = [NSMutableArray arrayWithCapacity:activityList.count];
    for (NSDictionary *dic in activityList)
    {
        Activity *activity = [Activity activityWithDic:dic];
        [returnArr addObject:activity];
    }
    return returnArr;
}

- (void)requestActivityListWithData:(NSDictionary *)dic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor loadActivityListWithData:dic];
                   });
}

- (void)loadActivityListDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    NSDictionary *requetData = [dic objectForKey:kRequestDataKey];
    
    NSArray *dataArr = [self parseActivityListData:resultDic];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:ActivityListFileName];
    
    if (retrunCodeM.code == kReturnSuccess)
    {
        if ([[requetData objectForKey:kRequestTypeKey] isEqualToString: kRequestHomePage])
        {
            //Home页请求 成功保存数据
            [resultDic writeToFile:filePath atomically:YES];
        }
    }
    else
    {
        if ([[requetData objectForKey:kRequestTypeKey] isEqualToString: kRequestHomePage])
        {
            //失败读取旧数据展示
            resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        }
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (dataArr)
    {
        [dataDic setObject:dataArr forKey:kReturnDataKey];
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_NAVI_ACTIVITYLIST_RETURN object:nil userInfo:dataDic];

}

//请求活动详情
- (void)loadActivityInfoWithData:(NSDictionary *)activityData;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor loadActivityInfoWithData:activityData];
                   });
}

- (void)loadActivityInfoCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    Activity *activity = nil;
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功解析数据
        activity = [Activity activityWithDic:[dic objectForKey:kReturnDataKey]];
    }
    else
    {
        //失败读取旧数据展示
        activity = [[Activity alloc] init];
    }
    [returnDic setObject:activity forKey:kReturnDataKey];
    
    [self notificationOnMainWith:OCC_NOTIFI_ACTIVITYINFO_RETURN object:nil userInfo:returnDic];
    
}

#pragma mark -
#pragma mark GroupOn List
- (void)requestGroupOnListWithData:(NSDictionary *)dic;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor loadGroupOnListDataWithData:dic];
                   });
}

- (NSArray *)parseGroupOnListData:(NSDictionary *)dic
{
    NSMutableArray *dataList = [NSMutableArray array];
    NSArray *grouponList = [dic objectForKey:KEY_GROUPONLIST];
    for (NSDictionary *tempDic in grouponList)
    {
        if ([tempDic objectForKey:@"plPrice"])
        {
            Goods *goods = [Goods goodsWithDic:tempDic];
            [dataList addObject:goods];
        }
        else
        {
            Shop *shop = [Shop shopWithDic:tempDic];
            [dataList addObject:shop];
        }
    }
    return dataList;
}

- (void)loadGroupOnListDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    
    NSArray *dataArr = nil;
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功解析数据
        dataArr = [self parseGroupOnListData:[dic objectForKey:kReturnDataKey]];
    }
    else
    {
        //失败
        dataArr = [NSArray array];
    }
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (dataArr)
    {
        [returnDic setObject:dataArr forKey:kReturnDataKey];
    }
    [self notificationOnMainWith:OCC_NOTIFI_NAVI_GROUPONLIST_RETURN object:nil userInfo:returnDic];
}

#pragma mark -
#pragma mark Request Method URL With Data
- (void)requestMethodURLString:(NSString *)urlStr withData:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor requestMethodURLString:urlStr withData:data];
                   });
}

- (void)requestMethodURLStringCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    NSDictionary *requestDataDic = [dic objectForKey:kRequestDataKey];
    
    NSMutableDictionary *returndata = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *shopListArr = nil;
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功解析数据
        NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
        shopListArr = [self parseShopListData:resultDic];
        if ([shopListArr count] == 0)
        {
            shopListArr = [self parseGoodsListData:resultDic];
        }
    }
    else
    {
        //失败返回数据为空
        shopListArr = [NSArray array];
    }
    [returndata setObject:shopListArr forKey:kReturnDataKey];
    [self notificationOnMainWith:[requestDataDic description] object:nil userInfo:returndata];
}

#pragma mark -
#pragma mark Find ShopList
- (NSArray *)parseShopListData:(NSDictionary *)dic
{
    NSArray *shopList = [dic objectForKey:KEY_SHOPLIST];
    NSMutableArray *returnArr = [NSMutableArray array];
    for (NSDictionary *shopDic in shopList)
    {
        Shop *shop = [Shop shopWithDic:shopDic];
        [returnArr addObject:shop];
    }
    return returnArr;
}

- (void)findShopListWithData:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor findShopListWithData:data];
                   });
}

- (void)findShopListDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
    }
    else
    {
        //失败读取旧数据展示
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_SHOPLIST_RETURN object:nil userInfo:dic];
}

//店铺详情
- (void)requestShopInfoWithData:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor loadShopInfoWithData:data];
                   });
}

- (void)loadShopInfoDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    
    Shop *shopData = nil;
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
        shopData = [Shop shopWithDic:[dic objectForKey:kReturnDataKey]];
    }
    else
    {
        //失败读取旧数据展示
        shopData = [[Shop alloc] init];
    }
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (shopData)
    {
        [returnDic setObject:shopData forKey:kReturnDataKey];
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_SHOPINFO_RETURN object:nil userInfo:returnDic];
}

#pragma mark -
#pragma mark Find ItemList
- (NSArray *)parseGoodsListData:(NSDictionary *)dic
{
    NSArray *goodsList = [dic objectForKey:KEY_ITEMLIST];
    NSMutableArray *returnArr = [NSMutableArray array];
    for (NSDictionary *goodsDic in goodsList)
    {
        Goods *goods = [Goods goodsWithDic:goodsDic];
        [returnArr addObject:goods];
    }
    return returnArr;
}

- (void)findItemListWithData:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_naviProcessor findItemListWithData:data];
                   });
}

- (void)findItemListDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    
    if (retrunCodeM.code == kReturnSuccess)
    {
        //成功保存数据
    }
    else
    {
        //失败读取旧数据展示
    }
    
    [self notificationOnMainWith:OCC_NOTIFI_ITEMLIST_RETURN object:nil userInfo:dic];
}


@end
