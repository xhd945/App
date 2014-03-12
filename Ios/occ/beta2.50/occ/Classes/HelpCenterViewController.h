//
//  HelpCenterViewController.h
//  occ
//
//  Created by mac on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnSalesViewController.h"


@interface HelpCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic) NSArray * titleList;
@property (retain,nonatomic) NSMutableArray * dataList;

@property (strong, nonatomic) UITableView *tableView;

@end
