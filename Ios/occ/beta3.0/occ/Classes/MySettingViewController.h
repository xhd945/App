//
//  SettingViewController.h
//  occ
//
//  Created by RS on 13-8-8.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingUserNameViewController.h"
#import "HelpCenterViewController.h"
#import "AboutPowerLongViewController.h"
#import "ServiceViewController.h"

@interface MySettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,setName>

@property (strong, nonatomic) UITableView *tableView;

@property (retain,nonatomic) NSArray * titleList;
@property (retain,nonatomic) NSMutableArray * dataList;

@end
