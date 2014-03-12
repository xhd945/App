//
//  Shop.h
//  occ
//
//  Created by zhangss on 13-9-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

@property (nonatomic, strong) NSString *shopName;       //店铺名称
@property (nonatomic, strong) NSString *shopBrief;      //店铺简介
@property (nonatomic, strong) NSString *shopType;       //店铺类型
@property (nonatomic, strong) NSString *shopLogo;       //店铺图标
@property (nonatomic, strong) NSString *shopImage;      //店铺图片 与Logo重复
@property (nonatomic, strong) NSNumber *shopRating;     //店铺评分
@property (nonatomic, strong) NSNumber *shopFavourNum;  //店铺收藏人数
@property (nonatomic, strong) NSNumber *shopViewNum;    //店铺浏览人数
@property (nonatomic, strong) NSNumber *shopID;         //店铺ID
@property (nonatomic, strong) NSNumber *shopItemNum;    //店铺商品总数
@property (nonatomic, strong) NSArray *shopItemList;    //店铺商品列表
@property (nonatomic, strong) NSNumber *shopFavourID;   //店铺的收藏ID
@property (nonatomic, strong) NSArray *shopCategoryList;   //

+ (Shop *)shopWithDic:(NSDictionary *)dic;

@end
