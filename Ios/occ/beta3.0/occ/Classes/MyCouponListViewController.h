//
//  YouhuiListViewController.h
//  occ
//
//  Created by RS on 13-8-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCSegement.h"

typedef NS_ENUM(NSInteger, CouponType)
{
    CouponTypeLasted,//当前最新
    CouponTypeMy,//我的优惠券
};

@interface MyCouponListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,OCCSegementDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) CouponType type;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) OCCSearchBar *searchBar;

-(void)setData:(NSDictionary*)data;

@end
