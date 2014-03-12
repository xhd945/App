//
//  ShopViewController.m
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ShopViewController.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "GoodsViewController.h"
#import "GrouponViewController.h"
#import "GoodsFilterLeftViewController.h"
#import "GoodsFilterViewController.h"
#import "GoodsCell.h"
#import "Shop.h"

#define kCellHeightList 90.0
#define kCellHeightGird 200.0

@interface ShopViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation ShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _showType = ShopModeTypeGird;
    _dataList =[[NSMutableArray alloc]init];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable setTextColor:COLOR_333333];
    [titleLable setFont:FONT_BOLD_20];
    [titleLable setBackgroundColor:[UIColor clearColor]];
    [titleLable setText:[NSString stringWithFormat:@"店铺"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doFilterLeft:) andButtonType:OCCNavigationButtonTypeFilterLeft andLeft:YES];
    [topImageView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doFilter:) andButtonType:OCCNavigationButtonTypeFilter andLeft:NO];
    [topImageView addSubview:rightButton];
    
    OCCSearchBar *searchBar = [[OCCSearchBar alloc]initWithFrame:CGRectMake(50.0, 0.0, SCREEN_WIDTH-100, 45)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = NO;
    [self.view addSubview:searchBar];
    _searchBar=searchBar;
    
    //shop head===========================================================
    _shopHeaderView = [[ShopInfoHeadView alloc]initWithFrame:CGRectZero];
    
    OCCSegementShop *segement = [[OCCSegementShop alloc] initWithFrame:CGRectMake(10, _shopHeaderView.frame.size.height+ (HEADER_HEIGHT-28)/2, 300, 28)];
    segement.delegate = self;
    
    _tableHeaderView = [[UIView alloc]init];
    _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _shopHeaderView.frame.size.height + HEADER_HEIGHT);
    _tableHeaderView.clipsToBounds=YES;
    [_tableHeaderView addSubview:_shopHeaderView];
    [_tableHeaderView addSubview:segement];
    
    //toolbar===========================================================
    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    toolBarView.backgroundColor = COLOR_BG_CLASSTHREE;
    
    UIView *leftToolButton = [CommonMethods toolBarButtonWithTarget:self andSelector:@selector(doBack:) andButtonType:OCCToolBarButtonTypeBack andLeft:YES];
    [toolBarView addSubview:leftToolButton];
    
    _showListBtn = [CommonMethods toolBarButtonWithTarget:self andSelector:@selector(changeToList:) andButtonType:OCCToolBarButtonTypeList andLeft:NO];
    [toolBarView addSubview:_showListBtn];
    ((UIButton *)_showListBtn).enabled = (_showType == ShopModeTypeList)?NO:YES;
    
    _showGirdBtn = [CommonMethods toolBarButtonWithTarget:self andSelector:@selector(changeToList:) andButtonType:OCCToolBarButtonTypeGird andLeft:NO];
    CGRect selfRect = _showGirdBtn.frame;
    selfRect.origin.x = _showListBtn.frame.origin.x - HEADER_HEIGHT;
    _showGirdBtn.frame = selfRect;
    [toolBarView addSubview:_showGirdBtn];
    ((UIButton *)_showGirdBtn).enabled = (_showType == ShopModeTypeGird)?NO:YES;
    [self.view addSubview:toolBarView];
    
    //item table===========================================================
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT*2)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [tableView setDataType:DataTypeGoods];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_header free];
    [_footer free];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    //UITouch *touch = [[event allTouches]anyObject];
    //UIView *touchView=touch.view;
    [_searchBar resignFirstResponder];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doFilterLeft:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)doFilter:(id)sender
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)changeToList:(id)sender
{
    if (sender == _showListBtn)
    {
        [(UIButton *)_showListBtn setEnabled:NO];
        [(UIButton *)_showGirdBtn setEnabled:YES];
        if (_showType != ShopModeTypeList)
        {
            _showType = ShopModeTypeList;
            [_tableView reloadData];
        }
    }
    else if (sender == _showGirdBtn)
    {
        [(UIButton *)_showGirdBtn setEnabled:NO];
        [(UIButton *)_showListBtn setEnabled:YES];
        if (_showType != ShopModeTypeGird)
        {
            _showType = ShopModeTypeGird;
            [_tableView reloadData];
            [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        }
    }
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    double delayInSeconds = REFRESH_TIME_INTERVAL;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (refreshView == _header)
        {
            [self reloadDataList];
        }
        else if (refreshView == _footer)
        {
            [self loadDataList];
        }
    });
}

#pragma mark -
#pragma mark GoodsGirdCellDelegate
- (void)didSelectedIndexWithData:(Goods *)data
{
    [self pushToInfoController:data];
}

#pragma mark - 
#pragma mark Pust To Goods/GroupOn
- (void)pushToInfoController:(Goods *)data
{
    GoodsViewController *viewController=[[GoodsViewController alloc]init];
    [viewController setItemId:[data.goodsID longValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark OCCSegementShopDelegate
- (void)selectedSegementToSort:(NSInteger)index
{
    // 0:新品；1：销量；2：人气；3：价格降序；4：价格升序；
    self.orderType=index;
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    //[self filterDataList];
    [_header beginRefreshing];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == ShopModeTypeGird)
    {
        return kCellHeightGird;
    }
    else
    {
        return kCellHeightList;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showType == ShopModeTypeGird)
    {
        return [_dataList count]/2 + [_dataList count]%2;
    }
    else
    {
        return _dataList.count;
    }
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
    if (_showType == ShopModeTypeGird)
    {
        static NSString *ShopGoodsGridCellIdentifier=@"ShopGoodsGirdCellIdentifier";
        
        GoodsGredCell *cell = (GoodsGredCell *)[tableView dequeueReusableCellWithIdentifier:ShopGoodsGridCellIdentifier];
        if (cell == nil)
        {
            cell = [[GoodsGredCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShopGoodsGridCellIdentifier];
            cell.delegate = self;
        }
        
        NSInteger row = indexPath.row;
        NSInteger total=[_dataList count];
        if (2*row < total)
        {
            Goods *data = [_dataList objectAtIndex:(2 * row)];
            [cell setGoodsDataOne:data];
        }
        if ((2*row+1) < total)
        {
            Goods *data = [_dataList objectAtIndex:(2 * row + 1 )];
            [cell setGoodsDataTwo:data];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        if (indexPath.row*2==(_dataList.count-PAGE_SIZE/2)||indexPath.row*2+1==(_dataList.count-PAGE_SIZE/2))
        {
            if (_footer.hidden == NO)
            {
                [_footer beginRefreshing];
            }
        }
        
        return cell;
    }
    else
    {
        static NSString *ShopGoodsListCellIdentifier=@"ShopGoodsListCellIdentifier";
        
        GoodsCell *cell = (GoodsCell *)[tableView dequeueReusableCellWithIdentifier:ShopGoodsListCellIdentifier];
        if (cell == nil)
        {
            cell = [[GoodsCell alloc] initWithGoodsCellStyle:GoodsCellTypeDefault reuseIdentifier:ShopGoodsListCellIdentifier];
        }
        
        Goods *data = [_dataList objectAtIndex:indexPath.row];
        [cell setDataForGoods:data];
        cell.backgroundColor = [UIColor clearColor];
        
        if (indexPath.row*1==(_dataList.count-PAGE_SIZE/2))
        {
            if (_footer.hidden == NO)
            {
                [_footer beginRefreshing];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_showType == ShopModeTypeList)
    {
        Goods *data = [_dataList objectAtIndex:indexPath.row];
        [self pushToInfoController:data];
    }
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
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self filterDataList];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    
}

- (void)reloadDataList
{
    self.page=0;
    [self loadDataList];
}

- (void)loadDataList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSString *shopId = [_data valueForKey:KEY_SHOPID] == nil ? [_data valueForKey:KEY_ID] : [_data valueForKey:KEY_SHOPID];
                       
                       GoodsFilterLeftViewController *leftController=(GoodsFilterLeftViewController *)self.viewDeckController.leftController;
                       NSString *categoryId=[leftController.data objectForKey:@"id"];
                       if (categoryId==nil) {
                           categoryId=@"0";
                       }
                       
                       GoodsFilterViewController *rightController=(GoodsFilterViewController *)self.viewDeckController.rightController;
                       NSString *priceFrom=rightController.priceFrom;
                       if(priceFrom==nil){
                           priceFrom=MIN_PRICE;
                       }
                       NSString *priceTo=rightController.priceTo;
                       if(priceTo==nil){
                           priceTo=MAX_PRICE;
                       }
                       
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  shopId,KEY_SHOPID,
                                                  [NSNumber numberWithInt:self.orderType],KEY_ORDERTYPE,
                                                  categoryId, @"categoryId",
                                                  priceFrom, @"priceFrom",
                                                  priceTo, @"priceTo",
                                                  self.searchBar.text,KEY_KEYWORD,
                                                  [NSNumber numberWithInt:self.page+1], KEY_PAGE,
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.tableView setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadShop_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
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
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSMutableDictionary *data=[NSMutableDictionary dictionaryWithDictionary:[root objectForKey:@"data"]];
                                              [data setObject:shopId forKey:KEY_ID];
                                              NSArray *dataList=[data objectForKey:@"itemList"];
                                              if ([dataList count]==0 || dataList.count<PAGE_SIZE)
                                              {
                                                  _footer.hidden=YES;
                                              }
                                              else
                                              {
                                                 _footer.hidden=NO;
                                              }
                                              
                                              self.page++;
                                              if (self.page==1)
                                              {
                                                  [_dataList removeAllObjects];
                                                  
                                                  Shop *shopData = [Shop shopWithDic:data];
                                                  [_shopHeaderView setDataForShopHeader:shopData];
                                                  [_tableView setTableHeaderView:_tableHeaderView];
                                                  if ([self.viewDeckController.leftController respondsToSelector:@selector(setDataList:)])
                                                  {
                                                      [self.viewDeckController.leftController performSelector:@selector(setDataList:) withObject:shopData.shopCategoryList];
                                                  }
                                              }
                                              
                                              for (NSDictionary *item in dataList)
                                              {
                                                  Goods *goodsData = [Goods goodsWithDic:item];
                                                  [_dataList addObject:goodsData];
                                              }

                                              [_tableView reloadData];
                                              if (_showType == ShopModeTypeGird)
                                              {
                                                  [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                              }
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)filterDataList
{
    self.page=0;
    [self loadDataList];
}

@end
