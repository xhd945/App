//
//  NaviProcessor.m
//  occ
//
//  Created by zhangss on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NaviProcessor.h"
#import "OCCDefine.h"
#import "ReturnCodeModel.h"
#import "constant.h"

@interface NaviProcessor ()

@end

@implementation NaviProcessor

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

- (NSDictionary *)getReuqestDataWithType:(OCCRequestType)requestType andData:(NSDictionary *)data
{
    NSMutableDictionary *requestData = [NSMutableDictionary dictionaryWithCapacity:5];
    NSString *requestDomain = nil;
    
    [requestData setObject:PLOCC_DEFAULT_MALLID forKey:PLOCC_MALLKEY];
    
    switch (requestType)
    {
        case OCCRequestTypeActivityList:
        {
            requestDomain = NAVI_ACTIVITYLIST;
            break;
        }
        case OCCRequestTypeBrandList:
        {
            requestDomain = NAVI_BRANDLIST;
            break;
        }
        case OCCRequestTypeGroupOnList:
        {
            requestDomain = NAVI_GROUPONLIST;
            break;
        }
        case OCCRequestTypeNaviData:
        {
            [requestData setObject:[data valueForKey:KEY_NAVID] forKey:KEY_NAVID];
            requestDomain = NAVI_FINDNAVIGATION;
            break;
        }
        default:
            break;
    }
    return requestData;
}

#pragma mark -
#pragma makr Requst Methods

#pragma mark -
#pragma mark Version Data Info
/******************************************************************************
 函数名称 : loadVersionData
 函数描述 : 请求APP内容版本信息
 输入参数 : 无
 输出参数 : 无
 返回值 : 无
 备注 : 1.打开APP即需要请求这些数据，用于侧边栏数据展示
       2.这些数据需要缓存
 添加人: zhangss
 ******************************************************************************/
- (void)loadVersionData
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    NSString *reqdata = [_jsonWriter stringWithObject:obj];
    
    NSString *str=[NSString stringWithFormat:@"%@%@%@",
                   PLOCC_PORT,
                   PLOCC_MOBILECENTER,
                   NAVI_CHECKVERSION];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
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
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:returnCode,kReturnCodeKey,returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(loadVersionDataCallBack:)])
    {
        [_delegate loadVersionDataCallBack:resultDic];
    }
}

#pragma mark -
#pragma mark Home Page Advertisement Data
/******************************************************************************
 函数名称 : loadFrontPageData
 函数描述 : 请求首页内容
 输入参数 : 无
 输出参数 : 无
 返回值 : 无
 备注 : 1.打开APP即需要请求这些数据，用于侧边栏数据展示
 2.这些数据需要缓存
 添加人: zhangss
 ******************************************************************************/
- (void)loadFrontPageData
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    //频道编号:
    [obj setObject:@"baolongtiandi" forKey:KEY_CHANNELCODE];
    
    //平台类型 0:web 1:app
    [obj setObject:@"1" forKey:KEY_PLATFORM];
    NSString *reqdata = [_jsonWriter stringWithObject:obj];
    
    NSString *str=[NSString stringWithFormat:@"%@%@%@",
                   PLOCC_PORT,
                   PLOCC_MOBILECENTER,
                   NAVI_FRONTPAGE];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
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
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:returnCode,kReturnCodeKey,returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(loadFrontPageDataCallBack:)])
    {
        [_delegate loadFrontPageDataCallBack:resultDic];
    }
}

#pragma mark - 
#pragma mark LoadNavi Data
/******************************************************************************
 函数名称 : loadNavData
 函数描述 : 请求Navi的楼层/美食/娱乐/购物的数据
 输入参数 : 无
 输出参数 : 无
 返回值 : 无
 备注 : 1.打开APP即需要请求这些数据，用于侧边栏数据展示
       2.这些数据需要缓存
 添加人: zhangss
 ******************************************************************************/
- (void)loadNavData:(int)navId
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               [NSString stringWithFormat:@"%d",navId],KEY_NAVID,
                               nil];
    NSString *reqdata = [_jsonWriter stringWithObject:obj];
    
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,NAVI_FINDNAVIGATION];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
    ReturnCodeModel *returnCode = [self getReturnCodeFromRequest:request];
    NSDictionary *resultDic = nil;
    NSDictionary *returnData = nil;
    NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:navId],KEY_NAVID,nil];

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
    
    if ([_delegate respondsToSelector:@selector(loadNavDataCallBack:)])
    {
        [_delegate loadNavDataCallBack:resultDic];
    }
}

#pragma mark -
#pragma mark Load BrandList
/******************************************************************************
 函数名称 : loadBrandListData
 函数描述 : 请求品牌列表数据
 输入参数 : 无
 输出参数 : 无
 返回值 : 无
 备注 : 1.进入品牌选项时请求数据
       2.这些数据需要缓存???
 添加人: zhangss
 ******************************************************************************/
- (void)loadBrandListData
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    NSString *reqdata = [_jsonWriter stringWithObject:obj];
    
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,NAVI_BRANDLIST];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
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
    
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:returnCode,kReturnCodeKey,returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(loadBrandListDataCallBack:)])
    {
        [_delegate loadBrandListDataCallBack:resultDic];
    }
}

#pragma mark -
#pragma mark Load ActivityList
/******************************************************************************
 函数名称 : loadActivityListWithData:
 函数描述 : 请求活动列表数据
 输入参数 : 参数字典 包含Page参数
 输出参数 : 无
 返回值 : 无
 备注 : 1.进入活动选项时请求数据
        2.这些数据需要缓存???
 添加人: zhangss
 ******************************************************************************/
- (void)loadActivityListWithData:(NSDictionary *)dic
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    [obj setObject:[dic objectForKey:KEY_PAGE] forKey:KEY_PAGE];
    NSString *reqdata = [_jsonWriter stringWithObject:obj];
    
    //发送请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,NAVI_ACTIVITYLIST];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
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
                 dic,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(loadActivityListDataCallBack:)])
    {
        [_delegate loadActivityListDataCallBack:resultDic];
    }
}

/******************************************************************************
函数名称 : loadActivityInfoWithData:
函数描述 : 请求活动详情数据
输入参数 : 无
输出参数 : 无
返回值 : 无
备注 : 1.进入活动详情时请求数据
添加人: zhangss
******************************************************************************/
- (void)loadActivityInfoWithData:(NSDictionary *)activityData
{
    NSMutableDictionary *obj = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                [[Singleton sharedInstance]TGC], @"TGC",
                                [activityData valueForKey:KEY_ACTIVITYID], KEY_ACTIVITYID,
                                nil];
    NSString *reqdata = [_jsonWriter stringWithObject:obj];

    //发送请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,ACTIVITY_INFO];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
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
    
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:returnCode,kReturnCodeKey,returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(loadActivityInfoCallBack:)])
    {
        [_delegate loadActivityInfoCallBack:resultDic];
    }
}

#pragma mark -
#pragma mark Load GroupOnList
/******************************************************************************
 函数名称 : loadGroupOnListDataWithData:
 函数描述 : 请求团购列表数据
 输入参数 : Page
 输出参数 : 无
 返回值 : 无
 备注 : 1.进入活动选项时请求数据
 2.这些数据需要缓存???
 添加人: zhangss
 ******************************************************************************/
- (void)loadGroupOnListDataWithData:(NSDictionary *)dic;
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    [obj setObject:[dic objectForKey:KEY_PAGE] forKey:KEY_PAGE];
    [obj setObject:@"0" forKey:KEY_TYPE];
    NSString *reqdata = [_jsonWriter stringWithObject:obj];

    //发送请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_GROUPON,NAVI_GROUPONLIST];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];

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
                 dic,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(loadGroupOnListDataCallBack:)])
    {
        [_delegate loadGroupOnListDataCallBack:resultDic];
    }
}


#pragma mark -
#pragma mark Request URL and Data
/******************************************************************************
 函数名称 : requestMethodURLString: withData:
 函数描述 : 请求URL及参数
 输入参数 : Method URL 及 参数字典
 输出参数 : 无
 返回值 : 无
 备注 :
 添加人: zhangss
 ******************************************************************************/
- (void)requestMethodURLString:(NSString *)urlStr withData:(NSDictionary *)data
{
    //数据组装
    NSString *reqdata = [_jsonWriter stringWithObject:data];
    ZSLog(@"%@",reqdata);
    
    //发送请求
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:urlStr andData:reqdata andDelegate:nil];
    
    ReturnCodeModel *returnCode = [self getReturnCodeFromRequest:request];
    NSDictionary *resultDic = nil;
    NSDictionary *returnData = nil;
    NSDictionary *requestData = [NSDictionary dictionaryWithDictionary:data];
    
    if (returnCode.code == kReturnSuccess)
    {
        //返回成功.解析数据
        NSDictionary *root = [_jsonParser objectWithString:[request responseString]];
        returnData = [root objectForKey:@"data"];
    }
    else
    {
        //返回失败.打印信息
        NSLog(@"%@",[request responseString]);
    }
    
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 requestData,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(requestMethodURLStringCallBack:)])
    {
        [_delegate requestMethodURLStringCallBack:resultDic];
    }
}

#pragma mark -
#pragma mark Find ShopList
/******************************************************************************
 函数名称 : findShopListWithData:
 函数描述 : 请求店铺列表
 输入参数 : Floor及页码等
 输出参数 : 无
 返回值 : 无
 备注 : 1.进入活动选项时请求数据
 添加人: zhangss
 ******************************************************************************/
- (void)findShopListWithData:(NSDictionary *)dataDic
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    if ([dataDic valueForKey:KEY_PAGE])
    {
        [obj setObject:[dataDic valueForKey:KEY_PAGE] forKey:KEY_PAGE];
    }
    if ([dataDic valueForKey:KEY_FLOOR])
    {
        [obj setObject:[dataDic valueForKey:KEY_FLOOR] forKey:KEY_FLOOR];
    }
    if ([dataDic valueForKey:KEY_CATEGORYID])
    {
        [obj setObject:[dataDic valueForKey:KEY_CATEGORYID] forKey:KEY_PAGE];
    }
    
    NSString *reqdata = [_jsonWriter stringWithObject:obj];
    
    //发送请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,FIND_SHOPLIST];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
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
    
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:returnCode,kReturnCodeKey,returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(findShopListDataCallBack:)])
    {
        [_delegate findShopListDataCallBack:resultDic];
    }
}

/******************************************************************************
 函数名称 : loadShopInfoWithData:
 函数描述 : 请求店铺详情
 输入参数 : Floor及页码等
 输出参数 : 无
 返回值 : 无
 备注 : 1.进入活动选项时请求数据
 添加人: zhangss
 ******************************************************************************/
- (void)loadShopInfoWithData:(NSDictionary *)data
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               [data objectForKey:KEY_ORDERTYPE], KEY_ORDERTYPE,
                               [data objectForKey:KEY_SHOPID], KEY_SHOPID,
                               nil];
    NSString *reqdata = [_jsonWriter stringWithObject:obj];
    ZSLog(@"%@",reqdata);
    
    //发送请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,SHOP_INFO];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
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
                 data,kRequestDataKey,
                 returnCode,kReturnCodeKey,
                 returnData,kReturnDataKey,
                 nil];
    
    if ([_delegate respondsToSelector:@selector(loadShopInfoDataCallBack:)])
    {
        [_delegate loadShopInfoDataCallBack:resultDic];
    }
}


#pragma mark -
#pragma mark Find ItemList
/******************************************************************************
 函数名称 : findItemListWithData:
 函数描述 : 请求商品列表数据
 输入参数 : 无
 输出参数 : 无
 返回值 : 无
 备注 : 1.进入活动选项时请求数据
 添加人: zhangss
 ******************************************************************************/
- (void)findItemListWithData:(NSDictionary *)dataDic
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    if ([dataDic valueForKey:KEY_PAGE])
    {
        [obj setObject:[dataDic valueForKey:KEY_PAGE] forKey:KEY_PAGE];
    }
    if ([dataDic valueForKey:KEY_CATEGORYID])
    {
        [obj setObject:[dataDic valueForKey:KEY_CATEGORYID] forKey:KEY_PAGE];
    }
    NSString *reqdata = [_jsonWriter stringWithObject:obj];

    //发送请求
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,FIND_ITEMLIST];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
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
    
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:returnCode,kReturnCodeKey,returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(findItemListDataCallBack:)])
    {
        [_delegate findItemListDataCallBack:resultDic];
    }
}

@end
