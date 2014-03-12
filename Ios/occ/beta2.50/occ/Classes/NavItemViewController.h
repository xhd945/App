//
//  LeftItemViewController.h
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavItemViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) NSInteger naviID;   //导航分类
@property (assign, nonatomic) NSInteger levelId;  //导航等级 1.2.3...  1为根
@property (assign, nonatomic) NSInteger parentId; //父节点ID

@property (strong,nonatomic)  NSString *titleString;
@property (strong, nonatomic) UITableView *tableView;

@end
