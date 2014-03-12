//
//  CouponsListViewController.m
//  occ
//
//  Created by RS on 13-8-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyGrouponListViewController.h"
#import "GrouponViewController.h"
#import "MyGrouponCell.h"

@interface MyGrouponListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation MyGrouponListViewController

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
    self.type=GrouponTypeUnused;
    _dataList =[[NSMutableArray alloc]init];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"团购券"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    //tab===========================================================
    UIView *segementView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    segementView.backgroundColor = COLOR_BG_CLASSONE;
    [self.view addSubview:segementView];
    
    OCCSegement *segement = [[OCCSegement alloc] initWithFrame:CGRectMake(10, (HEADER_HEIGHT - 28)/2, SCREEN_WIDTH - 10*2, 28)
                                                          type:OCCSegementTypeDefaultThree
                                                 andTitleArray:[NSArray arrayWithObjects:@"未使用",@"已使用",nil]];
    segement.delegate = self;
    [segementView addSubview:segement];
    
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,2*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-2*HEADER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [tableView setDataType:DataTypeGrouponCode];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
    // 上拉加载
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.backgroundColor=[UIColor clearColor];
    _footer.scrollView = self.tableView;
    
    [_header beginRefreshing];
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
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doFilter:(id)sender
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView==_header) {
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(reloadDataList) userInfo:nil repeats:NO];
    }else if (refreshView==_footer) {
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(loadDataList) userInfo:nil repeats:NO];
    }
}

#pragma mark -
#pragma mark OCCSegementDelegate
- (void)selectedSegementIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.type=GrouponTypeUnused;
            break;
        case 1:
            self.type=GrouponTypeUsed;
            break;
        default:
            break;
    }
    
    [_dataList removeAllObjects];
    [self.tableView reloadData];
    [_header beginRefreshing];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
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
    static NSString *MyGrouponCellIdentifier=@"MyGrouponCellIdentifier";
    
    MyGrouponCell *cell = (MyGrouponCell*)[tableView dequeueReusableCellWithIdentifier:MyGrouponCellIdentifier];
    if (cell == nil)
    {
        cell=[[MyGrouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyGrouponCellIdentifier];
    }
    
    int row=indexPath.row;
    NSDictionary *data = [_dataList objectAtIndex:row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setData:data];
    
    if (indexPath.row==(_dataList.count-PAGE_SIZE/2)) {
        if (_footer.hidden==NO) {
            [_footer beginRefreshing];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data=[_dataList objectAtIndex:indexPath.row];
    GrouponViewController *viewController=[[GrouponViewController alloc]init];
    [viewController setGrouponId:[[data objectForKey:@"id"]longValue]];
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark - Your actions
- (void)reloadDataList
{
    self.page=0;
    [self loadDataList];
}

- (void)loadDataList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [NSNumber numberWithInt:self.type], @"type",
                                                  [NSNumber numberWithInt:self.page+1], @"page",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       

                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.tableView setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:shopGrouponListMobile_URL andData:reqdata andDelegate:nil];
                       
                       if (self.page==0)
                       {
                           _header.hidden=NO;
                           _footer.hidden=NO;
                       }
                       
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
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              NSArray *dataList=[data objectForKey:@"grouponCouponList"];
                                              if ([dataList count]==0 || dataList.count<PAGE_SIZE) {
                                                  _footer.hidden=YES;
                                              }
                                              
                                              self.page++;
                                              if (self.page==1) {
                                                  _dataList=[NSMutableArray arrayWithArray:dataList];
                                              }else{
                                                  [_dataList addObjectsFromArray:dataList];
                                              }
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
