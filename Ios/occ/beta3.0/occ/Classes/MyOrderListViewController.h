//
//  OrderListViewController.h
//  occ
//
//  Created by RS on 13-8-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UISearchBarDelegate>
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) int page;

-(void)setData:(NSDictionary*)data;


@end
