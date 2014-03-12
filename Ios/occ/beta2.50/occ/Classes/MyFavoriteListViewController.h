//
//  FavoriteListViewController.h
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCell.h"
#import "ShopCell.h"

@interface MyFavoriteListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
                                            OCCSegementDelegate,GoodsCellDelegate,ShopCellDelegate,MJRefreshBaseViewDelegate>

@property (strong, nonatomic) NSMutableArray *shopDataList;
@property (strong, nonatomic) NSMutableArray *goodsDataList;
@property (strong, nonatomic) NSMutableArray *selectedShopArray;
@property (strong, nonatomic) NSMutableArray *selectedItemArray;
@property (assign, nonatomic) NSInteger   shopPage;
@property (assign, nonatomic) NSInteger   goodsPage;

@property (strong, nonatomic) OCCTableView *goodsTable;
@property (strong, nonatomic) OCCTableView *shopTable;
@property (strong, nonatomic) UIView *rightBarButton;
@property (strong, nonatomic) UIView *leftBarButton;

@end
