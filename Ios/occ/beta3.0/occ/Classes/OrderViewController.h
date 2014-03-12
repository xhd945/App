//
//  OrderDetailViewController.h
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyOrderType)
{
    MyOrderTyeDefault,//
    MyOrderTypeMain,//
    MyOrderTypeOther,//
};

@interface OrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (assign, nonatomic) int orderId;
@property (assign, nonatomic) MyOrderType orderType;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UIView *tableHeadView;
@property (strong, nonatomic) UILabel *headLable1;
@property (strong, nonatomic) UIView *tableFootView;
@property (strong, nonatomic) UILabel *footLable1;
@property (strong, nonatomic) UILabel *footLable2;
@property (strong, nonatomic) UILabel *footLable3;
@property (strong, nonatomic) UILabel *footLable4;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UILabel *nodataLable;
@property (strong, nonatomic) UILabel *totalLable;

-(void)setData:(NSDictionary*)data;


@end
