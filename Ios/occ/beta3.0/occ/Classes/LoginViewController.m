//
//  LoginViewController.m
//  occ
//
//  Created by RS on 13-8-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessNotification:)
                                                 name:@"loginSuccessNotification"
                                               object:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    OCCFieldCell *accountCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [accountCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	accountCell.field.placeholder = @"邮箱/手机号";
    accountCell.field.delegate=self;
    accountCell.field.text=@"";
    accountCell.field.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username_bg.png"]];
    accountCell.field.leftViewMode=UITextFieldViewModeAlways;
    accountCell.field.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountCell=accountCell;
    
    OCCFieldCell *passwordCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [passwordCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	passwordCell.field.placeholder = @"请输入密码";
    passwordCell.field.delegate=self;
    passwordCell.field.text=@"";
    passwordCell.field.secureTextEntry=YES;
    passwordCell.field.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_bg.png"]];
    passwordCell.field.leftViewMode=UITextFieldViewModeAlways;
    passwordCell.field.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordCell=passwordCell;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = (NSString *)[defaults objectForKey:OCC_USER_NAME];
    if(username!=nil)
    {
        _accountCell.field.text = username;
    }
    
    NSString *userpassword = (NSString *)[defaults objectForKey:OCC_USER_PASSWORD];
    if(userpassword!=nil)
    {
        _passwordCell.field.text = userpassword;
    }

    _dataList = [[NSMutableArray alloc]initWithObjects:
                 accountCell,
                 passwordCell,
                 nil];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doCancel:)];
    [headView addSubview:leftButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"登录"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.view addSubview:titleLable];
    
    UIView *tableHeadView=[[UIView alloc]init];
    [tableHeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _tableHeadView=tableHeadView;
    
    UIView *tableFootView=[[UIView alloc]init];
    [tableFootView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    _tableFootView=tableFootView;
    
    UIView *registerButton = [CommonMethods buttonWithTitle:@"注册" withTarget:self andSelector:@selector(doRegister:) andFrame:CGRectMake(10, 10, 145, 44) andButtonType:OCCButtonTypeGreen];
    [tableFootView addSubview:registerButton];
    ((UIButton*)registerButton).titleLabel.font=FONT_16;
    
    UIView *loginButton = [CommonMethods buttonWithTitle:@"登录" withTarget:self andSelector:@selector(doLogin:) andFrame:CGRectMake(160, 10, 145, 44) andButtonType:OCCButtonTypeYellow];
    [tableFootView addSubview:loginButton];
    ((UIButton*)loginButton).titleLabel.font=FONT_16;
    
    UILabel *thirdLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, 120, 40)];
    thirdLabel.text=@"第三方账户登录";
    thirdLabel.textColor=COLOR_999999;
    thirdLabel.font=FONT_14;
    thirdLabel.backgroundColor=[UIColor clearColor];
    [tableFootView addSubview:thirdLabel];
    
    UIView *loginQQBtn = [CommonMethods buttonWithImage:@"login_qq" withTarget:self andSelector:@selector(loginQQ) andFrame:CGRectMake(10, 110, 60, 60) andButtonType:OCCButtonTypeGray];
    [tableFootView addSubview:loginQQBtn];
    
    UIView *loginWeiboBtn = [CommonMethods buttonWithImage:@"login_weibo" withTarget:self andSelector:@selector(loginWeibo) andFrame:CGRectMake(80, 110, 60, 60) andButtonType:OCCButtonTypeGray];
    [tableFootView addSubview:loginWeiboBtn];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setTableHeaderView:_tableHeadView];
    [tableView setTableFooterView:_tableFootView];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) loginSuccessNotification:(NSNotification*)notification
{
    [self doCancel:nil];
}

- (void)doCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doRegister:(id)sender
{
    RegisterViewController *viewController=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)doLogin:(id)sender
{
    [_accountCell.field resignFirstResponder];
    [_passwordCell.field resignFirstResponder];
    if(_accountCell.field.text.length==0)
    {
        [self showTip:@"请输入账号"];
        return;
    }
    
    if(_passwordCell.field.text.length==0)
    {
        [self showTip:@"请输入密码"];
        return;
    }
    
    [CommonMethods loginWithUsername:_accountCell.field.text andPassword:_passwordCell.field.text];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section=indexPath.section;
    OCCFieldCell *cell=[_dataList objectAtIndex:section];
    cell.lineImageView.hidden=YES;
    
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    [cell setBackgroundView:backgroundView];
    
    UILabel *selectedBackgroundView=[[UILabel alloc]init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)loginQQ
{
    LoginQQViewController *viewController=[[LoginQQViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)loginWeibo
{
    LoginWeiBoViewController *viewController=[[LoginWeiBoViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) showTip:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:msg
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    
    [alert show];
}

@end
