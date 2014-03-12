//
//  MyAccountViewController.m
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyAccountViewController.h"
#import "OCCLabelCell.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

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
    // Do any additional setup after loading the view from its nib.
    
    id email=[[Singleton sharedInstance] userEmail];
    id mobile =[[Singleton sharedInstance] userMobile];
    if (email==[NSNull null]) {
        if (mobile==[NSNull null]){
            _dataList=[NSMutableArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        @"手机号码",@"name",
                        @"未绑定",@"value",
                        nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        @"邮箱地址",@"name",
                        @"未绑定",@"value",
                        nil],
                       nil];
        }else
        {
            _dataList=[NSMutableArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        @"手机号码",@"name",
                        [[Singleton sharedInstance] userMobile],@"value",
                        nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        @"邮箱地址",@"name",
                        @"未绑定",@"value",
                        nil],
                       nil];
        }
    }else
    {
        if (mobile==[NSNull null]) {
            _dataList=[NSMutableArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        @"手机号码",@"name",
                        @"未绑定",@"value",
                        nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        @"邮箱地址",@"name",
                        [[Singleton sharedInstance] userEmail],@"value",
                        nil],
                       nil];
        }else
        {
            _dataList=[NSMutableArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        @"手机号码",@"name",
                        [[Singleton sharedInstance] userMobile],@"value",
                        nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        @"邮箱地址",@"name",
                        [[Singleton sharedInstance] userEmail],@"value",
                        nil],
                       nil];
        }
    }
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
   
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"我的账号"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    //===================================
    OCCNormalTableView *tableView=[[OCCNormalTableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS2];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [self.tableView reloadData];
}

-(void)setEmail:(NSString *)email
{
    [_dataList replaceObjectAtIndex:1 withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"邮箱地址",@"name",
                                                  email,@"value",
                                                  nil]];
    [self.tableView reloadData];
}

-(void)setPhone:(NSString *)phone
{
    [_dataList replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"手机号码",@"name",
                                                  phone,@"value",
                                                  nil]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AccountCellIdentifier=@"AccountCellIdentifier";
    
    OCCLabelCell *cell = (OCCLabelCell*)[tableView dequeueReusableCellWithIdentifier:AccountCellIdentifier];
    if (cell == nil)
    {
        cell=[[OCCLabelCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AccountCellIdentifier];
    }
    
    int row=indexPath.row;
    NSDictionary *data = [_dataList objectAtIndex:row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    switch (row) {
        case 0:
        {
            BindPhoneViewController *viewController=[[BindPhoneViewController alloc]init];
            viewController.delegate=self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 1:
        {
            BindEmailViewController *viewController=[[BindEmailViewController alloc]init];
            viewController.delegate=self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}
@end

