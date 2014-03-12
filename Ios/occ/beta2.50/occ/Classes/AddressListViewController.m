//
//  AddressListViewController.m
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressAddViewController.h"
#import "AddressModifyViewController.h"
#import "Address2Cell.h"

@interface AddressListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation AddressListViewController

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
    
    _dataList=[Singleton sharedInstance].addressList;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"occ.db3" ofType:nil];
    self.db = [FMDatabase databaseWithPath:filePath];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"收货地址管理"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doAdd:) andButtonType:OCCNavigationButtonTypeAdd andLeft:NO];
    [headView addSubview:rightButton];
    
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line2"]]];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_header free];
    [_footer free];
    
    [self.db close];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadDataList];
}

- (void)doBack:(id)sender
{
    if (self.dataList==nil || [self.dataList count]<=0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您还没有设置收货地址,请先设置"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([[self.tableView indexPathsForSelectedRows]count]<=0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您还没有选择收货地址,请先选择"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doAdd:(id)sender
{
    if (_dataList!=nil&&_dataList.count>=10)
    {
        [CommonMethods showTip:@"很抱歉,收货地址数量不能超过10个!"];
        return;
    }
    
    AddressAddViewController *viewController=[[AddressAddViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark MJRefreshDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    double delayInSeconds = REFRESH_TIME_INTERVAL;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (refreshView == _header)
        {
            [self reloadDataList];
        }
    });
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0;
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
    static NSString *Address2CellIdentifier=@"Address2CellIdentifier";
    
    Address2Cell *cell = (Address2Cell*)[tableView dequeueReusableCellWithIdentifier:Address2CellIdentifier];
    if (cell == nil)
    {
        cell = [[Address2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Address2CellIdentifier];
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithDictionary:[_dataList objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    Address *province=[self queryProvinceById:[[data objectForKey:@"province"]longValue]];
    if (province!=nil) {
        [data setObject:province.name forKey:@"provinceName"];
    }else{
       [data setObject:@"" forKey:@"provinceName"]; 
    }
    
    Address *city=[self queryCityById:[[data objectForKey:@"city"]longValue]];
    if (city!=nil) {
        [data setObject:city.name forKey:@"cityName"];
    }else{
        [data setObject:@"" forKey:@"cityName"];
    }
    
    Address *area=[self queryAreaById:[[data objectForKey:@"area"]longValue]];
    if (area!=nil) {
        [data setObject:area.name forKey:@"areaName"];
    }else{
        [data setObject:@"" forKey:@"areaName"];
    }
    
    [cell setData:data];
    
    int xx=[[[Singleton sharedInstance].orderData objectForKey:@"addressId"]intValue];
    int yy=[[data objectForKey:@"id"]intValue];
    if (xx==yy)
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self resetOrderDataWithNewAddressData:data];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
    [self resetOrderDataWithNewAddressData:data];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)reloadDataList
{
    [self loadDataList];
}

- (void)loadDataList
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
                                          [self.tableView setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:findAllAddress_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                          [_header endRefreshing];
                                          [_footer endRefreshing];
                                          [self.tableView setLoading:NO];
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
                       if (root==nil) {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSArray *addressList=[[root objectForKey:@"data"]objectForKey:@"addressList"];
                                              _dataList=[[NSMutableArray alloc]initWithArray:addressList];
                                              [Singleton sharedInstance].addressList=[[NSMutableArray alloc]initWithArray:addressList];
                                              [self.tableView reloadData];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(Address *)queryProvinceById:(long)provinceId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=1 and ID=%ld",provinceId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(Address *)queryCityById:(long)cityId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=2 and ID=%ld",cityId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(Address *)queryAreaById:(long)areaId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=3 and ID=%ld",areaId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(void)resetOrderDataWithNewAddressData:(NSDictionary*)data
{
    NSMutableDictionary *orderData=[Singleton sharedInstance].orderData;
    [orderData setObject:[data objectForKey:@"id"] forKey:@"addressId"];
    
    int type=[[data objectForKey:@"isOtherCommunity"]intValue];
    if (type==1)
    {
        NSString *prvince=[self queryProvinceById:[[data objectForKey:@"province"]intValue]].name;
        NSString *city=[self queryCityById:[[data objectForKey:@"city"]intValue]].name;
        NSString *area=[self queryAreaById:[[data objectForKey:@"area"]intValue]].name;
        NSString *address=[data objectForKey:@"address"];
        NSString *str=[NSString stringWithFormat:@"%@ %@ %@ %@",prvince,city,area,address];
        [orderData setObject:str forKey:@"address"];
    }
    else
    {
        NSString *prvince=[self queryProvinceById:[[data objectForKey:@"province"]intValue]].name;
        NSString *city=[self queryCityById:[[data objectForKey:@"city"]intValue]].name;
        NSString *area=[self queryAreaById:[[data objectForKey:@"area"]intValue]].name;
        NSString *communityName=[data objectForKey:@"communityName"];
        NSString *address=[data objectForKey:@"address"];
        NSString *str=[NSString stringWithFormat:@"%@ %@ %@ %@%@",prvince,city,area,communityName,address];
        [orderData setObject:str forKey:@"address"];
    }
    
    if ([data objectForKey:@"mobile"]!=nil)
    {
        [orderData setObject:[data objectForKey:@"mobile"] forKey:@"mobile"];
    }
    else
    {
        [orderData setObject:@"" forKey:@"mobile"];
    }
    
    if ([data objectForKey:@"consignee"]!=nil)
    {
        [orderData setObject:[data objectForKey:@"consignee"] forKey:@"consignee"];
    }
    else
    {
        [orderData setObject:@"" forKey:@"consignee"];
    }
    
    [orderData setObject:[data objectForKey:@"isOtherCommunity"] forKey:@"isOtherCommunity"];
    
    [_delegate payDidChange];
}

@end
