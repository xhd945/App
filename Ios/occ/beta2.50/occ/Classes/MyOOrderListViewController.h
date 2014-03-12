//
//  MyOOrderListViewController.h
//  occ
//
//  Created by RS on 13-11-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyOOrderStat)
{
    MyOOrderStatWillSend=1,//
    MyOOrderStatWillReceive,//
    MyOOrderStatWillComplete,//
    MyOOrderStatWillOther,//
};

@interface MyOOrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UISearchBarDelegate>
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) MyOOrderStat stat;
@property (assign, nonatomic) int page;

-(void)setData:(NSDictionary*)data;


@end
