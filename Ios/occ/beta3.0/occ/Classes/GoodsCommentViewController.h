//
//  shopPingLunViewController.h
//  occ
//
//  Created by mac on 13-9-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCSegement.h"
#import "GoodsCommentCell.h"

@interface GoodsCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,OCCSegementDelegate>

@property(strong,nonatomic) OCCTableView *tableView;

@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) CommentType type;

@end
