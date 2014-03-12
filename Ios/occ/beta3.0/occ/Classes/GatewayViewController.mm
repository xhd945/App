//
//  PayListViewController.m
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GatewayViewController.h"
#import "MyOrderListViewController.h"
#import "MyOOrderListViewController.h"
#import "MyGrouponListViewController.h"
#import "AppDelegate.h"
#import "GatewayCell.h"
#import "LTInterface.h"
#import "Product.h"

@interface GatewayViewController ()<LTInterfaceDelegate>

@end

@implementation GatewayViewController

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

    self.dataList=[[NSArray alloc]init];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"选择支付方式"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    OCCTableView *tableView=[[OCCTableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS2];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [self queryAppCode];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [_dataList count]>0?1:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GatewayCellIdentifier=@"GatewayCellIdentifier";
    
    GatewayCell *cell = (GatewayCell*)[tableView dequeueReusableCellWithIdentifier:GatewayCellIdentifier];
    if (cell == nil)
    {
        cell=[[GatewayCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GatewayCellIdentifier];
    }
    
    NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self toChannel:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)queryAppCode
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mallId",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  @"IOS", @"device",
                                                  @"3", @"type",
                                                  @"1.0.0", @"version",
                                                  [self.orderData objectForKey:@"tradeNO"], @"bizCode",
                                                  @"1", @"bizType",
                                                  nil];

                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:queryAppCode_URL andData:reqdata andDelegate:nil];
                       
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
                                              _key=[root objectForKey:@"key"];
                                              if (_key==nil||[_key length]==0)
                                              {
                                                  return;
                                              }
                                              _appCode=[root objectForKey:@"appCode"];
                                              if (_appCode==nil||[_appCode length]==0)
                                              {
                                                  return;
                                              }
                                              [self getSerial];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)getSerial
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [self.orderData objectForKey:@"amount"], @"amount",
                                                  self.appCode, @"appCode",
                                                  [self.orderData objectForKey:@"tradeNO"], @"bizCode",
                                                  [self.orderData objectForKey:@"tradeDesc"], @"bizDescription",
                                                  @"1", @"bizType",
                                                  [NSNumber numberWithInt:OCCBizPay], @"type",
                                                  [[Singleton sharedInstance]userName], @"userName",
                                                  nil];
                       
                       NSString *source=[NSString stringWithFormat:@"amount=%@&appCode=%@&bizCode=%@&bizDescription=%@&bizType=%@&type=%@&userName=%@&%@",
                                         [obj objectForKey:@"amount"],
                                         [obj objectForKey:@"appCode"],
                                         [obj objectForKey:@"bizCode"],
                                         [obj objectForKey:@"bizDescription"],
                                         [obj objectForKey:@"bizType"],
                                         [obj objectForKey:@"type"],
                                         [obj objectForKey:@"userName"],
                                         self.key];
                       NSString *sign= [OCCUtiil getMd5_32Bit_String:source];
                       [obj setObject:sign forKey:@"sign"];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:accessSerial_URL andData:reqdata andDelegate:nil];
                       
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
                                              //NSDictionary *data=[root objectForKey:@"data"];
                                              _data=root;
                                              [self getChannel];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)getChannel
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"amount"], @"amount",
                                                  [_data objectForKey:@"appCode"], @"appCode",
                                                  [_data objectForKey:@"bizCode"], @"bizCode",
                                                  [_data objectForKey:@"bizDescription"], @"bizDescription",
                                                  [_data objectForKey:@"bizType"], @"bizType",
                                                  @"json", @"responseType",
                                                  [_data objectForKey:@"serialNum"], @"serialNum",
                                                  [_data objectForKey:@"type"], @"type",
                                                  [_data objectForKey:@"userName"], @"userName",
                                                  nil];
                       
                       NSString *source=[NSString stringWithFormat:@"amount=%@&appCode=%@&bizCode=%@&bizDescription=%@&bizType=%@&responseType=%@&serialNum=%@&type=%@&userName=%@&%@",
                                         [obj objectForKey:@"amount"],
                                         [obj objectForKey:@"appCode"],
                                         [obj objectForKey:@"bizCode"],
                                         [obj objectForKey:@"bizDescription"],
                                         [obj objectForKey:@"bizType"],
                                         
                                         [obj objectForKey:@"responseType"],
                                         [obj objectForKey:@"serialNum"],
                                         
                                         [obj objectForKey:@"type"],
                                         [obj objectForKey:@"userName"],
                                         self.key];
                       NSString *sign= [OCCUtiil getMd5_32Bit_String:source];
                       [obj setObject:sign forKey:@"sign"];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:prepare_URL andData:reqdata andDelegate:nil];
                       
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
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              NSArray *channels=[data objectForKey:@"channels"];
                                              _dataList=channels;
                                              if ([channels count]==0)
                                              {
                                                  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                      message:@"没有可用的支付方式"
                                                                                                     delegate:self
                                                                                            cancelButtonTitle:@"确定"
                                                                                            otherButtonTitles:nil];
                                                  [alertView show];
                                              }
                                              else{
                                                 [self.tableView reloadData]; 
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

-(void)toChannel:(int)index
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSDictionary *data=[self.dataList objectAtIndex:index];
                       
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"appCode"], @"appCode",
                                                  [data objectForKey:@"code"], @"channelCode",
                                                  [data objectForKey:@"channelId"], @"channelId",
                                                  @"json", @"responseType",
                                                  [_data objectForKey:@"serialNum"], @"serialNum",
                                                  nil];
                       
                       NSString *source=[NSString stringWithFormat:@"appCode=%@&channelCode=%@&channelId=%@&responseType=%@&serialNum=%@&%@",
                                         [obj objectForKey:@"appCode"],
                                         [obj objectForKey:@"channelCode"],
                                         [obj objectForKey:@"channelId"],
                                         [obj objectForKey:@"responseType"],
                                         [obj objectForKey:@"serialNum"],
                                         self.key];
                       NSString *sign= [OCCUtiil getMd5_32Bit_String:source];
                       [obj setObject:sign forKey:@"sign"];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:toChannel_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                      });

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
                                              NSDictionary *data=[self.dataList objectAtIndex:index];
                                              NSString *code=[data objectForKey:@"code"];
                                              if ([code isEqualToString:@"ALIPAY"])
                                              {
                                                  [self doAliPay:data];
                                              }
                                              else if ([code isEqualToString:@"UPOP"])
                                              {
                                                  [self doUpopPay:root];
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

- (void) doAliPay:(NSDictionary*)data
{
    NSString *tradeNO=[_data objectForKey:@"serialNum"];
    NSString *partner=[data objectForKey:@"partnerId"];
    NSString *seller=[data objectForKey:@"sellerAccount"];
    NSString *notifyURL=[data objectForKey:@"notifyUrl"];
    NSString *pck=[data objectForKey:@"pck"];
    NSString *pvk=[data objectForKey:@"pvk"];
    
    Product *product=[[Product alloc]init];
    product.amount=[self.orderData objectForKey:@"amount"];
    product.body=@"福州宝龙";
    product.subject=[self.orderData objectForKey:@"tradeDesc"];
    product.partner=partner;
    product.seller=seller;
    product.notifyURL=notifyURL;
    product.tradeNO=tradeNO;
    product.pvk=pvk;
    product.pck=pck;
    [CommonMethods alipay:product];
}

- (void) doUpopPay:(NSDictionary*)data
{
	self.hidesBottomBarWhenPushed = YES;
    /*
	NSString * order = @"<?xml version=\'1.0\' encoding=\'UTF-8\'?>\
	<upomp application=\"LanchPay.Req\" version=\'1.0.0\'>\
	<merchantId>898000000000002</merchantId>\
	<merchantOrderId>201206261509021</merchantOrderId>\
	<merchantOrderTime>20120626150902</merchantOrderTime>\
	<merchantOrderAmt>1</merchantOrderAmt>\
	<sign>SznBRkvLCAziexRbfaBm7GMv4WPNUevEuPlw6vG+jxbG9PKfNBkdchTUWjFoYlgc4fcG/YNMj+JTYDjW8gyczaQWj5+pYiAkOtCDnEwnGxNUIrqZ47Xk6jbtr1b9d3rQLp8tlBYgcPa6Kzwmyv+IJgjTHxEqIw4f72fzRq5pRvY=</sign>\
	</upomp>";
     */
    
    NSString *order= [NSString stringWithFormat:@"<?xml version=\'1.0\' encoding=\'UTF-8\'?>\
	<upomp application=\"LanchPay.Req\" version=\'1.0.0\'>\
	<merchantId>%@</merchantId>\
	<merchantOrderId>%@</merchantOrderId>\
	<merchantOrderTime>%@</merchantOrderTime>\
	<merchantOrderAmt>1</merchantOrderAmt>\
	<sign>%@</sign>\
	</upomp>",
    [data objectForKey:@"merchantId"],
    [data objectForKey:@"merchantOrderId"],
    [data objectForKey:@"merchantOrderTime"],
    [data objectForKey:@"mobileSign"]];
	
	UIViewController *viewCtrl = [LTInterface getHomeViewControllerWithType:UNIPAY_TYPE strOrder:order andDelegate:self];
	[self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void) returnWithResult:(NSString *)strResult
{
    if (strResult==nil)
    {
        return;
    }
    
    NSRange aa=[strResult rangeOfString:@"<respCode>"];
    if (aa.location == NSNotFound)
    {
        NSLog(@"searchstring:%@",@"aa");
        return;
    }
    
    NSRange bb=[strResult rangeOfString:@"</respCode>"];
    if (bb.location == NSNotFound)
    {
        NSLog(@"searchstring:%@",@"aa");
        return;
    }
    
    NSRange range={aa.location+10,bb.location-aa.location-10};
    NSString *respCode=[strResult substringWithRange:range];
    if (respCode!=nil&&[respCode intValue]==0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"支付成功"
                                                            delegate:[[UIApplication sharedApplication]delegate]
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView setTag:AlertTagpPaySucces];
        [alertView show];
        return;
    }
    else
    {
        NSRange aa=[strResult rangeOfString:@"<respDesc>"];
        if (aa.location == NSNotFound)
        {
            NSLog(@"searchstring:%@",@"aa");
            return;
        }
        
        NSRange bb=[strResult rangeOfString:@"</respDesc>"];
        if (bb.location == NSNotFound)
        {
            NSLog(@"searchstring:%@",@"aa");
            return;
        }
        
        NSRange range={aa.location+10,bb.location-aa.location-10};
        NSString *respDesc=[strResult substringWithRange:range];
        NSLog(@"%@",respDesc);
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:respDesc
                                                            delegate:[[UIApplication sharedApplication]delegate]
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView setTag:AlertTagpPayFail];
        [alertView show];
        return;
    }
}

@end
