//
//  SettingUserNameViewController.m
//  occ
//
//  Created by mac on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "SettingUserNameViewController.h"

@interface SettingUserNameViewController ()

@end

@implementation SettingUserNameViewController

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
    
    _userNameCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [_userNameCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    _userNameCell.field.delegate=self;
    _userNameCell.field.text=[[Singleton sharedInstance] userNickname];
    _dataList = [[NSMutableArray alloc]initWithObjects:_userNameCell, nil];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"修改用户昵称"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doConfirm:) andButtonType:OCCNavigationButtonTypeCheck andLeft:NO];
    [headView addSubview:rightButton];
    
    //===================================
    UIView *tableFooterView = [[UIView alloc]init];
    [tableFooterView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *tipLable = [[UILabel alloc]init];
    [tipLable setTextColor:COLOR_999999];
    [tipLable setFont:FONT_12];
    [tipLable setBackgroundColor:[UIColor clearColor]];
    [tipLable setText:[NSString stringWithFormat:@"同时绑定到你的账号"]];
    [tipLable setFrame:CGRectMake(10,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [tipLable setTextAlignment:NSTextAlignmentLeft];
    [tableFooterView addSubview:tipLable];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:tableFooterView];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
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

- (void)doConfirm:(id)sender
{
    [self hideKeyboard];
    
    NSString *tel=_userNameCell.field.text;
    if (tel ==nil || [tel length]<=0)
    {
        [CommonMethods showTip:@"请填写用户昵称"];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  _userNameCell.field.text,@"newNickname",
                                                  nil];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:modifyUserInfo_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                      });
                       
                       NSError *error = [request error];
                       if (error)
                       {
                           NSLog(@"Failed %@ with code %d and with userInfo %@",
                                 [error domain],
                                 [error code],
                                 [error userInfo]);
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"网络异常,请检查您的网络设置!" inView:self.view];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showSuccessDialog:@"修改用户昵称成功" inView:self.view];
                                              [[Singleton sharedInstance] setUserNickname:_userNameCell.field.text];
                                              [self.delegate settingUserName:_userNameCell.field.text];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

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
    int row=indexPath.row;
    int section=indexPath.section;
    OCCFieldCell *cell=[_dataList objectAtIndex:section];
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    cell.lineImageView.hidden=YES;
    
    UILabel *selectedBackgroundView=[[UILabel alloc]init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    
    [cell setBackgroundView:backgroundView];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [_userNameCell.field resignFirstResponder];
}

@end
