//
//  FloorViewController.m
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NavFloorViewController.h"
#import "FloorCell.h"
#import "AppDelegate.h"
#import "ShopFilterViewController.h"
#import "ShopListViewController.h"

#import "NaviManager.h"
#import "NaviData.h"

@interface NavFloorViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
}

@end

@implementation NavFloorViewController

#pragma mark -
#pragma mark Data Process
- (void)sortData
{
    if (_dataList==nil)
    {
        _dataList =[[NSMutableArray alloc]init];
    }
    
    NSArray *naviArr = [[BusinessManager sharedManager].naviManager getNaviDataFromLocalWithNaviID:self.naviID];
    
    for (NaviData *naviData in naviArr)
    {
        //筛选出二级菜单数据
        int level = [naviData.naviLevel intValue];
        if (level == 2)
        {
            [_dataList addObject:naviData];
        }
    }
}

#pragma mark -
#pragma mark LifeCycel
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNaviDataNoti:) name:OCC_NOTIFI_NAVI_DATA_RETURN object:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = COLOR_BG_CLASSTWO;
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassTwo];
    [self.view addSubview:topImageView];
    
    UIView *leftView = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:) withNavigationType:OCCNavigationTypeClassTwo];
    [topImageView addSubview:leftView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftView.frame.origin.x + leftView.frame.size.width, 5, 200, HEADER_HEIGHT-10)];
    [titleLabel labelWithType:OCCLabelTypeLeftNavigationTitle];
    titleLabel.text = @"楼层";
    [topImageView addSubview:titleLabel];
        
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,LEFTVIEW_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor = [UIColor clearColor];
    _header.scrollView = _tableView;
    
    self.naviID = NavTypeFloor;
    [self sortData];
    if ([_dataList count] == 0)
    {
        ZSLog(@"楼层数据为空 开始请求");
        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeFloor];
    }
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
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FloorCellIdentifier=@"FloorCellIdentifier";
    
    FloorCell *cell = (FloorCell*)[tableView dequeueReusableCellWithIdentifier:FloorCellIdentifier];
    if (cell == nil)
    {
        cell = [[FloorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FloorCellIdentifier];
    }
    
    NaviData *data = [_dataList objectAtIndex:indexPath.row];
    [cell setData:data];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopListViewController *centerController=[[ShopListViewController alloc]init];
    NSString *keyword=@"";
    switch (indexPath.row)
    {
        case 0:
            keyword=@"B1";
            break;
        case 1:
            keyword=@"1F";
            break;
        case 2:
            keyword=@"2F";
            break;
        case 3:
            keyword=@"3F";
            break;
        case 4:
            keyword=@"4F";
            break;
        case 5:
            keyword=@"5F";
            break;
        default:
            break;
    }

    NaviData *data = [_dataList objectAtIndex:indexPath.row];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         data.naviRequestData,HTTP_KEY_DATA,
                         data.naviMethod,KEY_METHOD,
                         keyword,KEY_KEYWORD,
                         nil];
    [centerController setData:dic];
    
    IIViewDeckController *deckController=[[IIViewDeckController alloc]init];
    deckController.leftController=nil;
    deckController.centerController=centerController;
    //deckController.rightController=nil;
    deckController.leftSize = 60;
    deckController.rightSize = 60;
    deckController.openSlideAnimationDuration = 0.3f;
    deckController.closeSlideAnimationDuration = 0.3f;
    deckController.bounceOpenSideDurationFactor = 0.3f;
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:deckController animated:YES];
}

#pragma mark -
#pragma mark 请求楼层数据返回
- (void)requestNaviDataNoti:(NSNotification *)noti
{
    //结束UI
    [_header endRefreshing];
    
    NSDictionary *userInfo = [noti userInfo];
    NSDictionary *requestData = [userInfo objectForKey:kRequestDataKey];
    NSInteger naviID = [[requestData objectForKey:KEY_NAVID] integerValue];
    if (naviID == _naviID)
    {
        //处理数据
        ReturnCodeModel *returnCode = [userInfo objectForKey:kReturnCodeKey];
        if (returnCode.code == kReturnSuccess)
        {
            [_dataList removeAllObjects];
            [self sortData];
            [_tableView reloadData];
        }
        else
        {
            ZSLog(@"请求楼层数据失败:%@",returnCode.codeDesc);
        }
    }
}

-(void)reloadDataList
{
    [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeFloor];
}

@end
