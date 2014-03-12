//
//  GrouponMoreViewController.h
//  occ
//
//  Created by RS on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponMoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;

@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) long groupId;

@end
