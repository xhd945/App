//
//  ActivityListViewController.h
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"

@interface ActivityListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,
                                                MJRefreshBaseViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) OCCTableView *tableView;


@end
