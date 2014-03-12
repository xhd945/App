//
//  LeftBrandViewController.m
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NavBrandViewController.h"
#import "BrandCell.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "Brand.h"

#define kSectionHeaderHeight 20.0
#define kCellHeight 100.0

@interface NavBrandViewController ()

@end

@implementation NavBrandViewController

#pragma mark -
#pragma mark Init Data
- (void)initBrandListData
{
    NSArray *brandArr = [[BusinessManager sharedManager].naviManager getBrandListDataFromLocal];
    if (brandArr == nil || [brandArr count] == 0)
    {
        [_header beginRefreshing];
    }
    else
    {
        [self parsedData:brandArr];
    }
}

- (void)parsedData:(NSArray *)array
{
    for (Brand *brand in array)
    {
        //获取所有的字母 Index
        NSMutableArray *templeBrandArr = nil;
        if (![_letterDataList containsObject:brand.brandName])
        {
            //第一次检索到该字母
            templeBrandArr = [NSMutableArray arrayWithCapacity:10];
            [templeBrandArr addObject:brand];
            [_dataList setObject:templeBrandArr forKey:brand.brandName];
            
            [_letterDataList addObject:brand.brandName];
        }
        else
        {
            //该字母已经存在
            templeBrandArr = [_dataList valueForKey:brand.brandName];
            [templeBrandArr addObject:brand];
        }
    }
}

#pragma mark -
#pragma mark LifeCycel
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestBrandListCallBack:) name:OCC_NOTIFI_NAVI_BRANDLIST_RETURN object:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    _dataList = [[NSMutableDictionary alloc]init];
    _letterDataList = [[NSMutableArray alloc] initWithCapacity:10];
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [topImageView addSubview:leftButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"品牌"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.view addSubview:titleLable];
        
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setSectionFooterHeight:5];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    if ([tableView respondsToSelector:@selector(setSectionIndexColor:)])
    {
        //tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        //tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = _tableView;
    
    [self initBrandListData];
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

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView==_header)
    {
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(reloadDataList) userInfo:nil repeats:NO];
    }
}

#pragma mark -
#pragma mark Methods
- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_letterDataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [_letterDataList objectAtIndex:section];
    NSArray *brandArr = [_dataList objectForKey:key];
    int total = [brandArr count];
    return total/2 + total%2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    UILabel *titleTableLabel=[[UILabel alloc]init];
    [titleTableLabel setFrame:CGRectMake(10, 3, SCREEN_WIDTH, 20)];
    [titleTableLabel setText:[_letterDataList objectAtIndex:section]];
    [titleTableLabel setFont:FONT_BOLD_20];
    [titleTableLabel setTextColor:COLOR_333333];
    [titleTableLabel setBackgroundColor:[UIColor clearColor]];
    [aView addSubview:titleTableLabel];
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BrandCellIdentifier=@"BrandCellIdentifier";
    
    BrandCell *cell = (BrandCell*)[tableView dequeueReusableCellWithIdentifier:BrandCellIdentifier];
    if (cell == nil)
    {
        cell = [[BrandCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BrandCellIdentifier];
    }
    
    int row=indexPath.row;
    int section=indexPath.section;
    NSString *key = [_letterDataList objectAtIndex:section];
    NSArray *brandArr = [_dataList valueForKey:key];
    
    int total=[brandArr count];
    if (2*row<total)
    {
        [cell setData1:[brandArr objectAtIndex:(2*row)]];
    }
    if ((2*row+1)<total)
    {
        [cell setData2:[brandArr objectAtIndex:(2*row+1)]];
    }
    else
    {
        [cell setData2:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *letterDataList=[[NSMutableArray alloc]initWithObjects:@"#",
                                    @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",
                                    @"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",
                                    @"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",
                                    @"Y",@"Z",
                                    nil];
    return letterDataList;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_letterDataList indexOfObject:title];
}

#pragma mark -
#pragma mark BrandList CallBack
- (void)requestBrandListCallBack:(NSNotification *)noti
{
    //结束UI
    [_header endRefreshing];

    NSDictionary *dic = [noti userInfo];
    ReturnCodeModel *returnCode = [dic valueForKey:kReturnCodeKey];
    if (returnCode.code == kReturnSuccess)
    {
        [_dataList removeAllObjects];
        [_letterDataList removeAllObjects];
        NSArray *returnData = [dic valueForKey:kReturnDataKey];
        [self parsedData:returnData];
        [_tableView reloadData];
    }
    else
    {
        //失败提示信息
        [CommonMethods showAutoDismissView:returnCode.codeDesc inView:self.view];
    }
}

-(void)reloadDataList
{
    [[BusinessManager sharedManager].naviManager loadBrandList];
}

@end
