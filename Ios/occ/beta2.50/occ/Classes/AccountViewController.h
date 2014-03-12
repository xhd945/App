//
//  AccountViewController.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewDelegate.h"
#import "OCCBadgeButton.h"

@interface AccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) id<HomeViewDelegate> delegate;

@property (strong, nonatomic) UIView *notloginView;

@property (strong, nonatomic) UIView *accountView;
@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UILabel *nameLable;;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UILabel *notifyNumLable;
@property (strong, nonatomic) UILabel *msgNumLable;
@property (strong, nonatomic) UIImageView *personImageView;

@property (strong, nonatomic) OCCBadgeButton *orderButton1;
@property (strong, nonatomic) OCCBadgeButton *orderButton2;
@property (strong, nonatomic) OCCBadgeButton *orderButton3;
@property (strong, nonatomic) OCCBadgeButton *orderButton4;

@end
