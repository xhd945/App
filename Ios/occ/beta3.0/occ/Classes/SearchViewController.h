//
//  SearchViewController.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewDelegate.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    CGFloat _keyBoardHeight;
}

@property (strong, nonatomic) NSMutableArray *categoryDataList;
@property (strong, nonatomic) NSMutableArray *suggestDataList;
@property (strong, nonatomic) NSMutableDictionary *historyDataList;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) OCCNormalTableView *categoryTableView;
@property (strong, nonatomic) OCCNormalTableView *suggestTableView;
@property (strong, nonatomic) OCCNormalTableView *historyTableView;
@property (strong, nonatomic) UIView *historyFootView;

@property (assign, nonatomic) int selectIndex;

@end
