//
//  OCCCouponViewController.m
//  occ
//
//  Created by RS on 13-8-29.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCCouponViewController.h"
#import "OneLineCell.h"
#import "TwoLineCell.h"

@interface OCCCouponViewController ()

@end

@implementation OCCCouponViewController

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
    if (_dataList==nil) {
        _dataList=[[NSMutableArray alloc]init];
    }
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *footView = [[UIView alloc]init];
    [footView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [footView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:footView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [footView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"%@抵用券",kBaoLongTitle]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [footView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [footView addSubview:leftButton];
    
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [CommonMethods showWaitView:@"正在请求中,请稍候..."];
    [self loadPlCashCouponList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setNoticeCell:nil];
    [super viewDidUnload];
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
    return 55.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count]+1;
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
    NSMutableDictionary *orderData=[Singleton sharedInstance].orderData;
    
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *selectedBackgroundView=[[UILabel alloc]init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    
    switch (row)
    {
        case 0:
        {
            static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
            
            OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
            if (cell == nil)
            {
                cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
            }
            
            NSDictionary *data = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"-1",@"id",@"不使用",@"name",nil];
            
            [cell setBackgroundView:backgroundView];
            [cell setSelectedBackgroundView:selectedBackgroundView];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setData:data];

            int xx=[[orderData objectForKey:@"plCashCouponId"]intValue];
            int yy=[[data objectForKey:@"id"]intValue];
            if (xx==yy)
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                cell.rightStyle = OneLineCellRightGou;
                cell.leftTextLabel.textColor = COLOR_DA6432;
            }
            return cell;
        }
            break;
        default:
        {
            static NSString *TwoCellIdentifier=@"TwoCellIdentifier";
            
            TwoLineCell *cell = (TwoLineCell*)[tableView dequeueReusableCellWithIdentifier:TwoCellIdentifier];
            if (cell == nil)
            {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TwoLineCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            NSDictionary *data = [_dataList objectAtIndex:row-1];
            NSDictionary *sortData = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [data objectForKey:@"name"],@"value",
                                      [NSString stringWithFormat:@"%@元",[data objectForKey:@"price"]],@"name",
                                      nil];
            
            [cell setBackgroundView:backgroundView];
            [cell setSelectedBackgroundView:selectedBackgroundView];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setData:sortData];

            int xx=[[orderData objectForKey:@"plCashCouponId"]intValue];
            int yy=[[data objectForKey:@"id"]intValue];
            if (xx==yy)
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                cell.rightStyle = TwoLineCellRightGou;
                cell.titleLabel.textColor = COLOR_DA6432;
            }
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    NSMutableDictionary *orderData=[Singleton sharedInstance].orderData;
    if (row==0)
    {
        [orderData setObject:@"-1" forKey:@"plCashCouponId"];
        [orderData setObject:@"不使用" forKey:@"plCashCouponName"];
        [orderData setObject:@"0" forKey:@"plCashCouponPrice"];
    }
    else
    {
        NSDictionary *data = [_dataList objectAtIndex:row-1];
        [orderData setObject:[data objectForKey:@"id"] forKey:@"plCashCouponId"];
        [orderData setObject:[data objectForKey:@"name"] forKey:@"plCashCouponName"];
        [orderData setObject:[data objectForKey:@"price"] forKey:@"plCashCouponPrice"];
    }
    
    [_delegate payDidChange];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)loadPlCashCouponList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *orderData =[Singleton sharedInstance].orderData;
                       NSMutableDictionary *obj=[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                 [[Singleton sharedInstance]TGC], @"TGC",
                                                 [orderData objectForKey:@"finalPrice"], @"price",
                                                 nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadPlCashCoupon_URL andData:reqdata andDelegate:nil];
                       
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
                                              _dataList=[data objectForKey:@"plCashCouponList"];
                                              [self.tableView reloadData];
                                              
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
