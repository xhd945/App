//
//  PayViewController.m
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "PayViewController.h"
#import "Address1Cell.h"
#import "PayShopCell.h"
#import "PayMessageCell.h"
#import "PayItemCell.h"
#import "PayActivityCell.h"
#import "OneLineCell.h"
#import "AddressAddViewController.h"
#import "AddressListViewController.h"
#import "PayDateViewController.h"
#import "GatewayViewController.h"
#import "OCCCouponViewController.h"
#import "OtherCouponViewController.h"
#import "GoodsViewController.h"
#import "GrouponViewController.h"
#import "MyOOrderListViewController.h"

@interface PayViewController ()

@end

@implementation PayViewController

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
    self.ViewType=ViewTypeNormal;
    [Singleton sharedInstance].payData=[[NSMutableDictionary alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addAddressSuccessNotification:)
                                                 name:@"addAddressSuccessNotification"
                                               object:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    UIView *footView = [[UIView alloc]init];
    [footView setFrame:CGRectMake(0, SCREEN_HEIGHT-HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    [footView setBackgroundColor:COLOR_BG_CLASSTHREE];
    [self.view addSubview:footView];

    //UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    //[footView addSubview:topImageView];
    
    UILabel *totalLable = [[UILabel alloc]init];
    [totalLable setTextColor:COLOR_FFFFFF];
    [totalLable setFont:FONT_12];
    [totalLable setBackgroundColor:[UIColor clearColor]];
    [totalLable setText:[NSString stringWithFormat:@"总计:0件商品,0.00元"]];
    [totalLable setFrame:CGRectMake(40,0, SCREEN_WIDTH-80-30, HEADER_HEIGHT)];
    [totalLable setTextAlignment:NSTextAlignmentCenter];
    [footView addSubview:totalLable];
    _totalLable=totalLable;
    
    UIView *leftButton = [CommonMethods toolBarButtonWithTarget:self andSelector:@selector(doBack:) andButtonType:OCCToolBarButtonTypeBack andLeft:YES];
    [footView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods toolBarButtonWithTitle:@"提交订单" WithTarget:self andSelector:@selector(doPay:) andLeft:NO];
    [footView addSubview:rightButton];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadAddressDataList];
    });
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

- (void) addAddressSuccessNotification:(NSNotification*)notification
{
    [self loadPayData];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doPay:(id)sender
{
    [[Singleton sharedInstance]setLastOrderType:[self getOrderType]];
    [self addOrder];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableDictionary *payData=[[Singleton sharedInstance]payData];
    int total=[[payData objectForKey:@"shopList"]count];
    if (total==0)
    {
        return 0;
    }
    else
    {
        return total+2;//第一个分段为地址列表.最后一个分段为黄色的
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    if (section==[tableView numberOfSections]-1)
    {
        return 4;
    }
    
    NSMutableDictionary *payData=[[Singleton sharedInstance]payData];
    NSMutableArray *shopList=[payData objectForKey:@"shopList"];
    NSDictionary *shop=[shopList objectAtIndex:section-1];
    NSMutableArray *itemList=[shop objectForKey:@"itemList"];
    int itemTotal=[itemList count]+4;
    return itemTotal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    if (section==0)//送货地址
    {
        return 100.0;
    }
    
    if (section==[tableView numberOfSections]-1)
    {
        if (row==0)
        {
            return 44.0;
        }
        if (row==1)
        {
            return self.viewType==ViewTypeNormal?44.0:0;
        }
        if (row==2)
        {
            return self.viewType==ViewTypeNormal?44.0:0;
        }
        if (row==3)
        {
            return 60;
        }
        return 44.0;
    }
    
    NSMutableDictionary *payData=[[Singleton sharedInstance]payData];
    NSMutableArray *shopList=[payData objectForKey:@"shopList"];
    NSDictionary *shop=[shopList objectAtIndex:section-1];
    NSMutableArray *itemList=[shop objectForKey:@"itemList"];
    int itemTotal=[itemList count]+4;
    
    if (row==0)//店铺信息
    {
        return 55.0;
    }
    else if (row==itemTotal-3)//店铺留言
    {
        return 50.0;
    }
    else if (row==itemTotal-2)//店铺活动
    {
        NSMutableArray *bargainList=[shop objectForKey:@"bargainList"];
        if ([bargainList count]==0)
        {
            return 0;
        }
        else
        {
            return 10+[bargainList count]*18;
        }
    }
    else if (row==itemTotal-1)//店铺抵用券
    {
        return 44.0;
    }
    else//店铺商品
    {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        NSDictionary *item=[itemList objectAtIndex:row-1];
        NSMutableArray *itemBargainList=[item objectForKey:@"itemBargainList"];
        for (int i=0; i<[itemBargainList count]; i++)
        {
            NSDictionary *item=[itemBargainList objectAtIndex:i];
            if ([[item objectForKey:@"name"] isKindOfClass:[NSString class]])
            {
                [arr addObject:[item objectForKey:@"name"]];
            }
        }
        
        NSString *text=[arr componentsJoinedByString:@"\n"] ;
        float height=[CommonMethods heightForString:text andFont:FONT_12 andWidth:kBargainLabelWidth];
        return 80.0+height+5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *payData=[Singleton sharedInstance].payData;
    NSMutableDictionary *orderData=[Singleton sharedInstance].orderData;
    
    int row=indexPath.row;
    int section=indexPath.section;
    if (section==0)//收货地址
    {
        static NSString *Address1CellIdentifier=@"Address1CellIdentifier";
        
        Address1Cell *cell = (Address1Cell*)[tableView dequeueReusableCellWithIdentifier:Address1CellIdentifier];
        if (cell == nil)
        {
            cell = [[Address1Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Address1CellIdentifier];
        }
        
        NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                            [orderData objectForKey:@"consignee"],@"consignee",
                            [orderData objectForKey:@"mobile"],@"mobile",
                            [orderData objectForKey:@"address"],@"address",
                            nil];
        [cell setData:data];
        return cell;
    }
    
    if (section==[tableView numberOfSections]-1) {//最后一段区域
        static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
        
        OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
        if (cell == nil)
        {
            cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.lineStyle=OneLineCellLineTypeLineDot;
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [cell setBackgroundView:backgroundView];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_999999];
        [cell setSelectedBackgroundView:selectedBackgroundView];
        
        if (row==0) {
            UIImage *image=[UIImage imageNamed:@"list_bill_up"];
            image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
            [backgroundView setImage:image];
        }else if(row==[tableView numberOfRowsInSection:section]-1){
            cell.lineImageView.hidden=YES;
            UIImage *image=[UIImage imageNamed:@"list_bill_foot"];
            image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:10];
            [backgroundView setImage:image];
        }else{
            UIImage *image=[UIImage imageNamed:@"list_bill_mid"];
            image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
            [backgroundView setImage:image];
        }
        
        NSDictionary *data = [[NSDictionary alloc]init];
        switch (row)
        {
            case 0:
            {
                cell.rightStyle=OneLineCellRightCheck;
                data=[[NSDictionary alloc]initWithObjectsAndKeys:@"使用宝龙抵用券",@"name",[orderData objectForKey:@"plCashCouponName"],@"value",nil];
            }
                break;
            case 1:
            {
                NSString *str=[NSString stringWithFormat:@"%@%@",[orderData objectForKey:@"receiveDate"],[orderData objectForKey:@"receiveTime"]];
                cell.rightStyle=OneLineCellRightCheck;
                data=[[NSDictionary alloc]initWithObjectsAndKeys:@"预约收货时间",@"name",str,@"value",nil];
            }
                break;
            case 2:
            {
                if ([[orderData objectForKey:@"isOtherCommunity"]intValue]==1)
                {
                    data=[[NSDictionary alloc]initWithObjectsAndKeys:@"配送方式",@"name",@"第三方物流",@"value",nil];
                }
                else
                {
                    data=[[NSDictionary alloc]initWithObjectsAndKeys:@"配送方式",@"name",@"宝龙物流",@"value",nil];
                }
            }
                break;
            case 3:
            {
                cell.rightStyle=OneLineCellRightCheck;
                data=[[NSDictionary alloc]initWithObjectsAndKeys:@"支付方式",@"name",[orderData objectForKey:@"payName"],@"value",nil];
            }
                break;
            default:
                break;
        }
        
        [cell setData:data];
        return cell;
    }
    
    NSMutableArray *shopList=[payData objectForKey:@"shopList"];
    NSDictionary *shop=[shopList objectAtIndex:section-1];
    
    if (row==0)//店铺信息
    {
        static NSString *PayShopCellIdentifier=@"PayShopCellIdentifier";
        
        PayShopCell *cell = (PayShopCell*)[tableView dequeueReusableCellWithIdentifier:PayShopCellIdentifier];
        if (cell == nil)
        {
            cell = [[PayShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayShopCellIdentifier];
        }
        
        NSMutableDictionary *data=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                            [shop objectForKey:@"name"],@"name",
                            [shop objectForKey:@"buyPriceSum"],@"buyPriceSum",
                            [shop objectForKey:@"buyNumSum"],@"buyNumSum",
                            nil];
        
        double buyPriceSum=[[shop objectForKey:@"buyPriceSum"]doubleValue];
        double reduce=[[[[orderData objectForKey:@"shopList"]objectAtIndex:section-1]objectForKey:@"cashCouponPrice"]doubleValue];
        [data setObject:[NSString stringWithFormat:@"%.@",[NSNumber numberWithFloat:buyPriceSum-reduce]] forKey:@"buyPriceSum"];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [cell setBackgroundView:backgroundView];
        
        UIImage *image=[UIImage imageNamed:@"list_bill_up"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [backgroundView setImage:image];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_FFFFFF];
        [cell setSelectedBackgroundView:selectedBackgroundView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:data];
        return cell;
    }
    else if (row==[tableView numberOfRowsInSection:section]-3)//店铺留言
    {
        static NSString *PayMessageCellIdentifier=@"PayMessageCellIdentifier";
        
        PayMessageCell *cell = (PayMessageCell*)[tableView dequeueReusableCellWithIdentifier:PayMessageCellIdentifier];
        if (cell == nil)
        {
            cell = [[PayMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayMessageCellIdentifier];
        }
        
        cell.lineImageView.hidden=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSMutableDictionary *shop=[[orderData objectForKey:@"shopList"]objectAtIndex:indexPath.section-1];
        [cell setData:shop];
        return cell;
    }
    else if (row==[tableView numberOfRowsInSection:section]-2)//店铺优惠活动
    {
        static NSString *PayActivityCellIdentifier=@"PayActivityCellIdentifier";
        
        PayActivityCell *cell = (PayActivityCell*)[tableView dequeueReusableCellWithIdentifier:PayActivityCellIdentifier];
        if (cell == nil)
        {
            cell = [[PayActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayActivityCellIdentifier];;
        }
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [cell setBackgroundView:backgroundView];
        
        UIImage *image=[UIImage imageNamed:@"list_bill_mid"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [backgroundView setImage:image];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:shop];
        return cell;
    }
    else if (row==[tableView numberOfRowsInSection:section]-1)//店铺抵用券
    {
        static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
        
        OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
        if (cell == nil)
        {
            cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
        }
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [cell setBackgroundView:backgroundView];
        
        UIImage *image=[UIImage imageNamed:@"list_bill_down"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [backgroundView setImage:image];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_EAEAEA];
        [cell setSelectedBackgroundView:selectedBackgroundView];
        cell.lineImageView.hidden=YES;
        
        NSMutableDictionary *shop=[[orderData objectForKey:@"shopList"]objectAtIndex:section-1];//第一个分段为地址列表
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"抵用券",@"name",
                              [shop objectForKey:@"cashCouponName"],@"value",
                              nil];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.rightStyle = OneLineCellRightCheck;
        cell.adjustY = 10.0;
        [cell setData:data];
        return cell;
    }
    else//店铺商品
    {
        NSMutableArray *itemList=[shop objectForKey:@"itemList"];
        NSDictionary *item = [itemList objectAtIndex:row-1];
        
        static NSString *PayItemCellIdentifier=@"PayItemCellIdentifier";
        
        PayItemCell *cell = (PayItemCell*)[tableView dequeueReusableCellWithIdentifier:PayItemCellIdentifier];
        if (cell == nil)
        {
            cell = [[PayItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayItemCellIdentifier];
        }
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [cell setBackgroundView:backgroundView];
        UIImage *image=[UIImage imageNamed:@"list_bill_mid"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [backgroundView setImage:image];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_FFFFFF];
        [cell setSelectedBackgroundView:selectedBackgroundView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:item];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row=indexPath.row;
    int section=indexPath.section;
    NSMutableDictionary *payData=[Singleton sharedInstance].payData;
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[PayItemCell class]])
    {
        NSMutableArray *shopList=[payData objectForKey:@"shopList"];
        NSDictionary *shop=[shopList objectAtIndex:section-1];
        NSMutableArray *itemList=[shop objectForKey:@"itemList"];
        NSDictionary *item = [itemList objectAtIndex:row-1];
        
        int type=[[item objectForKey:@"type"]intValue];
        switch (type)
        {
            case 0:
            {
                GoodsViewController *viewController=[[GoodsViewController alloc]init];
                [viewController setItemId:[[item objectForKey:@"id"]longValue]];
                AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
                [myDelegate.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case 1:
            {
                GrouponViewController *viewController=[[GrouponViewController alloc]init];
                [viewController setGrouponId:[[item objectForKey:@"id"]longValue]];
                AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
                [myDelegate.navigationController pushViewController:viewController animated:YES];
            }
                break;
            default:
                break;
        }
        return;
    }
    
    if (section==0)
    {
        if (_addressListViewController==nil)
        {
            _addressListViewController=[[AddressListViewController alloc]init];
        }
        _addressListViewController.delegate=self;
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate.navigationController pushViewController:_addressListViewController animated:YES];
        return;
    }
    else if (section==[tableView numberOfSections]-1)
    {
        if (row==0)//宝龙抵用券
        {
            OCCCouponViewController *viewController=[[OCCCouponViewController alloc]init];
            viewController.delegate=self;
            [self.navigationController pushViewController:viewController animated:YES];
            return;
        }
        else if (row==1)//预约收货时间
        {
            if (_payDateViewController==nil)
            {
                _payDateViewController=[[PayDateViewController alloc]init];
            }
            _payDateViewController.delegate=self;
            [self.navigationController pushViewController:_payDateViewController animated:YES];
            return;
        }
        else if (row==2)//配送方式
        {
            return;
        }
        else if (row==3)//付款方式
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"请选择付款方式"
                                          delegate:self
                                          cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            actionSheet.tag=ActionTypePayType;

            NSArray *arr=[payData objectForKey:@"payList"];
            for (NSDictionary *item in arr)
            {
                [actionSheet addButtonWithTitle:[item objectForKey:@"name"]];
            }
            
            [actionSheet showInView:self.view];
            return;
        }
    }
    else
    {
        NSMutableArray *shopList=[payData objectForKey:@"shopList"];
        NSDictionary *shop=[shopList objectAtIndex:section-1];
        NSMutableArray *cashCouponList=[shop objectForKey:@"cashCouponList"];
        if (row==[tableView numberOfRowsInSection:section]-1)//店铺抵用券
        {
            OtherCouponViewController *viewController=[[OtherCouponViewController alloc]init];
            viewController.shopName=[shop objectForKey:@"name"];
            [viewController setDataList:cashCouponList];
            [viewController setSection:section];
            viewController.delegate=self;
            [self.navigationController pushViewController:viewController animated:YES];
            return;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)payDidChange
{
    [self.tableView reloadData];
    
    NSMutableDictionary *orderData=[Singleton sharedInstance].orderData;
    
    double finalPrice=0;
    double freight=[[orderData objectForKey:@"freight"]doubleValue];
    double allPrice=[[orderData objectForKey:@"allPrice"]doubleValue];
    finalPrice+=allPrice;
    
    int payId=[[orderData objectForKey:@"payId"]intValue];
    if (payId==3)
    {
        finalPrice-=freight;
        freight=0;
    }
    
    NSMutableArray *shopList=[orderData objectForKey:@"shopList"];
    for (int i=0; i<[shopList count]; i++)
    {
        NSDictionary *shop=[shopList objectAtIndex:i];
        double cashCouponPrice=[[shop objectForKey:@"cashCouponPrice"]doubleValue];
        finalPrice-=cashCouponPrice;
    }
    
    double plCashCouponPrice=[[orderData objectForKey:@"plCashCouponPrice"]doubleValue];
    finalPrice-=plCashCouponPrice;
    
    [orderData setObject:[NSString stringWithFormat:@"%.2f",finalPrice]forKey:@"finalPrice"];
    
    NSString *text=[NSString stringWithFormat:@"总计:%.@元(含运费:%@元)",
                    [NSNumber numberWithFloat:finalPrice],
                    [NSNumber numberWithFloat:freight]];
    [_totalLable setText:text];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index
{
    if (actionSheet.tag==ActionTypePayType)
    {
        NSDictionary *payData=[[Singleton sharedInstance]payData];
        NSMutableDictionary *orderData=[[Singleton sharedInstance]orderData];
        NSDictionary *item=[[payData objectForKey:@"payList"] objectAtIndex:index];
        [actionSheet addButtonWithTitle:[item objectForKey:@"name"]];
        [orderData setObject:[item objectForKey:@"id"] forKey:@"payId"];
        [orderData setObject:[item objectForKey:@"name"] forKey:@"payName"];
        [self payDidChange];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
	AddressAddViewController *viewController=[[AddressAddViewController alloc]init];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)loadAddressDataList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:findAllAddress_URL andData:reqdata andDelegate:nil];
                       
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
                       if (root==nil) {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSArray *dataList=[[root objectForKey:@"data"]objectForKey:@"addressList"];
                                              [Singleton sharedInstance].addressList=[[NSMutableArray alloc]initWithArray:dataList];
                                              if (dataList!=nil && [dataList count]>0)
                                              {
                                                  [self loadPayData];
                                              }
                                              else
                                              {
                                                  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                      message:@"您还没有设置收货地址,请先设置"
                                                                                                     delegate:self
                                                                                            cancelButtonTitle:@"确定"
                                                                                            otherButtonTitles:nil];
                                                  [alertView show];
                                              }
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)loadPayData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
                       NSMutableDictionary *obj=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                 [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                 [[Singleton sharedInstance]TGC], @"TGC",
                                                 nil];
                       
                       NSMutableArray *yshopList=[[NSMutableArray alloc]init];
                       for (NSMutableDictionary *shop in [cartData objectForKey:@"shopList"]) {
                           NSMutableArray *yitemList=[[NSMutableArray alloc]init];
                           for (NSMutableDictionary *item in [shop objectForKey:@"itemList"]) {
                               if ([[item objectForKey:@"check"]boolValue]) {
                                   NSMutableDictionary *yitem=[[NSMutableDictionary alloc]init];
                                   [yitem setObject:[item objectForKey:@"id"] forKey:@"id"];
                                   [yitem setObject:[item objectForKey:@"type"] forKey:@"type"];
                                   [yitem setObject:[item objectForKey:@"buyNum"] forKey:@"buyNum"];
                                   [yitemList addObject:yitem];
                               }
                           }
                           NSMutableDictionary *yshop=[[NSMutableDictionary alloc]init];
                           [yshop setObject:[shop objectForKey:@"id"] forKey:@"id"];
                           [yshop setObject:yitemList forKey:@"itemList"];
                           if ([yitemList count]>0) {
                               [yshopList addObject:yshop];
                           }
                       }
                       [obj setObject:yshopList forKey:@"shopList"];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:gotoCount_URL andData:reqdata andDelegate:nil];
                       
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
                       if (root==nil) {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           NSMutableDictionary *payData=[[NSMutableDictionary alloc]initWithDictionary:[root objectForKey:@"data"]];
                           [Singleton sharedInstance].payData=payData;
                           NSMutableDictionary *orderData=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                           [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                           [[Singleton sharedInstance]TGC], @"TGC",
                                                           [payData objectForKey:@"addressId"]!=nil?[payData objectForKey:@"addressId"]:@"",@"addressId",
                                                           [payData objectForKey:@"isOtherCommunity"]!=nil?[payData objectForKey:@"isOtherCommunity"]:@"0",@"isOtherCommunity",
                                                           [payData objectForKey:@"receiver"]!=nil?[payData objectForKey:@"receiver"]:@"",@"consignee",
                                                           [payData objectForKey:@"mobile"]!=nil?[payData objectForKey:@"mobile"]:@"",@"mobile",
                                                           [payData objectForKey:@"address"]!=nil?[payData objectForKey:@"address"]:@"",@"address",
                                                           @"0",@"logisticsId",
                                                           @"不使用",@"logisticsName",
                                                           @"0",@"payId",
                                                           @"不使用",@"payName",
                                                           @"",@"receiveDate",
                                                           @"",@"receiveTime",
                                                           [payData objectForKey:@"allPrice"]!=nil?[payData objectForKey:@"allPrice"]:@"0",@"allPrice",
                                                           [payData objectForKey:@"freight"]!=nil?[payData objectForKey:@"freight"]:@"0",@"freight",
                                                           @"-1",@"plCashCouponId",
                                                           @"不使用",@"plCashCouponName",
                                                           @"0",@"plCashCouponPrice",
                                                           nil];
                           
                           self.viewType=[[payData objectForKey:@"view"]intValue];
                           
                           NSDictionary *xxx=[[payData objectForKey:@"dateTimeList"]objectAtIndex:0];
                           [orderData setObject:[xxx objectForKey:@"data"] forKey:@"receiveDate"];
                           NSDictionary *yyy=[[xxx objectForKey:@"timeList"]objectAtIndex:0];
                           [orderData setObject:[yyy objectForKey:@"dateTime"] forKey:@"receiveTime"];
                           
                           NSArray *logisticsList=[payData objectForKey:@"logisticsList"];
                           if ([logisticsList count]>0)
                           {
                               [orderData setObject:[[logisticsList objectAtIndex:0]objectForKey:@"id"] forKey:@"logisticsId"];
                               [orderData setObject:[[logisticsList objectAtIndex:0]objectForKey:@"name"] forKey:@"logisticsName"];
                           }
                           
                           NSArray *payList=[payData objectForKey:@"payList"];
                           if ([payList count]>0) {
                               [orderData setObject:[[payList objectAtIndex:0]objectForKey:@"id"] forKey:@"payId"];
                               [orderData setObject:[[payList objectAtIndex:0]objectForKey:@"name"] forKey:@"payName"];
                           }
                           
                           NSMutableArray *zshopList=[[NSMutableArray alloc]init];
                           for (NSDictionary *shop in[payData objectForKey:@"shopList"]) {
                               NSMutableDictionary *zshop=[[NSMutableDictionary alloc]init];
                               //店铺id
                               [zshop setObject:[shop objectForKey:@"id"] forKey:@"id"];
                               
                               //店铺抵用券.初始化设置为不使用
                               [zshop setObject:@"-1" forKey:@"cashCouponId"];
                               [zshop setObject:@"不使用" forKey:@"cashCouponName"];
                               [zshop setObject:@"0" forKey:@"cashCouponPrice"];
                               
                               //店铺留言
                               [zshop setObject:@"" forKey:@"message"];
                               
                               //店铺优惠
                               NSMutableArray *zitemList=[[NSMutableArray alloc]init];
                               for (NSDictionary *item in[shop objectForKey:@"itemList"]) {
                                   NSMutableDictionary *zitem=[[NSMutableDictionary alloc]init];
                                   [zitem setObject:[item objectForKey:@"id"] forKey:@"id"];
                                   [zitem setObject:[item objectForKey:@"type"] forKey:@"type"];
                                   [zitem setObject:[item objectForKey:@"plPrice"] forKey:@"plPrice"];
                                   [zitem setObject:[item objectForKey:@"buyNum"] forKey:@"buyNum"];
                                   [zitemList addObject:zitem];
                               }
                               [zshop setObject:zitemList forKey:@"itemList"];
                               
                               [zshopList addObject:zshop];
                           }
                           
                           [orderData setObject:zshopList forKey:@"shopList"];
                           [Singleton sharedInstance].orderData=orderData;
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [self payDidChange];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)addOrder
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *orderData=[[Singleton sharedInstance]orderData];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:orderData];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:addOrder_URL andData:reqdata andDelegate:nil];
                       
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
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccessNotification" object:nil];
                                        
                                              int payId=[[orderData objectForKey:@"payId"]intValue];
                                              if (payId==0||payId==3)//在线支付和自提
                                              {
                                                  [self.navigationController popViewControllerAnimated:NO];
                                                 
                                                  NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                                                                      [[root objectForKey:@"data"]objectForKey:@"paymentNo"],@"tradeNO",
                                                                      [orderData objectForKey:@"finalPrice"],@"amount",
                                                                      [self getProductionsDesc],@"tradeDesc",
                                                                      nil];
                                                  GatewayViewController *viewController=[[GatewayViewController alloc]init];
                                                  [viewController setOrderData:data];
                                                  AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                                  [myDelegate.navigationController pushViewController:viewController animated:YES];
                                              }
                                              else if (payId==1)//货到付款
                                              {
                                                  [self.navigationController popViewControllerAnimated:NO];
                                                  
                                                  MyOOrderListViewController *viewController=[[MyOOrderListViewController alloc]init];
                                                  [viewController setStat:MyOOrderStatWillSend];
                                                  AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                                  [myDelegate.navigationController pushViewController:viewController animated:YES];
                                              }
                                              else if (payId==2)//POS机
                                              {
                                                  [self.navigationController popViewControllerAnimated:NO];
                                                  
                                                  MyOOrderListViewController *viewController=[[MyOOrderListViewController alloc]init];
                                                  [viewController setStat:MyOOrderStatWillSend];
                                                  AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                                  [myDelegate.navigationController pushViewController:viewController animated:YES];
                                              }
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       } 
                   });
}

-(NSString*)getProductionsDesc
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSDictionary *payData=[[Singleton sharedInstance]payData];
    NSArray *shopList=[payData objectForKey:@"shopList"];
    for (NSDictionary *shop in shopList)
    {
        NSArray *itemList=[shop objectForKey:@"itemList"];
        for (NSDictionary *item in itemList)
        {
            [arr addObject:[item objectForKey:@"itemName"]];
        }
    }
    NSString *result=[arr componentsJoinedByString:@","];
    if ([result length]>49)
    {
        result=[result substringToIndex:49];
    }
    return result;
}

-(LastOrderType)getOrderType
{
    NSDictionary *payData=[[Singleton sharedInstance]payData];
    NSArray *shopList=[payData objectForKey:@"shopList"];
    for (NSDictionary *shop in shopList)
    {
        NSArray *itemList=[shop objectForKey:@"itemList"];
        for (NSDictionary *item in itemList)
        {
            if ([[item objectForKey:@"type"]intValue]==0)
            {
                return LastOrderTypeNormal;
            }
        }
    }
    
    return LastOrderTypeGroupon;
}

@end
