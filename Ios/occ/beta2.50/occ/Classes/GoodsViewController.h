//
//  GoodsViewController.h
//  occ
//
//  Created by RS on 13-9-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GoodsBarginCell.h"
#import "GoodsPropCell.h"
#import "GoodsFootCell.h"
#import "GoodsHeadCell.h"
#import "OCCCartButton.h"

@interface GoodsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,
                                                 GoodsPropCellDelegate,GoodsFootCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSArray *imageList;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong,nonatomic)  GoodsFootCell *footCell;
@property (strong,nonatomic)  GoodsHeadCell *headCell;
@property (strong,nonatomic)  GoodsBarginCell *barginCell;
@property (strong,nonatomic)  GoodsPropCell *propCell;

@property (strong, nonatomic) OCCCartButton *cartButton;

@property (assign, nonatomic) long itemId;

@end
