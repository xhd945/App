//
//  FloorViewController.h
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavFloorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) NSInteger naviID;

@property (strong, nonatomic) UITableView *tableView;

@end
