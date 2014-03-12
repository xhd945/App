//
//  UserProcessor.m
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "UserProcessor.h"
#import "OCCDefine.h"

@implementation UserProcessor

#pragma mark -
#pragma mark Init
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark -
#pragma mark Favorite
- (void)loadMyFavoriteListData:(NSDictionary *)requestData
{
    //类型
    NSString *domain = nil;
    if ([[requestData valueForKey:KEY_CATEGORY] integerValue] == OCCSearchClassiFicationItem)
    {
        domain = USER_FAVORITLIST_GOODS;
    }
    else if ([[requestData valueForKey:KEY_CATEGORY] integerValue] == OCCSearchClassiFicationShop)
    {
        domain = USER_FAVORITLIST_SHOP;
    }
        
    //拼接Data
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    [obj setObject:[requestData objectForKey:KEY_PAGE] forKey:KEY_PAGE];
    NSString *reqdata=[_jsonWriter stringWithObject:obj];
    ZSLog(@"%@",reqdata);
    
    //请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILECENTER,domain];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
    //结果解析
    ReturnCodeModel *returnCode = [self getReturnCodeFromRequest:request];
    NSDictionary *resultDic = nil;
    NSDictionary *returnData = nil;
    
    if (returnCode.code == kReturnSuccess)
    {
        //返回成功.解析数据
        NSDictionary *root = [_jsonParser objectWithString:[request responseString]];
        returnData = [root objectForKey:@"data"];
    }
    else
    {
        //返回失败.打印信息
    }
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 requestData,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(loadMyFavoriteListDataCallBack:)])
    {
        [_delegate loadMyFavoriteListDataCallBack:resultDic];
    }
}

- (void)deleteMyFavorite:(NSDictionary *)requestData
{
    //类型
    NSString *domain = nil;
    if ([[requestData valueForKey:KEY_CATEGORY] integerValue] == OCCSearchClassiFicationItem)
    {
        domain = USER_DELETEFAVORITE_GOODS;
    }
    else if ([[requestData valueForKey:KEY_CATEGORY] integerValue] == OCCSearchClassiFicationShop)
    {
        domain = USER_DELETEFAVORITE_SHOP;
    }
    
    //拼接Data
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    [obj setObject:[requestData objectForKey:KEY_FAVOURLIST] forKey:KEY_FAVOURLIST];
    NSString *reqdata=[_jsonWriter stringWithObject:obj];
    ZSLog(@"%@",reqdata);

    //请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILECENTER,domain];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
    //结果解析
    ReturnCodeModel *returnCode = [self getReturnCodeFromRequest:request];
    NSDictionary *resultDic = nil;
    NSDictionary *returnData = nil;
    
    if (returnCode.code == kReturnSuccess)
    {
        //返回成功.解析数据
        NSDictionary *root = [_jsonParser objectWithString:[request responseString]];
        returnData = [root objectForKey:@"data"];
    }
    else
    {
        //返回失败.打印信息
    }
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 requestData,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(deleteMyFavoriteCallBack:)])
    {
        [_delegate deleteMyFavoriteCallBack:resultDic];
    }
}

- (void)addToFavoriteRequest:(NSDictionary *)requestData
{
    //拼接Data
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    //类型
    NSString *domain = nil;
    if ([[requestData valueForKey:KEY_CATEGORY] integerValue] == OCCSearchClassiFicationItem)
    {
        domain = USER_ADDFAVORITE_GOODS;
        [obj setObject:[requestData objectForKey:KEY_ID] forKey:KEY_ID];
        [obj setObject:[requestData objectForKey:KEY_NAME]==nil?@"":[requestData objectForKey:KEY_NAME] forKey:KEY_ITEMNAME];
        [obj setObject:[requestData objectForKey:KEY_FROMTYPE]==nil?[NSNumber numberWithInt:OCCFavoriteFromOther]:[requestData objectForKey:KEY_FROMTYPE] forKey:KEY_FROMTYPE];
        
        [obj setObject:[requestData objectForKey:KEY_CARTID]==nil?@"":[requestData objectForKey:KEY_CARTID] forKey:KEY_CARTID];
    }
    else if ([[requestData valueForKey:KEY_CATEGORY] integerValue] == OCCSearchClassiFicationShop)
    {
        domain = USER_ADDFAVORITE_SHOP;
        [obj setObject:[requestData objectForKey:KEY_ID] forKey:KEY_SHOPID];
        [obj setObject:[requestData objectForKey:KEY_NAME]==nil?@"":[requestData objectForKey:KEY_NAME] forKey:KEY_SHOPNAME];
    }
    
    NSString *reqdata=[_jsonWriter stringWithObject:obj];
    
    //请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILECENTER,domain];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
    //结果解析
    ReturnCodeModel *returnCode = [self getReturnCodeFromRequest:request];
    NSDictionary *resultDic = nil;
    NSDictionary *returnData = nil;
    
    if (returnCode.code == kReturnSuccess)
    {
        //返回成功.解析数据
        NSDictionary *root = [_jsonParser objectWithString:[request responseString]];
        returnData = [root objectForKey:@"data"];
    }
    else
    {
        //返回失败.打印信息
    }
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 requestData,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,
                 nil];
    
    if ([_delegate respondsToSelector:@selector(addToFavoriteRequestCallBack:)])
    {
        [_delegate addToFavoriteRequestCallBack:resultDic];
    }
}

- (void)addGoodsToCartReuqest:(NSDictionary *)requestData
{    
    //拼接Data
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    [obj setObject:[requestData objectForKey:KEY_ITEMLIST] forKey:KEY_ITEMLIST];
    NSString *reqdata=[_jsonWriter stringWithObject:obj];
    
    //请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILECENTER,USER_ADDGOODSTOCART];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
    //结果解析
    ReturnCodeModel *returnCode = [self getReturnCodeFromRequest:request];
    NSDictionary *resultDic = nil;
    NSDictionary *returnData = nil;
    
    if (returnCode.code == kReturnSuccess)
    {
        //返回成功.解析数据
        NSDictionary *root = [_jsonParser objectWithString:[request responseString]];
        returnData = [root objectForKey:@"data"];
    }
    else
    {
        //返回失败.打印信息
        ZSLog(@"123%@",[request responseString]);
    }
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 requestData,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(addGoodsToCartReuqestCallBack:)])
    {
        [_delegate addGoodsToCartReuqestCallBack:resultDic];
    }
}

- (void)addOneGoodsToCartReuqest:(NSDictionary *)requestData
{
    //拼接Data
    NSString *reqdata=[_jsonWriter stringWithObject:requestData];
    
    //请求
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:itemBuy_URL andData:reqdata andDelegate:nil];
    
    //结果解析
    ReturnCodeModel *returnCode = [self getReturnCodeFromRequest:request];
    NSDictionary *resultDic = nil;
    NSDictionary *returnData = nil;
    
    if (returnCode.code == kReturnSuccess)
    {
        //返回成功.解析数据
        NSDictionary *root = [_jsonParser objectWithString:[request responseString]];
        returnData = [root objectForKey:@"data"];
    }
    else
    {
        //返回失败.打印信息
    }
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 requestData,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(addGoodsToCartReuqestCallBack:)])
    {
        [_delegate addGoodsToCartReuqestCallBack:resultDic];
    }
}

@end
