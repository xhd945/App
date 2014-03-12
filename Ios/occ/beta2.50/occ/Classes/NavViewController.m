//
//  LeftViewController.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NavViewController.h"
#import "NavFloorViewController.h"
#import "NavBrandViewController.h"
#import "NavItemViewController.h"
#import "NavCell.h"
#import "AppDelegate.h"
#import "GrouponListViewController.h"
#import "ActivityListViewController.h"
#import "ActivityFilterViewController.h"
#import "GrouponFilterViewController.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "SearchManager.h"
#import "OCCDefine.h"

#define kSectionHeight 40

@interface NavViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation NavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = COLOR_BG_CLASSTWO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMallNotification:)
                                                 name:@"changeMallNotification"
                                               object:nil];
    
    //导航写死数据
    NSArray *first=[NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"icon_floor",@"image",
                     @"icon_floor_selected",@"image_selected",
                     @"楼层",@"title",
                     nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"icon_brand",@"image",
                     @"icon_brand_selected",@"image_selected",
                     @"品牌",@"title",
                     nil],
                    /*
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"icon_activity",@"image",
                     @"icon_activity_selected",@"image_selected",
                     @"活动",@"title",
                     nil],
                     */
                    nil];
    
    NSArray *second =[NSArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"icon_food",@"image",
                 @"icon_food_selected",@"image_selected",
                 @"美食",@"title",
                 nil],
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"icon_disport",@"image",
                 @"icon_disport_selected",@"image_selected",
                 @"娱乐",@"title",
                 nil],
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"icon_shop",@"image",
                 @"icon_shop_selected",@"image_selected",
                 @"购物",@"title",
                 nil],
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"icon_groupon",@"image",
                 @"icon_groupon_selected",@"image_selected",
                 @"团购",@"title",
                 nil],
                nil];
    
    _dataList =[NSArray arrayWithObjects:first,second,nil];
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassTwo];
    [self.view addSubview:topImageView];
    
    UIButton *backButton = [[UIButton alloc]init];
    UIImage *bgImage = [UIImage imageNamed:@"navi_btn_bg_two"];
    [backButton setFrame:CGRectMake(0, (HEADER_HEIGHT - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height)];
    [backButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_icon_back_right"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(doHome:) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:backButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeLeftNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"%@",kBaoLongTitle]];
    [titleLable setFrame:CGRectMake(backButton.frame.origin.x + backButton.frame.size.width,5, LEFTVIEW_WIDTH - (backButton.frame.origin.x + backButton.frame.size.width), HEADER_HEIGHT-10)];
    [topImageView addSubview:titleLable];
        
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStylePlain];
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

- (void)changeMallNotification:(NSNotification *)noti
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataList objectAtIndex:section]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeight)];
    aView.backgroundColor = COLOR_594F47;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (kSectionHeight - 18)/2, 18, 18)];
    [aView addSubview:imageView];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 10, 0, aView.frame.size.width, kSectionHeight)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.font = FONT_16;
    if (section == 0)
    {
        aLabel.text = @"找店";
        imageView.image = [UIImage imageNamed:@"icon_find"];
    }
    else if (section == 1)
    {
        aLabel.text = @"逛场子";
        imageView.image = [UIImage imageNamed:@"icon_visit"];
    }
    [aLabel setTextColor:COLOR_A6978D];
    [aView addSubview:aLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kSectionHeight - 1, tableView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line_navi"]];
    [aView addSubview:lineView];
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NavCellIdentifier=@"NavCellIdentifier";
    
    NavCell *cell = (NavCell*)[tableView dequeueReusableCellWithIdentifier:NavCellIdentifier];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NavCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    int row=indexPath.row;
    int section=indexPath.section;
    NSDictionary *data = [[_dataList objectAtIndex:section]objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setData:data];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row=indexPath.row;
    int section=indexPath.section;
    switch (section)
    {
        case 0:
        {
            if (row==0)
            {
                //楼层
                NavFloorViewController *viewController=[[NavFloorViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
            else if(row==1)
            {
                //品牌
                NavBrandViewController *viewController=[[NavBrandViewController alloc]init];
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                [myDelegate.navigationController pushViewController:viewController animated:YES];
                return;
            }else if(row==2)
            {
                //活动
                ActivityFilterViewController *rightController=[[ActivityFilterViewController alloc]init];
                ActivityListViewController *centerController=[[ActivityListViewController alloc]init];
                IIViewDeckController *deckController=[[IIViewDeckController alloc]init];
                deckController.leftController=nil;
                deckController.centerController=centerController;
                deckController.rightController=[[UINavigationController alloc]initWithRootViewController:rightController];
                deckController.leftSize = 60;
                deckController.rightSize = 60;
                deckController.openSlideAnimationDuration = 0.3f;
                deckController.closeSlideAnimationDuration = 0.3f;
                deckController.bounceOpenSideDurationFactor = 0.3f;
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                [myDelegate.navigationController pushViewController:deckController animated:YES];
                return;
            }
        }
            break;
        case 1:
        {
            if (row==0)
            {
                //美食
                NavItemViewController *viewController=[[NavItemViewController alloc]init];
                viewController.naviID=NavTypeFood;
                viewController.levelId = 2;//二级导航
                viewController.titleString = @"美食";
                viewController.parentId = 0; //根节点传递0
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
            else if(row==1)
            {
                //娱乐
                NavItemViewController *viewController=[[NavItemViewController alloc]init];
                viewController.naviID=NavTypeEntertainment;
                viewController.levelId = 2;//二级导航
                viewController.parentId = 0; //根节点传递0
                viewController.titleString = @"娱乐";
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
            else if(row==2)
            {
                //购物
                NavItemViewController *viewController=[[NavItemViewController alloc]init];
                viewController.levelId = 2;  //二级导航
                viewController.parentId = 0; //根节点传递0
                viewController.naviID=NavTypeBuy;
                viewController.titleString = @"购物";
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
            else if(row==3)
            {
                //团购列表
                GrouponListViewController *centerController=[[GrouponListViewController alloc]init];
                IIViewDeckController *deckController=[[IIViewDeckController alloc]init];
                deckController.leftController=nil;
                deckController.centerController=centerController;
                deckController.rightController=nil;
                deckController.leftSize = 60;
                deckController.rightSize = 60;
                deckController.openSlideAnimationDuration = 0.3f;
                deckController.closeSlideAnimationDuration = 0.3f;
                deckController.bounceOpenSideDurationFactor = 0.3f;
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                [myDelegate.navigationController pushViewController:deckController animated:YES];
                return;
            }
        }
            break;
        default:
            break;
    }
}

-(void)reloadDataList
{
    [_header endRefreshing];
    [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeFloor];
    [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeBrand];
    [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeActivity];
    [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeFood];
    [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeEntertainment];
}

@end
