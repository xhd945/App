//
//  LeftBrandViewController.h
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"

@interface NavBrandViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UITextViewDelegate,
MJRefreshBaseViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *dataList;
@property (strong, nonatomic) NSMutableArray *letterDataList;
@property (strong, nonatomic) MJRefreshHeaderView *header;

@property (strong, nonatomic) UITableView *tableView;


@end
