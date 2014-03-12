//
//  GoodsFilterLeftViewController.h
//  occ
//
//  Created by RS on 13-10-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface GoodsFilterLeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSMutableArray *firstDataList;
@property (strong, nonatomic) NSDictionary *data;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView* foot1TableView;

@end
