//
//  SearchViewController.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "SearchCategory2ViewController.h"
#import "ShopFilterViewController.h"
#import "SearchCategoryCell.h"
#import "SearchCategory2Cell.h"
#import "AppDelegate.h"
#import "BusinessManager.h"
#import "SearchManager.h"
#import "SearchSuggestCell.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "SearchManager.h"

@interface SearchViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)parsedBaseCategoryData:(NSDictionary *)dic
{
    NSArray *categoryList = [dic objectForKey:KEY_NAVIGATIONLIST];
    for (NSDictionary *dic in categoryList)
    {
        NSMutableArray *detailCatgory = [NSMutableArray arrayWithCapacity:5];
        for (NSDictionary *detailDic in [dic objectForKey:@"lowerCategoryList"])
        {
            [detailCatgory addObject:detailDic];
        }
        
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [dic objectForKey:@"logo"],@"image",
                                 [dic objectForKey:@"name"],@"title",
                                 [dic objectForKey:@"description"],@"detail",
                                 detailCatgory,@"DetailCategory",nil];
        [_categoryDataList addObject:dataDic];
    }
}

- (void)getSearchCategoryData
{
    //获取本地缓存
    NSString *fileName=[NSString stringWithFormat:@"mall_%d_search_baseCategory.plist",[[Singleton sharedInstance]mall]];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:fileName];
    NSDictionary *data=[NSDictionary dictionaryWithContentsOfFile:filePath];
    
    _categoryDataList = [NSMutableArray arrayWithCapacity:5];
    if (data != nil && [data count] > 0)
    {
        [self parsedBaseCategoryData:data];
    }
    else
    {
        [[BusinessManager sharedManager].searchManager requestSearchBaseCategoryData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchBaseCategoryRequestCallBack:)
                                                 name:OCC_NOTIFI_SEARCH_CATEGORY_RETURN
                                               object:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboradWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboradWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMallNotification:)
                                                 name:@"changeMallNotification"
                                               object:nil];
    
    //搜索接口返回数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestSearchSuggestCallBack:)
                                                 name:OCC_NOTIFI_SEARCH_SUGGEST_RETURN
                                               object:nil];

    
    _selectIndex=-1;
    
    [self getSearchCategoryData];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;

    //搜索记录缓存
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:SearchHistoryFileName];
    _historyDataList = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (_historyDataList == nil)
    {
        _historyDataList = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    _suggestDataList = [[NSMutableArray alloc] initWithCapacity:10];
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    OCCSearchBar *searchBar = [[OCCSearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 45)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = NO;
    [self.view addSubview:searchBar];
    _searchBar=searchBar;
    
    UIView *cancelButton = [CommonMethods navigationButtonWithTitle:@"取消" WithTarget:self andSelector:@selector(doCancel:) andLeft:NO];
    [self.view addSubview:cancelButton];
    cancelButton.hidden = YES;
    _cancelButton= (UIButton *)cancelButton;
    
    OCCNormalTableView *suggestTableView=[[OCCNormalTableView alloc]init];
    [suggestTableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-FOOTER_HEIGHT)];
    [suggestTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [suggestTableView setDelegate:self];
    [suggestTableView setDataSource:self];
    [suggestTableView setBackgroundView:nil];
    [suggestTableView setBackgroundColor:COLOR_BG_CLASSONE];
    [suggestTableView setSeparatorColor:COLOR_CELL_LINE_CLASS2];
    [self.view addSubview:suggestTableView];
    _suggestTableView=suggestTableView;
    
    OCCNormalTableView *categoryTableView=[[OCCNormalTableView alloc]init];
    [categoryTableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-FOOTER_HEIGHT)];
    [categoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [categoryTableView setDelegate:self];
    [categoryTableView setDataSource:self];
    [categoryTableView setBackgroundView:nil];
    [categoryTableView setBackgroundColor:COLOR_BG_CLASSONE];
    [categoryTableView setSeparatorColor:COLOR_CELL_LINE_CLASS2];
    [self.view addSubview:categoryTableView];
    _categoryTableView=categoryTableView;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor = [UIColor clearColor];
    _header.scrollView = categoryTableView;
    
    OCCNormalTableView *historyTableView=[[OCCNormalTableView alloc]init];
    [historyTableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-FOOTER_HEIGHT)];
    [historyTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [historyTableView setDelegate:self];
    [historyTableView setDataSource:self];
    [historyTableView setBackgroundView:nil];
    [historyTableView setBackgroundColor:COLOR_BG_CLASSONE];
    [historyTableView setSeparatorColor:COLOR_CELL_LINE_CLASS2];
    [self.view addSubview:historyTableView];
    _historyTableView=historyTableView;
        
    UIView *historyFootView=[[UIView alloc]init];
    [historyFootView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    _historyFootView=historyFootView;
    
    UIImage *whiteImage=[UIImage imageNamed:@"btn_bg_light_gray"];
    whiteImage=[whiteImage stretchableImageWithLeftCapWidth:whiteImage.size.width/2 topCapHeight:whiteImage.size.height/2];
    
    UIButton *clearButton = [[UIButton alloc]init];
    [clearButton setFrame:CGRectMake(10, 10, 300, 44)];
    [clearButton setBackgroundImage:whiteImage forState:UIControlStateNormal];
    //[clearButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.titleLabel.font = FONT_16;
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearButton setTitle:@"清空历史记录" forState:UIControlStateNormal];
    [historyFootView addSubview:clearButton];
    
    categoryTableView.hidden=NO;
    historyTableView.hidden=YES;
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
- (void)doCancel:(id)sender
{
    [_searchBar resignFirstResponder];
    [_searchBar setFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 44)];
    _cancelButton.hidden=YES;
    
    _searchBar.text=@"";
    _categoryTableView.hidden=NO;
    _historyTableView.hidden=YES;
}

- (void)doClear:(id)sender
{
    [_historyDataList removeAllObjects];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:SearchHistoryFileName];
    [_historyDataList writeToFile:filePath atomically:YES];
    [_historyTableView reloadData];
}

- (void)pushToNextViewControllerWithData:(NSDictionary *)data
{    
    SearchResultViewController *centerController=[[SearchResultViewController alloc]init];
    centerController.data = [NSDictionary dictionaryWithDictionary:data];
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
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_categoryTableView)
    {
        if (indexPath.row==_selectIndex)
        {
            return 480.0;
        }
        return 60.0;
    }
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_categoryTableView)
    {
        return _categoryDataList.count;
    }
    else if(tableView ==_historyTableView)
    {
        return [[_historyDataList allKeys] count];
    }
    else if(tableView==_suggestTableView)
    {
        return [_suggestDataList count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _historyTableView) {
        return _historyFootView.frame.size.height;
    }
    else if (tableView == _categoryTableView)
    {
        return [_categoryDataList count]>0?1:0;
    }
    else if (tableView == _suggestTableView)
    {
        return [_suggestDataList count]>0?1:0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _historyTableView)
    {
        return _historyFootView;
    }
    else if (tableView == _categoryTableView)
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    }
    else if (tableView == _suggestTableView)
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_categoryTableView)
    {
        static NSString *categoryCellIdentifier=@"categoryCellIdentifier";
        
        SearchCategoryCell *cell = (SearchCategoryCell *)[tableView dequeueReusableCellWithIdentifier:categoryCellIdentifier];
        if (cell == nil)
        {
            cell = [[SearchCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellIdentifier];
        }
        
        NSDictionary *data = [_categoryDataList objectAtIndex:indexPath.row];
        [cell setData:data];
        return cell;
    }
    else if (tableView == _suggestTableView)
    {
        NSString *suggestCellIdentifier= [NSString stringWithFormat:@"suggestCellIdentifier%d%d",indexPath.section,indexPath.row];
        SearchSuggestCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestCellIdentifier];
        if (!cell)
        {
            cell = [[SearchSuggestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestCellIdentifier];
        }
        
        NSString *text = [_suggestDataList objectAtIndex:indexPath.row];
        if (indexPath.row == 0)
        {
            [cell setText:text andTypeString:@"商品"];
        }
        else if (indexPath.row == 1)
        {
            [cell setText:text andTypeString:@"店铺"];
        }
        else
        {
            [cell setText:text andTypeString:nil];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else 
    {
        static NSString *historyCellIdentifier=@"historyCellIdentifier";
        
        OCCLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellIdentifier];
        if (!cell) {
            cell = [[OCCLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyCellIdentifier];
        }
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font=FONT_16;
        cell.textLabel.textColor=COLOR_333333;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
        cell.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassOne];
        
        NSString *key = [[_historyDataList allKeys] objectAtIndex:indexPath.row];
        if ([[_historyDataList objectForKey:key] integerValue] == OCCSearchClassiFicationItem)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"商品：%@",key];
        }
        else if ([[_historyDataList objectForKey:key] integerValue] == OCCSearchClassiFicationShop)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"店铺：%@",key];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView==_categoryTableView)
    {
        SearchCategory2ViewController *viewController=[[SearchCategory2ViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=NO;
        [viewController.titleLable setText:[[_categoryDataList objectAtIndex:indexPath.row]objectForKey:@"title"]];
        viewController.dataList = [NSMutableArray arrayWithArray:[[_categoryDataList objectAtIndex:indexPath.row] objectForKey:@"DetailCategory"]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        //Push过去 下级页面请求
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:2];
        if (tableView == _historyTableView)
        {
            NSString *key =[[_historyDataList allKeys] objectAtIndex:indexPath.row];
            [data setObject:key forKey:KEY_KEYWORD];
            [data setObject:[_historyDataList valueForKey:key] forKey:KEY_CLASSIFICATION];
        }
        else if (tableView == _suggestTableView)
        {
            NSString *key =[_suggestDataList objectAtIndex:indexPath.row];
            [data setObject:key forKey:KEY_KEYWORD];
            [data setObject:[NSNumber numberWithInteger:indexPath.row==1?OCCSearchClassiFicationShop:OCCSearchClassiFicationItem] forKey:KEY_CLASSIFICATION];
            
            [_historyDataList setObject:[NSNumber numberWithInteger:indexPath.row==1?OCCSearchClassiFicationShop:OCCSearchClassiFicationItem] forKey:key];
            NSString *filePath = [CommonMethods getDataCachePathWithFileName:SearchHistoryFileName];
            [_historyDataList writeToFile:filePath atomically:YES];
            [_historyTableView reloadData];
        }
        
        [self pushToNextViewControllerWithData:data];
        return;
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
#pragma mark SearchBaseCategory CallBack
- (void)searchBaseCategoryRequestCallBack:(NSNotification *)noti
{
    //结束UI
    [_header endRefreshing];
    [_categoryDataList removeAllObjects];
    
    NSDictionary *dic = [noti userInfo];
    ReturnCodeModel *returnCode = [dic valueForKey:kReturnCodeKey];
    if (returnCode.code == kReturnSuccess)
    {
        NSDictionary *returnData = [dic valueForKey:kReturnDataKey];
        [self parsedBaseCategoryData:returnData];
    }
    else
    {
        //失败提示信息
        [CommonMethods showAutoDismissView:returnCode.codeDesc inView:self.view];
    }
    [self.categoryTableView reloadData];
}

#pragma mark -
#pragma mark SearchSuggest CallBack
- (void)parsedSuggestData:(NSDictionary *)dic
{
    [_suggestDataList addObjectsFromArray:[dic valueForKey:@"keyList"]];
    [_suggestTableView reloadData];
}

- (void)requestSearchSuggestCallBack:(NSNotification *)noti
{
    NSDictionary *dic = [noti userInfo];
    NSDictionary *returnData = [dic valueForKey:kReturnDataKey];
    [self parsedSuggestData:returnData];
}

#pragma mark -
#pragma mark KeyBoard Methods
- (void)keyboradWillShow:(NSNotification *)noti
{
    NSValue *keyBoarRect = [[noti userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    _keyBoardHeight = [keyBoarRect CGRectValue].size.height;
    
    CGRect selfRect = _suggestTableView.frame;
    selfRect.size.height = SCREEN_HEIGHT - HEADER_HEIGHT - _keyBoardHeight;
    _suggestTableView.frame = selfRect;
    _categoryTableView.frame = selfRect;
    _historyTableView.frame = selfRect;
}

- (void)keyboradWillHide:(NSNotification *)noti
{
    CGRect selfRect = _suggestTableView.frame;
    selfRect.size.height = SCREEN_HEIGHT - HEADER_HEIGHT-FOOTER_HEIGHT;
    _suggestTableView.frame = selfRect;
    _categoryTableView.frame = selfRect;
    _historyTableView.frame = selfRect;
}

#pragma mark -
#pragma mark Methods
//搜搜框空白 搜索框是第一响应者
- (void)showHistryTable
{
    //点击搜索 显示历史记录
    [_historyTableView reloadData];
    _historyTableView.hidden=NO;
    
    _categoryTableView.hidden=YES;
    _suggestTableView.hidden = YES;
}

//搜索框有内容 搜索框是第一响应者
- (void)showSearchSuggestTable
{
    //点击搜索 显示历史记录
    [_suggestTableView reloadData];
    _suggestTableView.hidden = NO;
     
    _historyTableView.hidden=YES;
    _categoryTableView.hidden=YES;
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar setFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH-60, 44)];
    _cancelButton.hidden=NO;
        
    //searchBar.showsCancelButton=YES;
    if ([[searchBar text]length]>0)
    {        
        [self showSearchSuggestTable];
        
        //实时搜索
        NSDictionary *rquestData = [NSDictionary dictionaryWithObjectsAndKeys:searchBar.text,KEY_KEYWORD, nil];
        [[BusinessManager sharedManager].searchManager requestSearchSuggestData:rquestData];
    }
    else
    {        
        [self showHistryTable];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text length] > 0)
    {
        [_suggestDataList removeAllObjects];
        NSString *defaultGoodsStr = [NSString stringWithFormat:@"%@",searchBar.text];
        NSString *defaultShopStr = [NSString stringWithFormat:@"%@",searchBar.text];
        
        [_suggestDataList addObject:defaultGoodsStr];
        [_suggestDataList addObject:defaultShopStr];
    }
    [self showSearchSuggestTable];
    
    //实时搜索
    NSDictionary *rquestData = [NSDictionary dictionaryWithObjectsAndKeys:searchBar.text,KEY_KEYWORD, nil];
    [[BusinessManager sharedManager].searchManager requestSearchSuggestData:rquestData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar setFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 44)];
    [_searchBar resignFirstResponder];
    _cancelButton.hidden = YES;

    [_historyDataList setObject:[NSNumber numberWithInteger:OCCSearchClassiFicationItem] forKey:searchBar.text];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:SearchHistoryFileName];
    [_historyDataList writeToFile:filePath atomically:YES];
    [_historyTableView reloadData];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          searchBar.text,KEY_KEYWORD,
                          [NSNumber numberWithInteger:OCCSearchClassiFicationItem],KEY_CLASSIFICATION,
                          nil];
    [self pushToNextViewControllerWithData:data];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    _categoryTableView.hidden=NO;
    _historyTableView.hidden=YES;
}

-(void)reloadDataList
{
    [[BusinessManager sharedManager].searchManager requestSearchBaseCategoryData];
}

@end
