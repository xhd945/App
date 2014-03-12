//
//  UserProcessor.h
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseProcessor.h"

@protocol UserProcessorDelegate <NSObject>

- (void)loadMyFavoriteListDataCallBack:(NSDictionary *)dic;

- (void)deleteMyFavoriteCallBack:(NSDictionary *)dic;

- (void)addToFavoriteRequestCallBack:(NSDictionary *)dic;

- (void)addGoodsToCartReuqestCallBack:(NSDictionary *)dic;

@end

@interface UserProcessor : BaseProcessor

@property(nonatomic,strong)id <UserProcessorDelegate> delegate;

#pragma mark -
#pragma mark Favorite
//请求收藏列表
- (void)loadMyFavoriteListData:(NSDictionary *)requestData;

- (void)deleteMyFavorite:(NSDictionary *)requestData;

- (void)addToFavoriteRequest:(NSDictionary *)requestData;

#pragma mark -
#pragma mark Cart
- (void)addGoodsToCartReuqest:(NSDictionary *)requestData;
- (void)addOneGoodsToCartReuqest:(NSDictionary *)requestData;

@end
