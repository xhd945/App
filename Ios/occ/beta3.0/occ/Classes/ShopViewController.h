//
//  ShopViewController.h
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfoHeadView.h"
#import "GoodsGredCell.h"

typedef NS_ENUM(NSInteger , ShopModeType)
{
    ShopModeTypeList,
    ShopModeTypeGird,
    ShopModeTypeOther
};

typedef NS_ENUM(NSInteger , ShopOrderType)
{
    ShopOrderTypeNew,
    ShopOrderTypeTotal,
    ShopOrderTypePeople,
    ShopOrderTypePriceDesc,
    ShopOrderTypePriceAsc,
};

@interface ShopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UISearchBarDelegate,
                                                OCCSegementShopDelegate,GoodsGredCellDelegate>

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) ShopOrderType orderType;
@property (assign, nonatomic) ShopModeType showType;
@property (assign, nonatomic) int categoryId;
@property (assign, nonatomic) int page;

@property (strong, nonatomic) OCCSearchBar *searchBar;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UIView *tableHeaderView;
@property (strong, nonatomic) ShopInfoHeadView *shopHeaderView;
@property (strong, nonatomic) UIView *showListBtn;
@property (strong, nonatomic) UIView *showGirdBtn;

@end
