//
//  LeftViewController.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) UITableView *tableView;

@end
