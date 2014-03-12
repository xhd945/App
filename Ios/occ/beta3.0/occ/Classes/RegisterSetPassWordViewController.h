//
//  RegisterSetPassWordViewController.h
//  occ
//
//  Created by mac on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCFieldCell.h"
#import "LoginViewController.h"

@interface RegisterSetPassWordViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *_passWordTextField;
    UITextField *_passWordTextField1;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) OCCFieldCell *phoneCell;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSString *phoneStr;
@property (strong, nonatomic) NSString *codeStr;
@end
