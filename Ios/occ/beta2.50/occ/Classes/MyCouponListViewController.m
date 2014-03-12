//
//  YouhuiListViewController.m
//  occ
//
//  Created by RS on 13-8-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyCouponListViewController.h"
#import "MyCouponCell.h"

@interface MyCouponListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation MyCouponListViewController

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
        _dataList =[[NSMutableArray alloc]init];
    }
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"优惠券"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    //UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doFilter:) andButtonType:OCCNavigationButtonTypeFilter andLeft:NO];
    //[headView addSubview:rightButton];
    
    OCCSearchBar *searchBar = [[OCCSearchBar alloc]initWithFrame:CGRectMake(0.0, HEADER_HEIGHT, SCREEN_WIDTH, 45)];
    searchBar.delegate = self;
    [searchBar setText:@""];
    //[self.view addSubview:searchBar];
    _searchBar=searchBar;
    
    //tab===========================================================
    UIView *segementView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    segementView.backgroundColor = COLOR_BG_CLASSONE;
    [self.view addSubview:segementView];
    
    OCCSegement *segement = [[OCCSegement alloc] initWithFrame:CGRectMake(10, (HEADER_HEIGHT - 28)/2, SCREEN_WIDTH - 10*2, 28)
                                                          type:OCCSegementTypeDefaultThree
                                                 andTitleArray:[NSArray arrayWithObjects:@"当前最新",@"我的优惠券",nil]];
    segement.delegate = self;
    [segementView addSubview:segement];
    
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,2*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-2*HEADER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [tableView setDataType:DataTypeCouponCode];
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
    
    self.page=0;
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

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    UITouch *touch = [[event allTouches]anyObject];
    //UIView *touchView=touch.view;
    [_searchBar resignFirstResponder];
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
    switch (index)
    {
        case 0:
            self.type=CouponTypeLasted;
            break;
        case 1:
            self.type=CouponTypeMy;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int total=[_dataList count]/2+[_dataList count]%2;
    return total;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 233.0;
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
    static NSString *MyCouponCellIdentifier=@"MyCouponCellIdentifier";
    
    MyCouponCell *cell = (MyCouponCell*)[tableView dequeueReusableCellWithIdentifier:MyCouponCellIdentifier];
    if (cell == nil)
    {
        cell = [[MyCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCouponCellIdentifier];
    }
    
    int row=indexPath.row;
    int section=indexPath.section;
    int total=[_dataList count];
    if (2*row<total) {
        [cell setData1:[_dataList objectAtIndex:(2*row)]];
    }else{
        [cell setData1:nil];
    }
    if ((2*row+1)<total) {
        [cell setData2:[_dataList objectAtIndex:(2*row+1)]];
    }else{
        [cell setData2:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row*2==(_dataList.count-PAGE_SIZE/2)||indexPath.row*2+1==(_dataList.count-PAGE_SIZE/2))
    {
        if (_footer.hidden==NO)
        {
            [_footer beginRefreshing];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
    [searchBar resignFirstResponder];
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
                                                  [NSNumber numberWithInt:self.type], @"type",
                                                  [NSNumber numberWithInt:self.page+1], @"page",
                                                  _searchBar.text, @"keyword",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.tableView setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:shopCashCouponListMobile_URL andData:reqdata andDelegate:nil];
                       
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
                                              NSArray *dataList=[data objectForKey:@"bargainList"];
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
                                              [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
