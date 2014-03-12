//
//  GoodsListViewController.h
//  occ
//
//  Created by RS on 13-8-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsFilterViewController.h"
#import "OCCTabbar.h"

@interface GoodsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,
                        OCCTabbarDelegate,MJRefreshBaseViewDelegate>

@property (strong, nonatomic) GoodsFilterViewController *goodsFilterViewController;

@property (strong, nonatomic) NSMutableArray *dataList;  //Goods列表
@property (strong, nonatomic) NSDictionary *data;        //必填请求数据 Data/Methods
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *keyword;
@property (assign, nonatomic) int orderBy;
@property (assign, nonatomic) int page;

@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) OCCSearchBar *searchBar;
@property (strong, nonatomic) UIView *maskView;

@end
