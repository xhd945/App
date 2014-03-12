//
//  PayViewController.h
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

typedef NS_ENUM(NSInteger, ViewType)
{
    ViewTypeNormal=0,//
    ViewTypeOther,//
};

typedef NS_ENUM(NSInteger, ActionType)
{
    ActionTypeBizType=100,//
    ActionTypePayType,//
    ActionTypeLogisticsType,//
};

#import <UIKit/UIKit.h>
#import "PayDateViewController.h"
#import "AddressListViewController.h"
#import "PayDelegate.h"

@interface PayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,
                                    UIAlertViewDelegate,UIActionSheetDelegate,PayDelegate>

@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *totalLable;
@property (strong, nonatomic) PayDateViewController *payDateViewController;
@property (strong, nonatomic) AddressListViewController *addressListViewController;

@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) ViewType viewType;

@end
