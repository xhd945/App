//
//  FavoriteViewController.h
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCell.h"

@interface FavoriteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,
                                    MJRefreshBaseViewDelegate,GoodsCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *selectedItemArray;
@property (assign, nonatomic) int page;

@property (strong,nonatomic)  OCCSegement *segement;
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UIView *deleteButton;
@property (strong, nonatomic) UIView *cartButton;

@end
