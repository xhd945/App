//
//  OrderListViewController.m
//  occ
//
//  Created by RS on 13-8-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "MyOrderStatusCell.h"
#import "MyOrderItemCell.h"
#import "MyOrderTotalCell.h"
#import "MyOrderRestCell.h"
#import "OrderViewController.h"

@interface MyOrderListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation MyOrderListViewController

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
    _dataList =[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(confirmOrderSuccessNotification:)
                                                 name:@"confirmOrderSuccessNotification"
                                               object:nil];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"待付款"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    OCCSearchBar *searchBar = [[OCCSearchBar alloc]initWithFrame:CGRectMake(0.0, HEADER_HEIGHT, SCREEN_WIDTH, 45)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = NO;
    searchBar.placeholder=@"搜索全部订单";
    searchBar.text=@"";
    [self.view addSubview:searchBar];
    _searchBar=searchBar;

    OCCTableView *tableView=[[OCCTableView alloc]initWithFrame:CGRectMake(0,2*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-2*HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) confirmOrderSuccessNotification:(NSNotification*)notification
{
    [self reloadDataList];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
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
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *order=[_dataList objectAtIndex:section];
    NSArray *itemList=[order objectForKey:KEY_ITEMLIST];
    int total=MIN(itemList.count,2)+3;
    return total;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==[tableView numberOfSections]-1)
    {
        return 55.0;
    }
    
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    NSDictionary *order=[_dataList objectAtIndex:section];
    NSArray *itemList=[order objectForKey:KEY_ITEMLIST];
    
    if (row==0)//显示订单时间
    {
        return 30.0;
    }
    else if (row==MIN(itemList.count,2)+1)//显示剩余2件
    {
        return itemList.count>2?30.0:0.0;
    }
    else if (row==MIN(itemList.count,2)+2)//显示总价
    {
        return 60.0;
    }
    else
    {
        return 100.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    
    if (row==0)
    {
        static NSString *OrderStatusCellIdentifier=@"OrderStatusCellIdentifier";
        
        MyOrderStatusCell *cell = (MyOrderStatusCell*)[tableView dequeueReusableCellWithIdentifier:OrderStatusCellIdentifier];
        if (cell == nil)
        {
            cell=[[MyOrderStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderStatusCellIdentifier];
        }
        
        NSDictionary *data = [_dataList objectAtIndex:section];
        [cell setData:data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.section==(_dataList.count-PAGE_SIZE/2)) {
            if (_footer.hidden==NO) {
                [_footer beginRefreshing];
            }
        }
        return cell;
    }
    
    else if (row==[tableView numberOfRowsInSection:section]-1)
    {
        static NSString *OrderTotalCellIdentifier=@"OrderTotalCellIdentifier";
        
        MyOrderTotalCell *cell = (MyOrderTotalCell*)[tableView dequeueReusableCellWithIdentifier:OrderTotalCellIdentifier];
        if (cell == nil)
        {
            cell=[[MyOrderTotalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderTotalCellIdentifier];
        }
        
        NSDictionary *data = [_dataList objectAtIndex:section];
        [cell setData:data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    else if (row==[tableView numberOfRowsInSection:section]-2)
    {
        static NSString *OrderRestCellIdentifier=@"OrderRestCellIdentifier";
        
        MyOrderRestCell *cell = (MyOrderRestCell*)[tableView dequeueReusableCellWithIdentifier:OrderRestCellIdentifier];
        if (cell == nil)
        {
            cell=[[MyOrderRestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderRestCellIdentifier];
        }
        
        NSDictionary *data = [_dataList objectAtIndex:section];
        [cell setData:data];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    else
    {
        static NSString *OrderItemCellIdentifier=@"OrderItemCellIdentifier";
        
        MyOrderItemCell *cell = (MyOrderItemCell*)[tableView dequeueReusableCellWithIdentifier:OrderItemCellIdentifier];
        if (cell == nil)
        {
            cell=[[MyOrderItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderItemCellIdentifier];
        }
        
        NSDictionary *data = [[[_dataList objectAtIndex:section]objectForKey:KEY_ITEMLIST]objectAtIndex:row-1];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:data];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section=indexPath.section;
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MyOrderRestCell class]]||[cell isKindOfClass:[MyOrderItemCell class]])
    {
        //订单详情
        OrderViewController *viewController=[[OrderViewController alloc]init];
        viewController.orderId=[[[_dataList objectAtIndex:section]objectForKey:@"id"]intValue];
        viewController.orderType=MyOrderTypeMain;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reloadDataList];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    [self reloadDataList];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text=@"";
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
                                                  self.searchBar.text,KEY_KEYWORD,
                                                  [NSNumber numberWithInt:self.page+1],KEY_PAGE,
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.tableView setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadOrderList_URL andData:reqdata andDelegate:nil];
                       
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
                                              NSArray *dataList=[data objectForKey:@"parentOrderList"];
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
