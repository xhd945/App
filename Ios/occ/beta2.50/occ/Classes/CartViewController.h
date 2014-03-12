//
//  CartViewController.h
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCellDelegate.h"

@interface CartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong,nonatomic)  OCCSegement *segement;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) UILabel *totalLable;
@property (strong, nonatomic) UIView *payButton;
@property (strong, nonatomic) UIView *allButton;

@end


