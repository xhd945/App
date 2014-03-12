//
//  SearchProcessor.m
//  occ
//
//  Created by zhangss on 13-9-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "SearchProcessor.h"
#import "OCCDefine.h"
#import "ReturnCodeModel.h"

@interface SearchProcessor ()

@end

@implementation SearchProcessor

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
#pragma mark Base Category Data
- (void)loadSearchBaseCategoryData
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    
    NSString *reqdata=[_jsonWriter stringWithObject:obj];
    
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,SEARCH_BASECATEGORY];
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
        NSLog(@"%@",[request responseString]);
    }
    resultDic = [NSDictionary dictionaryWithObjectsAndKeys:returnCode,kReturnCodeKey,returnData,kReturnDataKey,nil];
    
    if ([_delegate respondsToSelector:@selector(loadSearchBaseCategoryDataCallBack:)])
    {
        [_delegate loadSearchBaseCategoryDataCallBack:resultDic];
    }
}

#pragma mark -
#pragma mark Search Data
- (void)loadSearchData:(NSDictionary *)data andSearchType:(OCCSearchClassiFication)type
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               nil];
    if (type == OCCSearchClassiFicationItem)
    {
        [obj setObject:@"item" forKey:KEY_CLASSIFICATION];
    }
    else if (type == OCCSearchClassiFicationShop)
    {
        [obj setObject:@"shop" forKey:KEY_CLASSIFICATION];
    }
    else if (type == OCCSearchClassiFicationKeyWord)
    {
        [obj setObject:KEY_KEYWORD forKey:KEY_CLASSIFICATION];
    }
    if ([data objectForKey:KEY_PAGE])
    {
        [obj setObject:[data valueForKey:KEY_PAGE] forKey:KEY_PAGE];
    }
    if ([data objectForKey:KEY_CATEGORYID])
    {
        [obj setObject:[data valueForKey:KEY_CATEGORYID] forKey:KEY_CATEGORYID];
    }
    [obj setObject:[data valueForKey:KEY_KEYWORD] forKey:KEY_KEYWORD];

    NSString *reqdata=[_jsonWriter stringWithObject:obj];
    
    
    NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,SEARCH_SUGGEST];
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
    
    ReturnCodeModel *returnCode = [self getReturnCodeFromRequest:request];
    NSDictionary *resultDic = nil;
    NSDictionary *returnData = nil;
    NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [data valueForKey:KEY_KEYWORD],KEY_KEYWORD,
                                 [data valueForKey:kRequestTypeKey],kRequestTypeKey,
                                 [NSNumber numberWithInteger:type],KEY_CLASSIFICATION,
                                 nil];
    
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
    
    if ([_delegate respondsToSelector:@selector(loadSearchDataCallBack:)])
    {
        [_delegate loadSearchDataCallBack:resultDic];
    }
}

@end
