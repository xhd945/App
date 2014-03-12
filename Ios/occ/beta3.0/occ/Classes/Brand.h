//
//  Brand.h
//  occ
//
//  Created by zhangss on 13-9-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brand : NSObject

@property(nonatomic, strong) NSString *brandName;      //品牌名称
@property(nonatomic, strong) NSString *brandIconUrl;   //品牌图片URL
@property(nonatomic, strong) NSNumber *brandID;        //品牌ID

+ (Brand *)brandWithDic:(NSDictionary *)dic;

@end
