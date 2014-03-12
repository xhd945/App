//
//  NaviProcessor.h
//  occ
//
//  Created by zhangss on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseProcessor.h"

typedef NS_ENUM(NSInteger, OCCRequestType)
{
    OCCRequestTypeNaviData,
    OCCRequestTypeBrandList,
    OCCRequestTypeActivityList,
    OCCRequestTypeGroupOnList
};


@protocol NaviProcessprDelegate <NSObject>

//HTTP结果回调
- (void)loadVersionDataCallBack:(NSDictionary *)dic;

- (void)loadFrontPageDataCallBack:(NSDictionary *)dic;

- (void)loadNavDataCallBack:(NSDictionary *)dic;

- (void)loadBrandListDataCallBack:(NSDictionary *)dic;

//Activity List/Info
- (void)loadActivityListDataCallBack:(NSDictionary *)dic;
- (void)loadActivityInfoCallBack:(NSDictionary *)dic;

- (void)loadGroupOnListDataCallBack:(NSDictionary *)dic;

- (void)requestMethodURLStringCallBack:(NSDictionary *)dic;

//Shop List/Info
- (void)findShopListDataCallBack:(NSDictionary *)dic;
- (void)loadShopInfoDataCallBack:(NSDictionary *)dic;

- (void)findItemListDataCallBack:(NSDictionary *)dic;

@end

@interface NaviProcessor : BaseProcessor
{
    
}

@property(nonatomic,strong)id <NaviProcessprDelegate> delegate;

//请求版本信息
- (void)loadVersionData;

//请求Home页的数据
- (void)loadFrontPageData;

//获取导航列表数据
- (void)loadNavData:(int)nav_id;

//获取品牌列表
- (void)loadBrandListData;

//获取活动列表/详情
- (void)loadActivityListWithData:(NSDictionary *)dic;
- (void)loadActivityInfoWithData:(NSDictionary *)activityData;

//获取团购列表
- (void)loadGroupOnListDataWithData:(NSDictionary *)dic;

//请求固定方法及参数
- (void)requestMethodURLString:(NSString *)urlStr withData:(NSDictionary *)data;

//店铺列表/详情
- (void)findShopListWithData:(NSDictionary *)dataDic;
- (void)loadShopInfoWithData:(NSDictionary *)data;

//
- (void)findItemListWithData:(NSDictionary *)dataDic;

@end
