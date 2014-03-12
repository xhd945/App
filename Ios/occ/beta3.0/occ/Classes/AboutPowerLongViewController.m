//
//  AboutPowerLongViewController.m
//  occ
//
//  Created by mac on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "AboutPowerLongViewController.h"

@interface AboutPowerLongViewController ()

@end

@implementation AboutPowerLongViewController

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
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:@"关于我们"];
    //[NSString stringWithFormat:@"关于%@",kBaoLongTitle]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UITextField *tfUS = [[UITextField alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 80)];
    [tfUS setFont:FONT_40];
    [tfUS setTextAlignment:NSTextAlignmentCenter];
    tfUS.text = @"宝龙广场在线";
    [self.view addSubview:tfUS];
    
    /*
    UIImageView *backGroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    backGroundView.frame=CGRectMake(50, 150, 220, 80);
    [self.view addSubview:backGroundView];
    */
    
    UIImageView *lineImgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line_dotted.png"]];
    lineImgv.frame=CGRectMake(0, 250, 320, 2);
    [self.view addSubview:lineImgv];
    
    NSString *versionCur = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    UILabel *versionsNumberlabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 270, 80, 30)];
    versionsNumberlabel.text=[NSString stringWithFormat:@"版本号:%@",versionCur];
    versionsNumberlabel.font=FONT_12;
    versionsNumberlabel.textColor=[UIColor grayColor];
    versionsNumberlabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:versionsNumberlabel];
    
    UILabel *phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 300, 130, 30)];
    phoneLabel.text=@"客户电话:400-007-1111";
    phoneLabel.font=FONT_12;
    phoneLabel.textColor=[UIColor grayColor];
    phoneLabel.backgroundColor=[UIColor clearColor];
    //[self.view addSubview:phoneLabel];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
