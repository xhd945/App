//
//  OrderDetailViewController.m
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OrderViewController.h"
#import "Address1Cell.h"
#import "PayShopCell.h"
#import "PayMessageCell.h"
#import "PayItemCell.h"
#import "OneLineCell.h"
#import "PayActivityCell.h"
#import "OrderNoCell.h"
#import "OrderShopCell.h"
#import "OrderItemCell.h"
#import "GoodsViewController.h"
#import "GrouponViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    UIView *footView = [[UIView alloc]init];
    [footView setFrame:CGRectMake(0, SCREEN_HEIGHT- HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    [footView setBackgroundColor:COLOR_BG_CLASSTHREE];
    [self.view addSubview:footView];
    
    UILabel *totalLable = [[UILabel alloc]init];
    [totalLable setTextColor:COLOR_FFFFFF];
    [totalLable setFont:FONT_12];
    [totalLable setBackgroundColor:[UIColor clearColor]];
    [totalLable setText:[NSString stringWithFormat:@"总计:0件商品,0.00元"]];
    [totalLable setFrame:CGRectMake(10,0, SCREEN_WIDTH-20, HEADER_HEIGHT)];
    [totalLable setTextAlignment:NSTextAlignmentRight];
    [footView addSubview:totalLable];
    _totalLable=totalLable;
    
    UIView *leftButton = [CommonMethods toolBarButtonWithTarget:self andSelector:@selector(doBack:) andButtonType:OCCToolBarButtonTypeBack andLeft:YES];
    [footView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc]init];
    [rightButton setFrame:CGRectMake(240, 0, 70, 44)];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4, 0.0, 4)] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doPay:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = FONT_12;
    [rightButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [rightButton setTitle:@"查看物流" forState:UIControlStateNormal];
    //[footView addSubview:rightButton];
    
    UIView *tableHeadView = [[UIView alloc]init];
    [tableHeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [tableHeadView setBackgroundColor:[UIColor clearColor]];
    _tableHeadView=tableHeadView;
    
    UILabel *headLable1 = [[UILabel alloc]init];
    [headLable1 setTextColor:COLOR_999999];
    [headLable1 setFont:FONT_12];
    [headLable1 setBackgroundColor:[UIColor clearColor]];
    [headLable1 setText:[NSString stringWithFormat:@"订单状态:未知"]];
    [headLable1 setFrame:CGRectMake(10,20, 300, 20)];
    [headLable1 setTextAlignment:NSTextAlignmentLeft];
    [tableHeadView addSubview:headLable1];
    _headLable1=headLable1;
    
    UIView *tableFootView = [[UIView alloc]init];
    [tableFootView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [tableFootView setBackgroundColor:[UIColor clearColor]];
    _tableFootView=tableFootView;
    
    UILabel *footLable1 = [[UILabel alloc]init];
    [footLable1 setTextColor:COLOR_999999];
    [footLable1 setFont:FONT_12];
    [footLable1 setBackgroundColor:[UIColor clearColor]];
    [footLable1 setText:[NSString stringWithFormat:@"运费:"]];
    [footLable1 setFrame:CGRectMake(10,0, 300, 20)];
    [footLable1 setTextAlignment:NSTextAlignmentLeft];
    [tableFootView addSubview:footLable1];
    
    UILabel *footLable2 = [[UILabel alloc]init];
    [footLable2 setTextColor:COLOR_999999];
    [footLable2 setFont:FONT_12];
    [footLable2 setBackgroundColor:[UIColor clearColor]];
    [footLable2 setText:[NSString stringWithFormat:@"￥0.00"]];
    [footLable2 setFrame:CGRectMake(10,0, 300, 20)];
    [footLable2 setTextAlignment:NSTextAlignmentRight];
    [tableFootView addSubview:footLable2];
    _footLable2=footLable2;
    
    UILabel *footLable3 = [[UILabel alloc]init];
    [footLable3 setTextColor:COLOR_999999];
    [footLable3 setFont:FONT_12];
    [footLable3 setBackgroundColor:[UIColor clearColor]];
    [footLable3 setText:[NSString stringWithFormat:@"实付款:"]];
    [footLable3 setFrame:CGRectMake(10,20, 300, 20)];
    [footLable3 setTextAlignment:NSTextAlignmentLeft];
    [tableFootView addSubview:footLable3];
    
    UILabel *footLable4 = [[UILabel alloc]init];
    [footLable4 setTextColor:COLOR_DA6432];
    [footLable4 setFont:FONT_12];
    [footLable4 setBackgroundColor:[UIColor clearColor]];
    [footLable4 setText:[NSString stringWithFormat:@"￥0.00"]];
    [footLable4 setFrame:CGRectMake(10,20, 300, 20)];
    [footLable4 setTextAlignment:NSTextAlignmentRight];
    [tableFootView addSubview:footLable4];
    _footLable4=footLable4;
    
    OCCTableView *tableView=[[OCCTableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [CommonMethods showWaitView:@"正在请求中,请稍候..."];
    [self loadOrderData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{

}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    //UITouch *touch = [[event allTouches]anyObject];
    //UIView *touchView=touch.view;
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int total=0;
    NSArray *list=[_data objectForKey:@"shopList"];
    if (list!=nil || [list count]>0) {
        total=[list count]+2;//第一个分段为送货地址.最后一个分段为订单信息.
    } 
    return total;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {//送货地址
        return 1;
    }
    if (section==[tableView numberOfSections]-1){//订单信息
        return 1;
    }
    
    NSMutableArray *shopList=[_data objectForKey:@"shopList"];
    NSDictionary *shop=[shopList objectAtIndex:section-1];
    NSMutableArray *itemList=[shop objectForKey:@"itemList"];
    int itemTotal=[itemList count]+1;
    return itemTotal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0 || section==1) {
        return 10.0;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==[tableView numberOfSections]-1) {
        return 10.0;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    if (section==0)//送货地址
    {
        return 100.0;
    }
    if (section==[tableView numberOfSections]-1)//订单信息
    {
        return 100.0;
    }
    
    NSMutableArray *shopList=[_data objectForKey:@"shopList"];
    NSDictionary *shop=[shopList objectAtIndex:section-1];
    NSMutableArray *itemList=[shop objectForKey:@"itemList"];
    int itemTotal=[itemList count]+1;
    
    if (row==0)//店铺信息
    {
        return 44;
    }
    else//店铺商品
    {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        NSDictionary *item=[itemList objectAtIndex:row-1];
        NSMutableArray *itemBargainList=[item objectForKey:@"itemBargainList"];
        for (int i=0; i<[itemBargainList count]; i++) {
            NSDictionary *item=[itemBargainList objectAtIndex:i];
            if ([[item objectForKey:@"name"] isKindOfClass:[NSString class]]){
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
                            [_data objectForKey:@"receiver"],@"consignee",
                            [_data objectForKey:@"address"],@"address",
                            [_data objectForKey:@"mobile"],@"mobile",
                            nil];
        
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:data];
        return cell;
    }
    
    if (section==[tableView numberOfSections]-1)//订单信息
    {
        static NSString *OrderNoCellIdentifier=@"OrderNoCellIdentifier";
        
        OrderNoCell *cell = (OrderNoCell*)[tableView dequeueReusableCellWithIdentifier:OrderNoCellIdentifier];
        if (cell == nil)
        {
            cell = [[OrderNoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderNoCellIdentifier];
        }
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [cell setBackgroundView:backgroundView];
        
        UIImage *image=[UIImage imageNamed:@"list_bill_foot"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:10];
        [backgroundView setImage:image];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:_data];
        return cell;
    }
    
    if (row==0)//店铺信息
    {
        NSMutableArray *shopList=[_data objectForKey:@"shopList"];
        NSMutableDictionary *shop=[shopList objectAtIndex:section-1];
        
        static NSString *OrderShopCellIdentifier=@"OrderShopCellIdentifier";
        
        OrderShopCell *cell = (OrderShopCell*)[tableView dequeueReusableCellWithIdentifier:OrderShopCellIdentifier];
        if (cell == nil)
        {
            cell = [[OrderShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderShopCellIdentifier];;
        }
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        if (section==1) {
            [backgroundView setImage:[[UIImage imageNamed:@"list_bill_up"]resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2)]];
        }else{
            [backgroundView setImage:[[UIImage imageNamed:@"list_bill_mid"]resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2)]];
        }
        [cell setBackgroundView:backgroundView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:shop];
        return cell;
    }
    
    else//店铺商品
    {
        NSMutableArray *shopList=[_data objectForKey:@"shopList"];
        NSMutableDictionary *shop=[shopList objectAtIndex:section-1];
        NSMutableArray *itemList=[shop objectForKey:@"itemList"];
        NSDictionary *item = [itemList objectAtIndex:row-1];
        
        static NSString *OrderItemCellIdentifier=@"OrderItemCellIdentifier";
        
        OrderItemCell *cell = (OrderItemCell*)[tableView dequeueReusableCellWithIdentifier:OrderItemCellIdentifier];
        if (cell == nil)
        {
            cell = [[OrderItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderItemCellIdentifier];
        }
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bill_mid"]resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2)]];
        [cell setBackgroundView:backgroundView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:item];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[OrderItemCell class]])
    {
        NSMutableArray *shopList=[_data objectForKey:@"shopList"];
        NSMutableDictionary *shop=[shopList objectAtIndex:section-1];
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
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

- (void)loadOrderData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [NSNumber numberWithInt:_orderId], @"orderId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       NSString *str=(self.orderType==MyOrderTypeMain?loadParentOrder_URL:loadOrder_URL);
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showErrorDialog:@"网络异常,请检查您的网络设置!" inView:self.view];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              _data=[[NSMutableDictionary alloc]initWithDictionary:data];
                                              [self.tableView reloadData];
                                              [self.tableView setTableFooterView:_tableFootView];
                                              [self.tableView setTableHeaderView:_tableHeadView];
                                              NSString *orderStat=[NSString stringWithFormat:@"订单状态:%@",[CommonMethods getOrderStatusbyId:[[data objectForKey:@"orderStat"]intValue]]];
                                              [_headLable1 setText:orderStat];
                                              [_footLable2 setText:[NSString stringWithFormat:@"￥%d",
                                                                    [[data objectForKey:@"freight"]intValue]]];
                                              [_footLable4 setText:[NSString stringWithFormat:@"￥%.2f",
                                                                    [[data objectForKey:@"allPrice"]floatValue]]];
                                              
                                              [_totalLable setText:[NSString stringWithFormat:@"总计:%@件商品,%@元",
                                                                    [data objectForKey:@"allNum"],
                                                                    [data objectForKey:@"allPrice"]]];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

@end
