//
//  SearchManager.h
//  occ
//
//  Created by zhangss on 13-9-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchProcessor.h"
#import "BaseManager.h"

@interface SearchManager : BaseManager <SearchProcessprDelegate>

@property(strong,readonly)SearchProcessor *searchProcessor;

//Search的基础分类
- (void)requestSearchBaseCategoryData;

- (void)requestSearchSuggestData:(NSDictionary *)data;

- (void)requestSearchShopData:(NSDictionary *)data;

- (void)requestSearchGoodsData:(NSDictionary *)data;


@end
