//
//  SearchFilterViewController.h
//  occ
//
//  Created by RS on 13-8-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulerView.h"

@interface GoodsFilterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSMutableArray *firstDataList;
@property (strong, nonatomic) NSString *priceFrom;
@property (strong, nonatomic) NSString *priceTo;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView* foot1TableView;

@end
