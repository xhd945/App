//
//  RegisterNextViewController.h
//  occ
//
//  Created by RS on 13-9-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCFieldCell.h"
#import "RegisterSetPassWordViewController.h"

@interface RegisterCodeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong,nonatomic)  UIView *tableHeadView;
@property (strong,nonatomic)  UIView *tableFootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) OCCFieldCell *codeCell;
@property (strong, nonatomic) UIButton *timerButton;

@property (strong, nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSString *phoneStr;
@property (strong, nonatomic) NSString *areaStr;
@property (assign, nonatomic) int downup;

@end
