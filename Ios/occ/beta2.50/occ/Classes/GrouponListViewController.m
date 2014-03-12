//
//  GrouponListViewController.m
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponListViewController.h"
#import "GrouponViewController.h"
#import "AppDelegate.h"
#import "GoodsCell.h"
#import "ShopCell.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "Shop.h"
#import "Goods.h"
#import "GrouponCell.h"

@interface GrouponListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation GrouponListViewController

#pragma mark -
#pragma mark View Life Cycel
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataList =[[NSMutableArray alloc]init];
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [topImageView addSubview:leftButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"团购"]];
    [titleLable setFrame:CGRectMake(leftButton.frame.origin.x + leftButton.frame.size.width, 0, SCREEN_WIDTH-HEADER_HEIGHT*2-10, HEADER_HEIGHT)];
    [topImageView addSubview:titleLable];
    
    //tab===========================================================
    UIView *segementView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    segementView.backgroundColor = COLOR_BG_CLASSONE;
    [self.view addSubview:segementView];
    
    OCCSegement *segement = [[OCCSegement alloc] initWithFrame:CGRectMake(10, (HEADER_HEIGHT - 28)/2, SCREEN_WIDTH - 10*2, 28)
                                                          type:OCCSegementTypeDefaultThree
                                                 andTitleArray:[NSArray arrayWithObjects:@"最新",@"美食",@"娱乐",@"购物",nil]];
    segement.delegate = self;
    [segementView addSubview:segement];
        
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,2*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-2*HEADER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [tableView setDataType:DataTypeGoods];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor = [UIColor clearColor];
    _header.scrollView = _tableView;
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.backgroundColor = [UIColor clearColor];
    _footer.scrollView = _tableView;
    
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

#pragma mark -
#pragma mark Methods
- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doFilter:(id)sender
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

#pragma mark -
#pragma mark OCCSegementDelegate
- (void)selectedSegementIndex:(NSInteger)index
{
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    self.type=index;
    [self reloadDataList];
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
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
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
    if (indexPath.row == (_dataList.count - PAGE_SIZE/2))
    {
        //没有下一页则不显示分页刷新
        if (_footer.hidden == NO)
        {
            [_footer beginRefreshing];
        }
    }
    
    static NSString *GrouponCellIdentifier=@"GrouponCellIdentifier";
    GrouponCell *cell = (GrouponCell*)[tableView dequeueReusableCellWithIdentifier:GrouponCellIdentifier];
    if (cell == nil)
    {
        cell = [[GrouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GrouponCellIdentifier];
    }
    [cell setData:[_dataList objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GrouponViewController *viewController=[[GrouponViewController alloc]init];
    NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
    [viewController setGrouponId:[[data objectForKey:@"id"]longValue]];
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

-(void)reloadDataList
{
    self.page = 0;
    [self loadDataList];
}

-(void)loadDataList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [NSNumber numberWithInt:self.page+1], KEY_PAGE,
                                                  [NSNumber numberWithInt:self.type], KEY_TYPE,
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.tableView setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:grouponList_URL andData:reqdata andDelegate:nil];
                       
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
                                              NSArray *dataList=[data objectForKey:@"grouponList"];
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
