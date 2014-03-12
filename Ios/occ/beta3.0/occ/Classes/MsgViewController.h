//
//  MsgViewController.h
//  occ
//
//  Created by RS on 13-9-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

typedef NS_ENUM(NSInteger, AskType)
{
    AskTypeShop,//
    AskTypeItem,//
    AskTypeGroupon,//
    AskTypeOrder,//
};

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface MsgViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,HPGrowingTextViewDelegate>
@property (strong,nonatomic) UIView *sendView;
@property (strong,nonatomic) HPGrowingTextView *msgField;     //可以输入多行的控件
@property (assign,nonatomic) CGSize keyBoardSize;  //保存键盘大小 适应IOS 5.0
@property (strong,nonatomic) UIImageView *sendBackgroundView;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) int page;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *toolBarView;

-(void)setData:(NSDictionary*)data;

@end
