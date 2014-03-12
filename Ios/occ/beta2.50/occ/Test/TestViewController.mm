//
//  TestViewController.m
//  occ
//
//  Created by plocc on 13-12-8.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    UIButton *logoutButton = [[UIButton alloc]init];
    [logoutButton setFrame:CGRectMake(10, 100, SCREEN_WIDTH-20, 44)];
    [logoutButton addTarget:self action:@selector(doTest:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.titleLabel.font = FONT_16;
    [logoutButton setTitleColor:COLOR_000000 forState:UIControlStateNormal];
    [logoutButton setTitle:@"测试银联支付" forState:UIControlStateNormal];
    [self.view addSubview:logoutButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doTest:(id)sender
{
	UIViewController *viewCtrl = nil;
	//////////////////////////
	
	//testnavAppDelegate *delegate = (testnavAppDelegate*)[UIApplication sharedApplication].delegate;
	self.hidesBottomBarWhenPushed = YES;
	NSString * order = @"<?xml version=\'1.0\' encoding=\'UTF-8\'?>\
	<upomp application=\"LanchPay.Req\" version=\'1.0.0\'>\
	<merchantId>898000000000002</merchantId>\
	<merchantOrderId>201206261509021</merchantOrderId>\
	<merchantOrderTime>20120626150902</merchantOrderTime>\
	<merchantOrderAmt>1</merchantOrderAmt>\
	<sign>SznBRkvLCAziexRbfaBm7GMv4WPNUevEuPlw6vG+jxbG9PKfNBkdchTUWjFoYlgc4fcG/YNMj+JTYDjW8gyczaQWj5+pYiAkOtCDnEwnGxNUIrqZ47Xk6jbtr1b9d3rQLp8tlBYgcPa6Kzwmyv+IJgjTHxEqIw4f72fzRq5pRvY=</sign>\
	</upomp>";
	
	viewCtrl = [LTInterface getHomeViewControllerWithType:1 strOrder:order andDelegate:self];
	[self.navigationController pushViewController:viewCtrl animated:YES];
}

@end
