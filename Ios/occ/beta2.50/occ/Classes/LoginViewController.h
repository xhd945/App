//
//  LoginViewController.h
//  occ
//
//  Created by RS on 13-8-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCFieldCell.h"
#import "LoginQQViewController.h"
#import "LoginWeiBoViewController.h"

@interface LoginViewController :UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataList;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong,nonatomic)  UIView *tableHeadView;
@property (strong,nonatomic)  UIView *tableFootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) OCCFieldCell *accountCell;
@property (strong, nonatomic) OCCFieldCell *passwordCell;

@property (strong, nonatomic) ASIFormDataRequest *request;

@end
