//
//  ServiceViewController.m
//  occ
//
//  Created by mac on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController

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
    UIImageView *backGroundImgv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backGroundImgv.backgroundColor=COLOR_BG_CLASSONE;
    [self.view addSubview:backGroundImgv];
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"服务协议"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"occfile"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *textFile  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    UITextView *textView=[[UITextView alloc]init];
    [textView setFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-HEADER_HEIGHT)];
    [textView setText:textFile];
    [self.view addSubview:textView];
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
