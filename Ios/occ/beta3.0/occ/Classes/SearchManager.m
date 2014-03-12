//
//  SearchManager.m
//  occ
//
//  Created by zhangss on 13-9-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "SearchManager.h"
#import "ReturnCodeModel.h"
#import "CommonMethods.h"
#import "OCCDefine.h"
#import "NaviManager.h"

@interface SearchManager ()

@end

@implementation SearchManager

#pragma mark -
#pragma mark Init
- (id)init
{
    self = [super init];
    if (self)
    {
        _searchProcessor = [[SearchProcessor alloc] init];
        _searchProcessor.delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark Common Methods
//搜索结果返回
- (void)loadSearchDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
//    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
//    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    NSDictionary *requestData = [dic objectForKey:kRequestDataKey];
    OCCNavigationType searchType = [[requestData valueForKey:KEY_CLASSIFICATION] integerValue];
    
    if (searchType == OCCSearchClassiFicationItem)
    {
        [self loadSearchGoodsDataCallBack:dic];
    }
    else if (searchType == OCCSearchClassiFicationShop)
    {
        [self loadSearchShopDataCallBack:dic];
    }
    else if (searchType == OCCSearchClassiFicationKeyWord)
    {
        [self loadSearchSuggestDataCallBack:dic];
    }
}


#pragma mark -
#pragma mark Base Category Data
- (void)requestSearchBaseCategoryData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_searchProcessor loadSearchBaseCategoryData];
                   });
}

- (void)loadSearchBaseCategoryDataCallBack:(NSDictionary *)dic
{
    //返回结果 1.处理数据 2.通知UI
    ReturnCodeModel *retrunCodeM = [dic objectForKey:kReturnCodeKey];
    NSDictionary *resultDic = [dic objectForKey:kReturnDataKey];
    
    NSString *fileName=[NSString stringWithFormat:@"mall_%d_search_baseCategory.plist",[[Singleton sharedInstance]mall]];
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
    
    [self notificationOnMainWith:OCC_NOTIFI_SEARCH_CATEGORY_RETURN object:nil userInfo:dic];
}

#pragma mark -
#pragma mark Search Suggest
- (void)requestSearchSuggestData:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_searchProcessor loadSearchData:data andSearchType:OCCSearchClassiFicationKeyWord];
                   });
}

- (void)loadSearchSuggestDataCallBack:(NSDictionary *)dic
{
    [self notificationOnMainWith:OCC_NOTIFI_SEARCH_SUGGEST_RETURN object:nil userInfo:dic];
}


#pragma mark -
#pragma mark Search Shop
//搜索店铺
- (void)requestSearchShopData:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_searchProcessor loadSearchData:data andSearchType:OCCSearchClassiFicationShop];
                   });
}

- (void)loadSearchShopDataCallBack:(NSDictionary *)dic
{
    ReturnCodeModel *returnCode = [dic objectForKey:kReturnCodeKey];
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *shopListArr = nil;
    
    if (returnCode.code == kReturnSuccess)
    {
        //解析
        shopListArr = [[BusinessManager sharedManager].naviManager parseShopListData:[dic objectForKey:kReturnDataKey]];
    }
    else
    {
        //赋空
        shopListArr = [NSArray array];
    }
    [returnDic setObject:shopListArr forKey:kReturnDataKey];
        
    [self notificationOnMainWith:OCC_NOTIFI_SEARCH_SHOPS_RETURN object:nil userInfo:returnDic];
}

#pragma mark -
#pragma mark Search Item
//搜索商品
- (void)requestSearchGoodsData:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       [_searchProcessor loadSearchData:data andSearchType:OCCSearchClassiFicationItem];
                   });
}

- (void)loadSearchGoodsDataCallBack:(NSDictionary *)dic
{
    ReturnCodeModel *returnCode = [dic objectForKey:kReturnCodeKey];
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *goodsList = nil;
    
    if (returnCode.code == kReturnSuccess)
    {
        //解析
        goodsList = [[BusinessManager sharedManager].naviManager parseGoodsListData:[dic objectForKey:kReturnDataKey]];
    }
    else
    {
        //赋空
        goodsList = [NSArray array];
    }
    [returnDic setObject:goodsList forKey:kReturnDataKey];
    
    [self notificationOnMainWith:OCC_NOTIFI_SEARCH_GOODS_RETURN object:nil userInfo:returnDic];
}


@end
