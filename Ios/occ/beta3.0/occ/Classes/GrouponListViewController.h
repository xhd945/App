//
//  GrouponListViewController.h
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCSegement.h"

@interface GrouponListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,
                                                OCCSegementDelegate,MJRefreshBaseViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) OCCTableView    *tableView;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) int type;

@end
