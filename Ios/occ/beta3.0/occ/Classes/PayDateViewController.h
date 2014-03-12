//
//  PayDataViewController.h
//  occ
//
//  Created by RS on 13-8-28.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCFieldCell.h"
#import "PayDelegate.h"

@interface PayDateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
                                   UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) id<PayDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *dateList;
@property (strong, nonatomic) NSMutableArray *timeList;

@property (strong, nonatomic) UIPickerView *datePicker;
@property (strong, nonatomic) UIPickerView *timePicker;
@property (strong, nonatomic) OCCFieldCell *dateCell;
@property (strong, nonatomic) OCCFieldCell *timeCell;
@property (strong, nonatomic) UITableView *tableView;

@end
