//
//  MyAccountViewController.h
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindEmailViewController.h"
#import "BindPhoneViewController.h"

@interface MyAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,setEmail,setPhone>
@property (strong, nonatomic) NSMutableArray *dataList;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCNormalTableView *tableView;
@property (strong, nonatomic) UILabel *nodataLable;

@end
