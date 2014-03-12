//
//  AddressListViewController.h
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayDelegate.h"

@interface AddressListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) id<PayDelegate> delegate;

@property (strong, nonatomic) OCCTableView *tableView;

@end
