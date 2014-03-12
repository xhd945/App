//
//  GroupViewController.h
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GrouponCommentViewController.h"

#import "GrouponHeadCell.h"
#import "GrouponFootCell.h"
#import "GrouponBuyCell.h"
#import "GrouponBaseCell.h"
#import "GrouponNoticeCell.h"
#import "GrouponShopCell.h"
#import "GrouponPropCell.h"
#import "OCCCartButton.h"

@interface GrouponViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    GrouponHeadCell *_headCell;
    GrouponFootCell *_footCell;
    GrouponBuyCell *_buyCell;
    GrouponBaseCell *_baseCell;
    GrouponShopCell *_shopCell;
    GrouponNoticeCell *_noticeCell;
    GrouponPropCell *_propCell;
}

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong,nonatomic)  UIView *tableHeadView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *cartButton;

@property (assign, nonatomic) long grouponId;

@end
