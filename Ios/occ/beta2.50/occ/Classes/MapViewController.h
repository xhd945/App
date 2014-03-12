//
//  MapViewController.h
//  occ
//
//  Created by RS on 13-9-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController<UISearchBarDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (strong, nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) int downup;
@property (assign, nonatomic) int floor;
@property (assign, nonatomic) int shopId;

@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) OCCSearchBar *searchBar;
@property (strong, nonatomic) OCCTableView *tableView;
@property (strong, nonatomic) OCCWebView *webView;

@property (strong, nonatomic) UIButton *btnShow;
@property (strong, nonatomic) UIButton *btnHide;
@property (strong, nonatomic) UIView *footView;
@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) UIButton *btnB1;
@property (strong, nonatomic) UIButton *btn1F;
@property (strong, nonatomic) UIButton *btn2F;
@property (strong, nonatomic) UIButton *btn3F;
@property (strong, nonatomic) UIButton *btn4F;
@property (strong, nonatomic) UIButton *btn5F;

- (void)searchByShopId:(int)shopId;
- (void)research;

@end
