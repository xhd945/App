//
//  AddressModifyViewController.h
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCFieldCell.h"
#import "Address.h"

@interface AddressModifyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,
                            UIPickerViewDelegate,UIPickerViewDataSource,MBProgressHUDDelegate>
@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSMutableArray *communityDataList;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *provinceDataList;
@property (strong, nonatomic) NSMutableArray *cityDataList;
@property (strong, nonatomic) NSMutableArray *areaDataList;

@property (strong, nonatomic) IBOutlet UIToolbar *communityToolBar;
@property (strong, nonatomic) IBOutlet UIToolbar *provinceToolBar;
@property (assign, nonatomic) BOOL check;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tableFootView;

@property (strong, nonatomic) OCCFieldCell *nameCell;
@property (strong, nonatomic) OCCFieldCell *mobileCell;
@property (strong, nonatomic) OCCFieldCell *areaCell;
@property (strong, nonatomic) OCCFieldCell *detailAddrCell;

@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) UIPickerView *communityPickerview;
@property (strong, nonatomic) UIPickerView *provincePickerview;

@property (strong, nonatomic) UIView *addrHeaderView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UITextField *searchHideTextField;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIButton *checkButton;
@property (strong, nonatomic) UITextField *provinceTextField;
@property (strong, nonatomic) UITextField *cityTextField;
@property (strong, nonatomic) UITextField *areaTextField;

@property (assign, nonatomic) long communityId;
@property (assign, nonatomic) long provinceId;
@property (assign, nonatomic) long cityId;
@property (assign, nonatomic) long areaId;

- (IBAction)doSelectCommunicity:(id)sender;
- (IBAction)doSelectProvince:(id)sender;
- (IBAction)doSelectCancel:(id)sender;

@end
