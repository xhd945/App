//
//  NearbyViewController.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewDelegate.h"

@interface NearbyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int _expandRow;
}
@property (weak, nonatomic) id<HomeViewDelegate> delegate;
@property (strong, nonatomic) NSArray *dataList;

@property (strong, nonatomic) UIImageView *tableHeaderImageView;
@property (strong, nonatomic) UITableView *tableView;

@property (assign,nonatomic)  BOOL topView;

@end
