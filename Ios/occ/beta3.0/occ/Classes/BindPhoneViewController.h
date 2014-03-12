//
//  BindPhoneViewController.h
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setPhone <NSObject>

-(void)setPhone:(NSString *)phone;

@end
@interface BindPhoneViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UITextField *_phoneTextField;
    UITextField *_codeTextField;
    UIButton *_getNoteBtn;
}

@property (strong, nonatomic) NSArray *dataList;
@property (strong,nonatomic)  UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *nodataLable;
@property (assign, nonatomic) id<setPhone>delegate;

@property (strong, nonatomic) NSTimer *myTimer;
@property (assign, nonatomic) int downup;

@end
