//
//  UserManager.h
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"
#import "UserProcessor.h"


@interface UserManager : BaseManager <UserProcessorDelegate>
{
    UserProcessor *_userProcessor;
}

#pragma mark -
#pragma mark FavoriteList
- (void)requestMyFavoriteList:(NSDictionary *)dic;

// Delete MyFavorite
- (void)deleteMyFavoriteReuqest:(NSDictionary *)dic;

//Add Favorite
- (void)addToFavoriteRequest:(NSDictionary *)dic;

#pragma mark -
#pragma mark Cart
//Add to Cart
- (void)addGoodsToCart:(NSDictionary *)dic;
- (void)addOneGoodsToCart:(NSDictionary *)dic;

@end
