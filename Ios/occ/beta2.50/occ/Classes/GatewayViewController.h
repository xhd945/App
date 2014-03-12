//
//  PayListViewController.h
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//

#import <UIKit/UIKit.h>

@interface GatewayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *appCode;
@property (strong, nonatomic) NSDictionary *orderData;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray *dataList;

@property (strong, nonatomic) OCCTableView *tableView;

@end
