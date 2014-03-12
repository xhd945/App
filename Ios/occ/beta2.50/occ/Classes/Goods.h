//
//  Goods.h
//  occ
//
//  Created by zhangss on 13-9-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goods : NSObject

@property (nonatomic, strong) NSString *goodsName;       //商品名称
@property (nonatomic, strong) NSString *goodsImage;      //商品图片
@property (nonatomic, strong) NSNumber *goodsType;       //商品类型
@property (nonatomic, strong) NSNumber *goodsID;         //商品ID
@property (nonatomic, strong) NSNumber *goodsIsCart;     //商品是否在购物车
@property (nonatomic, strong) NSNumber *goodsIsFavour;   //商品是否被收藏
@property (nonatomic, strong) NSNumber *goodsListPrice;  //商品价格
@property (nonatomic, strong) NSNumber *goodsPLPrice;    //商品宝龙价格
@property (nonatomic, strong) NSNumber *goodsSellNum;    //商品月销量
@property (nonatomic, strong) NSNumber *goodsFavourID;   //商品的收藏ID
@property (nonatomic, strong) NSNumber *goodsFavourNum;  //商品的收藏总数
@property (nonatomic, strong) NSString *goodsProp;       //商品规格描述
@property (nonatomic, strong) NSString *goodsDetailURL;  //商品详情

+ (Goods *)goodsWithDic:(NSDictionary *)dic;

@end
