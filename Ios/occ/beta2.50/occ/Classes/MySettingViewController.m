//
//  SettingViewController.m
//  occ
//
//  Created by RS on 13-8-8.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MySettingViewController.h"
#import "MyAccountViewController.h"
#import "OneLineCell.h"

typedef NS_ENUM(NSInteger, AlertType)
{
    AlertTypeLogout=100,//
    AlertTypeService,//
};

@interface MySettingViewController ()

@end

@implementation MySettingViewController

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
   
    NSArray *arr1 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys: [[Singleton sharedInstance] userNickname],@"name",@"",@"value",nil],
                      nil];
    
    NSArray *arr2 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys:[[Singleton sharedInstance] userName],@"name",@"",@"value",nil],
                     nil];
    
    NSArray *arr3 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"接收通知",@"name",@"",@"value",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"通知时段",@"name",@"",@"value",nil],
                      nil];
    
    NSArray *arr4 = [[NSArray alloc] initWithObjects:
                       [[NSDictionary alloc]initWithObjectsAndKeys:@"帮助中心",@"name",@"",@"value",nil],
                       //[[NSDictionary alloc]initWithObjectsAndKeys:@"联系客服",@"name",@"",@"value",nil],
                       //[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"给%@评个分吧!",kBaoLongTitle],@"name",@"",@"value",nil],
                       nil];
    
    NSArray *arr5 = [[NSArray alloc] initWithObjects:
                       [[NSDictionary alloc]initWithObjectsAndKeys:@"版本更新",@"name",@"",@"value",nil],
                       [[NSDictionary alloc]initWithObjectsAndKeys:@"关于我们",@"name",@"",@"value",nil],
                       //[[NSDictionary alloc]initWithObjectsAndKeys:@"服务协议",@"name",@"",@"value",nil],
                       nil];
    
    _titleList = [[NSArray alloc] initWithObjects:@"用户昵称",
                  @"我的账号",
                  @"接收通知",
                  [NSString stringWithFormat:@"支持%@",kBaoLongTitle],
                  @"关于",
                  nil];
    
    _dataList = [[NSMutableArray alloc] initWithObjects:arr1,arr2,arr3,arr4,arr5,nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"设置"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    tableView.separatorColor = COLOR_CELL_LINE_CLASS2;
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    UIView *tableFooterView = [[UIView alloc]init];
    [tableFooterView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT*2)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    
    UIImage *bgImage = [UIImage imageNamed:@"btn_bg_red"];
    
    UIButton *logoutButton = [[UIButton alloc]init];
    [logoutButton setFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 44)];
    [logoutButton setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2] forState:UIControlStateNormal];
    [logoutButton setImage:[UIImage imageNamed:@"logout.png"]  forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.titleLabel.font = FONT_16;
    [logoutButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [logoutButton setTitle:@"注销当前账号" forState:UIControlStateNormal];
    [tableFooterView addSubview:logoutButton];
    [tableView setTableFooterView:tableFooterView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingUserName:(NSString *)name
{
    NSArray *arr = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys: name,@"name",@"",@"value",nil],
                     nil];
    [_dataList replaceObjectAtIndex:0 withObject:arr];
    [self.tableView reloadData];

}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doLogout:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确定要注销吗?"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确定"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag=AlertTypeLogout;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [headView setBackgroundColor:COLOR_F3EFEC];
    
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, headView.frame.size.height-1, SCREEN_WIDTH, 1);
    lineView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"line2"]];
    [headView addSubview:lineView];
    
    UILabel *label=[[UILabel alloc]init];
    [label setFrame:CGRectMake(15, 0, SCREEN_WIDTH, headView.frame.size.height)];
    [label setText:[_titleList objectAtIndex:section]];
    [label setTextColor:COLOR_999999];
    [label setFont:FONT_14];
    [label setBackgroundColor:[UIColor clearColor]];
    [headView addSubview:label];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataList objectAtIndex:section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
    
    OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
    if (cell == nil)
    {
        cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
    }
    cell.lineStyle=OneLineCellLineTypeNone;
    
    UIView *backgroundView=[[UIView alloc]init];
    [backgroundView setBackgroundColor:COLOR_BG_CLASSONE];
    cell.backgroundView=backgroundView;

    cell.selectedBackgroundView=[CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassOne];
    
    if (section==2 && row==0)
    {
        cell.rightStyle=OneLineCellRightNone;
        cell.lineImageView.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:[[_dataList objectAtIndex:section]objectAtIndex:row]];
        
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(230, 10, 20, 14)];
        [switchButton setOn:YES];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchButton];
        return cell;
    }
    
    else if (section==2&&row==1)
    {
        cell.rightStyle=OneLineCellRightNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:[[_dataList objectAtIndex:section]objectAtIndex:row]];
        
        UILabel *timeLabel=[[UILabel alloc]init];
        [timeLabel setFrame:CGRectMake(0, 10, 300, 14)];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setText:@"09:00-21:00"];
        [timeLabel setFont:FONT_12];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:timeLabel];
        return cell;
    }
    
    else
    {
        cell.rightStyle=OneLineCellRightCheck;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:[[_dataList objectAtIndex:section]objectAtIndex:row]];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    switch (section) {
        case 0:
        {
            if (row==0)
            {
                SettingUserNameViewController *viewController=[[SettingUserNameViewController alloc]init];
                viewController.delegate=self;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (row==1)
            {
                
            }
            break;
        }
        case 1:
        {
            if (row==0)
            {
                MyAccountViewController *viewController=[[MyAccountViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        }
        case 3:
        {
            if (row==0)
            {
                HelpCenterViewController *viewController=[[HelpCenterViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (row==1)
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"客服电话:400-007-1111"
                                              delegate:self
                                              cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"确定"
                                              otherButtonTitles:nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                actionSheet.tag=AlertTypeService;
                [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            }
            else if (row==2)
            {
                NSString *str = [NSString stringWithFormat:
                                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                                 APP_ID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
            break;
        }
        case 4:
        {
            if (row==0)
            {
                [CommonMethods checkVersionWithTarget:[[UIApplication sharedApplication]delegate] andSlience:NO];
            }
            else if (row==1)
            {
                AboutPowerLongViewController *viewController=[[AboutPowerLongViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (row==2)
            {
                ServiceViewController *viewController=[[ServiceViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

-(void)switchAction:(id)sender
{
    

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if (actionSheet.tag==AlertTypeLogout) {
                [self logout];
            }else if (actionSheet.tag==AlertTypeService) {
                [self contactCustomer];
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

- (void)logout
{
    [[Singleton sharedInstance]setTGC:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutSuccessNotification" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)contactCustomer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000071111"]];
}
@end