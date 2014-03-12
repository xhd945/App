//
//  RegisterViewController.h
//  occ
//
//  Created by RS on 13-8-8.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCFieldCell.h"
#import "OCCSegement.h"
#import "ServiceViewController.h"

@interface RegisterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,
                                    MBProgressHUDDelegate,OCCSegementDelegate>
{
    UITableView *_tableView;
    UITableView *_tableView1;
    UITextField *_phoneTextField;
    UITextField *_passWordTextField;
    UIView *_rightButton;
    UITextField *_emailTextField;
    UITextField *_areaTextField;
    UIButton *_areaButton;
    UILabel *_arealabel;
    UILabel *_areaNumberLabel;
    BOOL isAcion;
    NSArray *_areaArr;
}

@property (strong,nonatomic)  NSArray *pickerDataList;
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *hideTextField;
@property (strong,nonatomic) UIPickerView *pickerView;

@end
