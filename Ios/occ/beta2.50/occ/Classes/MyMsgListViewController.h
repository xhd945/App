//
//  MsgListViewController.h
//  occ
//
//  Created by RS on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMsgListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) int page;

-(void)setData:(NSDictionary*)data;

@end
