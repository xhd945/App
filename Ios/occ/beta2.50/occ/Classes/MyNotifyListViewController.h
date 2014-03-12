//
//  NoticeListViewController.h
//  occ
//
//  Created by RS on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCSegement.h"

typedef NS_ENUM(NSInteger, NotifyType)
{
    NotifyTypeSystem,//
    NotifyTypeTrade,//
    NotifyTypeAll=9,//
};

@interface MyNotifyListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,OCCSegementDelegate>
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) NotifyType type;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;

-(void)setData:(NSDictionary*)data;

@end
