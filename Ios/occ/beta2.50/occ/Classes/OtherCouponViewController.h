//
//  OtherCouponViewController.h
//  occ
//
//  Created by RS on 13-8-29.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayDelegate.h"

@interface OtherCouponViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) id<PayDelegate> delegate;
@property (assign, nonatomic) int section;
@property (assign, nonatomic) int cashCouponId;

@property (strong, nonatomic) IBOutlet UITableViewCell *noticeCell;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UILabel *nodataLable;

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) ASIFormDataRequest *request;
@property (strong, nonatomic) NSString *shopName;

@end
