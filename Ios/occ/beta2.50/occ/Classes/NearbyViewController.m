//
//  NearbyViewController.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NearbyViewController.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "NearbyCell.h"

@interface NearbyViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation NearbyViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMallNotification:)
                                                 name:@"changeMallNotification"
                                               object:nil];
    
    _expandRow=-1;
    _dataList =[[NSMutableArray alloc]initWithObjects:
                //[[NSDictionary alloc]initWithObjectsAndKeys:@"nearby1",@"picturePath", nil],
                //[[NSDictionary alloc]initWithObjectsAndKeys:@"nearby2",@"picturePath", nil],
                //[[NSDictionary alloc]initWithObjectsAndKeys:@"nearby3",@"picturePath", nil],
                //[[NSDictionary alloc]initWithObjectsAndKeys:@"nearby4",@"picturePath", nil],
                //[[NSDictionary alloc]initWithObjectsAndKeys:@"nearby5",@"picturePath", nil],
                nil];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:@"附近"];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [topImageView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doToggleLeftView:) andButtonType:OCCNavigationButtonTypeShowLeft andLeft:YES];
    [topImageView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTitle:@"地图" WithTarget:self andSelector:@selector(toMap:) andLeft:NO];
    [topImageView addSubview:rightButton];
    
    UIView *refreshButton = [CommonMethods navigationButtonWithTitle:@"刷新" WithTarget:self andSelector:@selector(doRefresh:) andLeft:NO];
    [topImageView addSubview:refreshButton];
    [refreshButton setCenter:CGPointMake(refreshButton.center.x-55, refreshButton.center.y)];
    
    UIImageView *tableHeaderImageView=[[UIImageView alloc]init];
    [tableHeaderImageView setFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT - FOOTER_HEIGHT)];
    [tableHeaderImageView setImage:[UIImage imageNamed:@"nearby1.jpg"]];
    _tableHeaderImageView=tableHeaderImageView;
    
    UITableView *tableView=[[UITableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT - FOOTER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setTableHeaderView:tableHeaderImageView];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
    [self reloadDataList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_header free];
    [_footer free];
}

- (void)changeMallNotification:(NSNotification *)noti
{
    [_header beginRefreshing];
}

- (void)doRefresh:(id)sender
{
    [_header beginRefreshing];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toMap:(id)sender
{
    MapViewController *viewController=[[MapViewController alloc]init];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.topView=YES;
    [self reloadDataListAfter3Seconds];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.topView=NO;
}

#pragma mark -
#pragma mark Methods
- (void)doToggleLeftView:(id)sender
{
    [_delegate toggleLeftView];
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView==_header)
    {
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(reloadDataList) userInfo:nil repeats:NO];
    }
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
    return _expandRow==indexPath.row?425:180;
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
    static NSString *NearbyCellIdentifier=@"NearbyCellIdentifier";
    
    NearbyCell *cell = (NearbyCell*)[tableView dequeueReusableCellWithIdentifier:NearbyCellIdentifier];
    if (cell == nil)
    {
        cell=[[NearbyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NearbyCellIdentifier];
    }

    NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    if (_expandRow!=row)
    {
        NSIndexPath *lastIndexPath=[NSIndexPath indexPathForRow:_expandRow inSection:0];
        _expandRow=indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,lastIndexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        _expandRow=-1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark - Your SlideImageView
- (void)SlideImageViewDidClickWithIndex:(int)index
{
    //NSString* indexStr = [[NSString alloc]initWithFormat:@"点击了第%d张",index];
}

- (void)SlideImageViewDidEndScorllWithIndex:(int)index
{
    //NSString* indexStr = [[NSString alloc]initWithFormat:@"当前为第%d张",index];
}

#pragma mark -
#pragma mark - Your actions
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
                                                  [OCCUtiil getWifiMac], @"mac",
                                                  @"0", @"skip",
                                                  @"5", @"size",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:getShopInfo_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [_header endRefreshing];
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
                                              [self reloadDataListAfter3Seconds];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:self.view];
                                              [self reloadDataListAfter3Seconds];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSArray *list=[[root objectForKey:@"data"]objectForKey:@"shopList"];
                                               _dataList=list;
                                              if ([list count]>0)
                                              {
                                                  self.tableView.tableHeaderView=nil;
                                              }
                                              else
                                              {
                                                  self.tableView.tableHeaderView=_tableHeaderImageView;
                                              }
                                              [self.tableView reloadData];
                                              
                                              [self reloadDataListAfter3Seconds];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [self reloadDataListAfter3Seconds];
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(void)reloadDataListAfter3Seconds
{
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.topView==YES&&_dataList.count==0)
        {
            [self reloadDataList];
        }
    });
}

@end

