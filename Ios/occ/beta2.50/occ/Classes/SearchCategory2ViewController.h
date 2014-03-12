//
//  SearchSuggestViewController.h
//  occ
//
//  Created by RS on 13-8-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCategory2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray *dataList;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) OCCTableView *tableView;

@end
