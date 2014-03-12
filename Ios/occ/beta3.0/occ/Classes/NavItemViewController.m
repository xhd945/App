//
//  LeftItemViewController.m
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NavItemViewController.h"
#import "NavItemCell.h"
#import "AppDelegate.h"

#import "ShopListViewController.h"
#import "GoodsListViewController.h"
#import "GrouponFilterViewController.h"
#import "ShopFilterViewController.h"
#import "GoodsFilterLeftViewController.h"
#import "GoodsFilterViewController.h"
#import "NaviManager.h"
#import "NaviData.h"

@interface NavItemViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
}

@end

@implementation NavItemViewController

#pragma mark -
#pragma mark Data Process
- (void)sortData
{
    if (_dataList==nil)
    {
        _dataList =[[NSMutableArray alloc]init];
    }
    
    NSArray *naviData = [[BusinessManager sharedManager].naviManager getNaviDataFromLocalWithNaviID:_naviID];
    
    for (NaviData *data in naviData)
    {
        //过滤出来本级的列表
        if ([data.naviLevel intValue] == _levelId)
        {
            //PrentID为0标示根节点
            if (_parentId == 0)
            {
                [_dataList addObject:data];
            }
            else
            {
                //根据ParientID 选择当前Level的数据
                if ([data.naviParendId integerValue] == _parentId)
                {
                    [_dataList addObject:data];
                }
            }
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
    
    //UIView *leftView = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:) withNavigationType:OCCNavigationTypeClassOne];
    //[topImageView addSubview:leftView];
    
    UIButton *leftView = [[UIButton alloc]init];
    UIImage *bgImage = [UIImage imageNamed:@"navi_btn_bg_two"];
    [leftView setFrame:CGRectMake(0, (HEADER_HEIGHT - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height)];
    [leftView setBackgroundImage:bgImage forState:UIControlStateNormal];
    [leftView setImage:[UIImage imageNamed:@"navi_icon_back"] forState:UIControlStateNormal];
    [leftView addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:leftView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftView.frame.origin.x + leftView.frame.size.width, 5, 200, HEADER_HEIGHT-10)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel labelWithType:OCCLabelTypeLeftNavigationTitle];
    titleLabel.text = _titleString;
    [topImageView addSubview:titleLabel];

    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,LEFTVIEW_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    if (_levelId == 2)
    {
        _header = [[MJRefreshHeaderView alloc] init];
        _header.delegate = self;
        _header.backgroundColor = [UIColor clearColor];
        _header.scrollView = _tableView;
    }
    
    [self sortData];
    if ([_dataList count] == 0 && _levelId == 2)
    {
        ZSLog(@"导航[%d]数据数据为空 开始请求",_naviID);
        [self reloadDataList];
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
    //[self.viewDeckController closeLeftViewAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doHome:(id)sender
{
    [self.viewDeckController closeLeftViewAnimated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NavItemCellIdentifier=@"NavItemCellIdentifier";
    
    NavItemCell *cell = (NavItemCell*)[tableView dequeueReusableCellWithIdentifier:NavItemCellIdentifier];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NavItemCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    int row=indexPath.row;
    NaviData *data = [_dataList objectAtIndex:row];
    [cell setData:data];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row=indexPath.row;
    NaviData *data = [_dataList  objectAtIndex:row];
    int is_parent = [data.naviIsParent intValue];
    if (is_parent == 0)
    {
        NavItemViewController *viewController=[[NavItemViewController alloc]init];
        viewController.naviID =self.naviID;
        viewController.parentId = [data.naviID intValue];
        viewController.levelId = _levelId + 1;
        viewController.titleString = data.naviName;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (is_parent == 1)
    {
        if (self.naviID==NavTypeBuy)
        {
            GoodsFilterViewController *rightController=[[GoodsFilterViewController alloc]init];
            GoodsListViewController *centerController=[[GoodsListViewController alloc]init];
            centerController.titleString = data.naviName;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 data.naviRequestData,HTTP_KEY_DATA,
                                 data.naviMethod,KEY_METHOD,
                                 data.naviName,KEY_KEYWORD,
                                 nil];
            [centerController setData:dic];
            
            IIViewDeckController *deckController=[[IIViewDeckController alloc]init];
            deckController.leftController=nil;
            deckController.centerController=centerController;
            deckController.rightController=rightController;
            deckController.leftSize = 60;
            deckController.rightSize = 60;
            deckController.openSlideAnimationDuration = 0.3f;
            deckController.closeSlideAnimationDuration = 0.3f;
            deckController.bounceOpenSideDurationFactor = 0.3f;
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:deckController animated:YES];
        }
        else if (self.naviID==NavTypeFood)
        {
            ShopListViewController *centerController=[[ShopListViewController alloc]init];
            centerController.titleString = data.naviName;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 data.naviRequestData,HTTP_KEY_DATA,
                                 data.naviMethod,KEY_METHOD,
                                 data.naviName,KEY_KEYWORD,
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
        else if (self.naviID==NavTypeEntertainment)
        {
            ShopListViewController *centerController=[[ShopListViewController alloc]init];
            centerController.titleString = data.naviName;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 data.naviRequestData,HTTP_KEY_DATA,
                                 data.naviMethod,KEY_METHOD,
                                 data.naviName,KEY_KEYWORD,
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
    }
}

#pragma mark -
#pragma mark 请求导航数据返回
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
            ZSLog(@"请求导航数据失败:%@",returnCode.codeDesc);
        }
    }
}

-(void)reloadDataList
{
    [[BusinessManager sharedManager].naviManager loadNaviData:_naviID];
}

@end
