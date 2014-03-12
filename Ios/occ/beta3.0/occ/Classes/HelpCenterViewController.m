//
//  HelpCenterViewController.m
//  occ
//
//  Created by mac on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "OneLineCell.h"

#define KEY_TITLE   @"title"
#define KEY_VALUE   @"value"

@interface HelpCenterViewController ()

@end

@implementation HelpCenterViewController

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
    NSArray *arr1 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys: @"如何注册",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/newbie/howToRegister.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"会员特享",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/newbie/memberSpecial.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"在商场内使用APP",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/newbie/mallUseApp.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"使用购物车",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/newbie/useShoppingCart.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"管理订单和计算运费",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/newbie/orderAndCalculate.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"发票与售后",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/newbie/invoiceAndAfter.htm",@"url",nil],
                     nil];
    
    NSArray *arr2 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"与商家沟通",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/shoppingOrExp/andBusinessCommu.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"在商场内使用APP",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/shoppingOrExp/mallUseApp.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"使用购物车",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/shoppingOrExp/useShoppingCart.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"管理订单和计算运费",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/shoppingOrExp/orderAndCalculate.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"优惠与宝龙团购",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/shoppingOrExp/preferOrBaolongBuy.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"发票与售后",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/newbie/invoiceAndAfter.htm",@"url",nil],
                     nil];
    
    NSArray *arr3 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"在线支付",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/pay/onlinePay.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"货到付款",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/pay/cashOnDelivery.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"其他",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/pay/other.htm",@"url",nil],
                     nil];
    
    NSArray *arr4 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"宝龙急送",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/dispatching/powerlongquickysend.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"一般快递",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/dispatching/gensend.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"自提与现提",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/dispatching/myselfgetitem.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"退换货的配送规则",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/dispatching/returnitemrule.htm",@"url",nil],
                     nil];
    
    NSArray *arr5 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"付款保护期",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/customerservice/merchandisecustomerservice.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"商品售后",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/customerservice/paymentsafe.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"退换货与退款",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/customerservice/returnitemandrefund.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"常见问题",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/customerservice/commonquestion.htm",@"url",nil],
                     nil];
    
    NSArray *arr6 = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"账户身份",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/privacyandsecurity/accountandidentity.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"隐私声明",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/privacyandsecurity/privacyandstatement.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"所有权与风险",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/privacyandsecurity/titleandrisk.htm",@"url",nil],
                     [[NSDictionary alloc]initWithObjectsAndKeys:@"您的权利",@"name",@"http://www.ipowerlong.com/userWeb/open/help/forward/apphelp/privacyandsecurity/yourrights.htm",@"url",nil],
                     nil];
    
    _titleList = [[NSArray alloc] initWithObjects:
                  @"新手上路",
                  @"购物与体验",
                  @"支付",
                  @"配送",
                  @"售后",
                  @"隐私与安全",
                  nil];
    
    _dataList = [[NSMutableArray alloc] initWithObjects:arr1,arr2,arr3,arr4,arr5,arr6,nil];
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"帮助中心"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
        
    //===================================
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS2];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section=indexPath.section;
    int row=indexPath.row;
    static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
    
    OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
    if (cell == nil)
    {
        cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
    }
    cell.lineStyle=OneLineCellLineTypeNone;
    cell.rightStyle=OneLineCellRightCheck;
    
    UIView *backgroundView=[[UIView alloc]init];
    [backgroundView setBackgroundColor:COLOR_BG_CLASSONE];
    cell.backgroundView=backgroundView;
    
    cell.selectedBackgroundView=[CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassOne];

    NSDictionary *data = [[_dataList objectAtIndex:section]objectAtIndex:row];
    [cell setData:data];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section=indexPath.section;
    int row=indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = [[_dataList objectAtIndex:section]objectAtIndex:row];
    ReturnSalesViewController *viewController=[[ReturnSalesViewController alloc]init];
    [viewController setData:data];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
