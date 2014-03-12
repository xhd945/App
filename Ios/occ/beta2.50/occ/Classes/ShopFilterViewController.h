//
//  ShopFilterViewController.h
//  occ
//
//  Created by RS on 13-8-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulerView.h"

@interface ShopFilterViewController :  UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *secondDataList;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *priceFrom;
@property (strong, nonatomic) NSString *priceTo;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView* headTableView;
@property (strong, nonatomic) UIView* footTableView;
@property (strong, nonatomic) UIView* foot1TableView;
@property (strong, nonatomic) UIView* foot2TableView;
@property (strong, nonatomic) NMRangeSlider *rangeSlider;

@end
