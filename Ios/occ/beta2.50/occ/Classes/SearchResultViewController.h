//
//  SearchResultViewController.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCTabbar.h"
#import "OCCSegement.h"
#import "ShopFilterViewController.h"
#import "GoodsFilterViewController.h"

@interface SearchResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,
                        OCCTabbarDelegate,OCCSegementDelegate,MJRefreshBaseViewDelegate>

@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UIButton *goodsTabButton;
@property (strong, nonatomic) UIButton *shopTabButton;
@property (strong, nonatomic) OCCSegement *segement;

@property (strong, nonatomic) UIView *goodsView;
@property (strong, nonatomic) OCCTabbar *goodsTabView;
@property (strong, nonatomic) OCCTableView *goodsTableView;
@property (strong, nonatomic) UISearchBar *goodsSearchBar;
@property (strong, nonatomic) UIView *goodsMaskView;

@property (strong, nonatomic) UIView *shopView;
@property (strong, nonatomic) OCCTabbar *shopTabView;
@property (strong, nonatomic) OCCTableView *shopTableView;
@property (strong, nonatomic) UISearchBar *shopSearchBar;
@property (strong, nonatomic) UIView *shopMaskView;

@property (strong, nonatomic) ShopFilterViewController *shopFilterViewController;
@property (strong, nonatomic) GoodsFilterViewController *goodsFilterViewController;

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSMutableArray *shopDataList;
@property (strong, nonatomic) NSMutableArray *goodsDataList;
@property (strong, nonatomic) NSString *shopSearchKeyword;
@property (strong, nonatomic) NSString *goodsSearchKeyword;
@property (assign, nonatomic) int shopPageNo;
@property (assign, nonatomic) int shopOrderBy;
@property (assign, nonatomic) int goodsPageNo;
@property (assign, nonatomic) int goodsOrderBy;

@end
