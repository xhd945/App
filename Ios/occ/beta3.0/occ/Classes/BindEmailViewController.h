//
//  BindEmailViewController.h
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCFieldCell.h"

@protocol setEmail <NSObject>

-(void)setEmail:(NSString *)email;

@end
@interface BindEmailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    OCCFieldCell *_emilCell;

}
@property (strong, nonatomic) NSArray *dataList;
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *nodataLable;
@property (assign, nonatomic) id<setEmail>delegate;


@end
