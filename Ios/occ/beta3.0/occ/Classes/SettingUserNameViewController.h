//
//  SettingUserNameViewController.h
//  occ
//
//  Created by mac on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCFieldCell.h"
@protocol setName <NSObject>

-(void)settingUserName:(NSString *)name;

@end

@interface SettingUserNameViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    OCCFieldCell *_userNameCell;

}
@property (strong, nonatomic) NSArray *dataList;
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) id<setName>delegate;
@end
