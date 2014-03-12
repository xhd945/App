//
//  OCCTableView.h
//  occ
//
//  Created by RS on 13-9-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

typedef NS_ENUM(NSInteger, DataType)
{
    DataTypeShop,//
    DataTypeGoods,//
    DataTypeCart,//
    DataTypeFavoriteShop,//
    DataTypeFavoriteGoods,//
    DataTypeGrouponCode,//
    DataTypeCouponCode,//
    DataTypeOther,//
};

#import <UIKit/UIKit.h>

@interface OCCTableView : UITableView
@property (strong, nonatomic) UIView *nodataView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) NSString *tip;

@property (assign, nonatomic) DataType dataType;
@property (assign, nonatomic) BOOL loading;

- (id)initWithFrame:(CGRect)frame andDataType:(DataType)type;

@end
