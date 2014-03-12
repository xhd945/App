//
//  CouponsListViewController.h
//  occ
//
//  Created by RS on 13-8-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

typedef NS_ENUM(NSInteger, GrouponType)
{
    GrouponTypeUnused=1,//不使用
    GrouponTypeUsed,//已使用
};

#import <UIKit/UIKit.h>
#import "OCCSegement.h"

@interface MyGrouponListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,OCCSegementDelegate>
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) GrouponType type;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;

@end
