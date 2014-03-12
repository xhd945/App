//
//  OCCCouponViewController.h
//  occ
//
//  Created by RS on 13-8-29.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayDelegate.h"

@interface OCCCouponViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UILabel *nodataLable;
@property (strong, nonatomic) IBOutlet UITableViewCell *noticeCell;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) id<PayDelegate> delegate;
@property (assign, nonatomic) NSInteger selectedIndex;

@end
