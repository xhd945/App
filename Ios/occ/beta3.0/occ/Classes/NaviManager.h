//
//  NaviManager.h
//  occ
//
//  Created by zhangss on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NaviProcessor.h"
#import "BaseManager.h"

@interface NaviManager : BaseManager <NaviProcessprDelegate>

@property(strong,readonly)NaviProcessor *naviProcessor;

#pragma mark -
#pragma mark 缓存更新
- (void)checkVersionRequest;

#pragma mark -
#pragma mark 首页
//获取本地首页数据
- (NSArray *)getLocalFrontPageData;
//获取网络首页数据
- (void)requestFrontPage;
- (NSArray *)parseAdvertisementData:(NSDictionary *)dic;

#pragma mark -
#pragma mark 导航数据
- (NSArray *)getNaviDataFromLocalWithNaviID:(NSInteger)naviID;
- (void)loadNaviData:(NSInteger)naviId;

#pragma mark -
#pragma mark 品牌列表
- (NSArray *)getBrandListDataFromLocal;
- (void)loadBrandList;
- (NSArray *)parseBrandListData:(NSDictionary *)dic;

#pragma mark -
#pragma mark 活动列表/详情/活动分页
//活动列表/详情
- (NSArray *)getActivityListForLocal;
- (void)requestActivityListWithData:(NSDictionary *)dic;
- (void)loadActivityInfoWithData:(NSDictionary *)activityData;

#pragma mark -
#pragma mark 团购列表
- (void)requestGroupOnListWithData:(NSDictionary *)dic;

#pragma mark -
#pragma mark 店铺及店铺列表
//商铺列表/详情
- (NSArray *)parseShopListData:(NSDictionary *)dic;
- (void)findShopListWithData:(NSDictionary *)data;
- (void)requestShopInfoWithData:(NSDictionary *)data;

#pragma mark -
#pragma mark 商品及商品列表
- (NSArray *)parseGoodsListData:(NSDictionary *)dic;
- (void)findItemListWithData:(NSDictionary *)data;

#pragma mark -
#pragma mark 通用请求
- (void)requestMethodURLString:(NSString *)urlStr withData:(NSDictionary *)data;


@end
