//
//  SearchProcessor.h
//  occ
//
//  Created by zhangss on 13-9-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseProcessor.h"

@protocol SearchProcessprDelegate <NSObject>

- (void)loadSearchBaseCategoryDataCallBack:(NSDictionary *)dic;

- (void)loadSearchDataCallBack:(NSDictionary *)dic;

@end

@interface SearchProcessor : BaseProcessor
{
}

@property(nonatomic,strong)id <SearchProcessprDelegate> delegate;

- (void)loadSearchBaseCategoryData;

- (void)loadSearchData:(NSDictionary *)data andSearchType:(OCCSearchClassiFication)type;


@end
