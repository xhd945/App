//
//  SearchResultViewController.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "SearchResultViewController.h"
#import "GoodsViewController.h"
#import "GoodsCell.h"
#import "ShopCell.h"
#import "AppDelegate.h"
#import "ShopViewController.h"
#import "ShopFilterViewController.h"
#import "BusinessManager.h"
#import "SearchManager.h"
#import "NaviManager.h"
#import "Shop.h"
#import "Goods.h"

@interface SearchResultViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footerGoods;
    MJRefreshHeaderView *_headerGoods;
    MJRefreshFooterView *_footerShop;
    MJRefreshHeaderView *_headerShop;
}

@end

@implementation SearchResultViewController

#pragma mark -
#pragma mark View Life Cycel
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _shopSearchKeyword=@"";
    _goodsSearchKeyword=@"";
    _goodsDataList =[[NSMutableArray alloc]init];
    _shopDataList =[[NSMutableArray alloc]init];
    _shopPageNo = 0;
    _goodsPageNo = 0;
    
    ShopFilterViewController *shopFilterViewController=[[ShopFilterViewController alloc]init];
    shopFilterViewController.titleString = [_data objectForKey:KEY_KEYWORD];
    self.shopFilterViewController=shopFilterViewController;
    
    GoodsFilterViewController *goodsFilterViewController=[[GoodsFilterViewController alloc]init];
    self.goodsFilterViewController=goodsFilterViewController;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [topImageView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doFilter:) andButtonType:OCCNavigationButtonTypeFilter andLeft:NO];
    [topImageView addSubview:rightButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    CGFloat pointX = leftButton.frame.origin.x + leftButton.frame.size.width + 5;
    [titleLable setFrame:CGRectMake(pointX ,0, rightButton.frame.origin.x - pointX - 5, HEADER_HEIGHT)];
    titleLable.text = [_data valueForKey:KEY_KEYWORD];
    [self.view addSubview:titleLable];
    _titleLable=titleLable;
    
    _segement = [[OCCSegement alloc] initWithFrame:CGRectMake(10, HEADER_HEIGHT+10, 300, 28)
                                              type:OCCSegementTypeDefaultThree
                                     andTitleArray:[NSArray arrayWithObjects:@"商品",@"店铺",nil]];
    _segement.delegate = self;
    [self.view addSubview:_segement];
    
    //***************************************************************************
    UIView *goodsView=[[UIView alloc]init];
    [goodsView setFrame:CGRectMake(0, 2*HEADER_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 2*HEADER_HEIGHT)];
    [goodsView setBackgroundColor:COLOR_BG_CLASSONE];
    
    _goodsTabView = [[OCCTabbar alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 0)
                                         andTitleArr:[NSArray arrayWithObjects:@"人气",@"销量",@"价格",@"搜索", nil]];
    _goodsTabView.delegate = self;
    [goodsView addSubview:_goodsTabView];
    [self.view addSubview:goodsView];
    _goodsView=goodsView;
    
    OCCTableView *goodsTableView=[[OCCTableView alloc]init];
    [goodsTableView setFrame:CGRectMake(0,_goodsTabView.frame.origin.y+_goodsTabView.frame.size.height+1,SCREEN_WIDTH,goodsView.frame.size.height - (_goodsTabView.frame.origin.y+_goodsTabView.frame.size.height))];
    [goodsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [goodsTableView setDelegate:self];
    [goodsTableView setDataSource:self];
    [goodsTableView setDataType:DataTypeGoods];
    [goodsTableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [goodsView addSubview:goodsTableView];
    _goodsTableView=goodsTableView;
    
    _headerGoods = [[MJRefreshHeaderView alloc] init];
    _headerGoods.delegate = self;
    _headerGoods.backgroundColor = [UIColor clearColor];
    _headerGoods.scrollView = _goodsTableView;
    
    _footerGoods = [[MJRefreshFooterView alloc] init];
    _footerGoods.delegate = self;
    _footerGoods.backgroundColor = [UIColor clearColor];
    _footerGoods.scrollView = _goodsTableView;
    
    UIView *goodsMaskView=[[UIView alloc]init];
    [goodsMaskView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [goodsMaskView setBackgroundColor:COLOR_333333];
    [goodsMaskView setAlpha:0.5];
    [goodsMaskView setHidden:YES];
    [goodsView addSubview:goodsMaskView];
    _goodsMaskView=goodsMaskView;
    
    OCCSearchBar *goodsSearchBar = [[OCCSearchBar alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0.0, SCREEN_WIDTH, 45)];
    goodsSearchBar.delegate = self;
    [goodsView addSubview:goodsSearchBar];
    _goodsSearchBar=goodsSearchBar;
    
    //***************************************************************************
    UIView *shopView=[[UIView alloc]init];
    [shopView setFrame:CGRectMake(0, 2*HEADER_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 2*HEADER_HEIGHT)];
    [shopView setBackgroundColor:COLOR_BG_CLASSONE];
    
    _shopTabView = [[OCCTabbar alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 0)
                                        andTitleArr:[NSArray arrayWithObjects:@"人气",@"类别",@"等级",@"搜索", nil]];
    _shopTabView.delegate = self;
    [shopView addSubview:_shopTabView];
    [self.view addSubview:shopView];
    _shopView=shopView;
        
    OCCTableView *shopTableView=[[OCCTableView alloc]init];
    [shopTableView setFrame:CGRectMake(0,_shopTabView.frame.origin.y+_shopTabView.frame.size.height+1,SCREEN_WIDTH,shopView.frame.size.height - _shopTabView.frame.origin.y - _shopTabView.frame.size.height)];
    [shopTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [shopTableView setDelegate:self];
    [shopTableView setDataSource:self];
    [shopTableView setDataType:DataTypeShop];
    [shopTableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [shopView addSubview:shopTableView];
    _shopTableView=shopTableView;
    
    _headerShop = [[MJRefreshHeaderView alloc] init];
    _headerShop.delegate = self;
    _headerShop.backgroundColor = [UIColor clearColor];
    _headerShop.scrollView = _shopTableView;
    
    _footerShop = [[MJRefreshFooterView alloc] init];
    _footerShop.delegate = self;
    _footerShop.backgroundColor = [UIColor clearColor];
    _footerShop.scrollView = _shopTableView;
    
    UIView *shopMaskView=[[UIView alloc]init];
    [shopMaskView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [shopMaskView setBackgroundColor:COLOR_333333];
    [shopMaskView setAlpha:0.5];
    [shopMaskView setHidden:YES];
    [shopView addSubview:shopMaskView];
    _shopMaskView=shopMaskView;
    
    OCCSearchBar *shopSearchBar = [[OCCSearchBar alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0.0, SCREEN_WIDTH, 45)];
    shopSearchBar.delegate = self;
    [shopView addSubview:shopSearchBar];
    _shopSearchBar=shopSearchBar;
    
    //***************************************************************************
    OCCSearchClassiFication type = [[_data valueForKey:KEY_CLASSIFICATION] integerValue];
    if (type == OCCSearchClassiFicationItem)
    {
        [_segement selectItem:0];
        [self selectedSegementIndex:0];
    }
    else if (type == OCCSearchClassiFicationShop)
    {
        [_segement selectItem:1];
        [self selectedSegementIndex:1];
    }
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_headerGoods beginRefreshing];
        [_headerShop beginRefreshing];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_headerGoods free];
    [_footerGoods free];
    [_headerShop free];
    [_footerShop free];
}

#pragma mark -
#pragma mark Methods
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    UITouch *touch = [[event allTouches]anyObject];
    UIView *touchView=touch.view;
    if (touchView==_shopMaskView)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [_shopSearchBar setFrame:CGRectMake(SCREEN_WIDTH,_shopSearchBar.frame.origin.y,_shopSearchBar.frame.size.width,_shopSearchBar.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             touchView.hidden=YES;
                             [_shopSearchBar resignFirstResponder];
                             [_shopSearchBar setText:self.shopSearchKeyword];
                         }];
    }
    
    if (touchView==_goodsMaskView)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [_goodsSearchBar setFrame:CGRectMake(SCREEN_WIDTH,_goodsSearchBar.frame.origin.y,_goodsSearchBar.frame.size.width,_goodsSearchBar.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             touchView.hidden=YES;
                             [_goodsSearchBar resignFirstResponder];
                             [_goodsSearchBar setText:self.goodsSearchKeyword];
                         }];
    }
}

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
    if (index == 0)
    {
        _goodsView.hidden=NO;
        _shopView.hidden=YES;
        self.viewDeckController.rightController=self.goodsFilterViewController;
    }
    else
    {
        _goodsView.hidden=YES;
        _shopView.hidden=NO;
        self.viewDeckController.rightController=self.shopFilterViewController;
    }
    
    NSString *title= [self getTitle];
    [self.titleLable setText:title];
}

#pragma mark -
#pragma mark MJRefreshDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    double delayInSeconds = REFRESH_TIME_INTERVAL;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (refreshView==_headerGoods) {
            [self reloadItemDataList];
        }else if (refreshView==_footerGoods) {
            [self loadItemDataList];
        }
        
        if (refreshView==_headerShop) {
            [self reloadShopDataList];
        }else if (refreshView==_footerShop) {
            [self loadShopDataList];
        }
    });
}

#pragma mark -
#pragma mark OCCTabbarDelegate
- (void)tabbar:(OCCTabbar *)tabbar tapIndex:(NSInteger)index andType:(SortType)sortType
{
    if (tabbar == _goodsTabView)
    {
        switch (index) {
            case 0:
            {
                self.goodsOrderBy=0;
            }
                break;
            case 1:
            {
                self.goodsOrderBy=1;
            }
                break;
            case 2:
            {
                if (sortType==SortTypeDown) {
                    self.goodsOrderBy=3;
                }
                else if (sortType==SortTypeUp) {
                    self.goodsOrderBy=2;
                } 
            }
                break;
            case 3:
            {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     _goodsMaskView.hidden=NO;
                                     [_goodsSearchBar setFrame:CGRectMake(0.0, _goodsSearchBar.frame.origin.y,_goodsSearchBar.frame.size.width, _goodsSearchBar.frame.size.height)];
                                     [_goodsSearchBar becomeFirstResponder];
                                 }
                                 completion:^(BOOL finished){
                                     
                                 }];
            }
                break;
            default:
                break;
        }
        
        [_headerGoods beginRefreshing];
    }
    else if (tabbar == _shopTabView)
    {
        switch (index) {
            case 0:
            {
                self.shopOrderBy=0;
            }
                break;
            case 1:
            {
                self.shopOrderBy=1;
            }
                break;
            case 2:
            {
                if (sortType==SortTypeDown) {
                    self.shopOrderBy=3;
                }
                else if (sortType==SortTypeUp) {
                    self.shopOrderBy=2;
                }
            }
                break;
            case 3:
            {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     _shopMaskView.hidden=NO;
                                     [_shopSearchBar setFrame:CGRectMake(0.0,_shopSearchBar.frame.origin.y,_shopSearchBar.frame.size.width,_shopSearchBar.frame.size.height)];
                                     [_shopSearchBar becomeFirstResponder];
                                 }
                                 completion:^(BOOL finished){
                                     
                                 }];
            }
                break;
            default:
                break;
        }
        
        [_headerShop beginRefreshing];
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
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_goodsTableView)
    {
        return _goodsDataList.count;
    }
    else if (tableView==_shopTableView)
    {
        return _shopDataList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView==_goodsTableView)
    {
        return [_goodsDataList count]>0?1:0;
    }
    else if (tableView==_shopTableView)
    {
        return [_shopDataList count]>0?1:0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_goodsTableView)
    {
        static NSString *GoodsCellIdentifier=@"GoodsCellIdentifier";
        
        GoodsCell *cell = (GoodsCell *)[tableView dequeueReusableCellWithIdentifier:GoodsCellIdentifier];
        if (cell == nil)
        {
            cell = [[GoodsCell alloc] initWithGoodsCellStyle:GoodsCellTypeDefault reuseIdentifier:GoodsCellIdentifier];
        }
        
        Goods *data = [_goodsDataList objectAtIndex:indexPath.row];
        [cell setDataForGoods:data];
        
        if (indexPath.row == (_goodsDataList.count - PAGE_SIZE/2))
        {
            //没有下一页则不显示分页刷新
            if (_footerGoods.hidden == NO)
            {
                [_footerGoods beginRefreshing];
            }
        }

        return cell;
    }
    if (tableView==_shopTableView) {
        static NSString *ShopCellIdentifier=@"ShopCellIdentifier";
        
        ShopCell *cell = (ShopCell *)[tableView dequeueReusableCellWithIdentifier:ShopCellIdentifier];
        if (cell == nil)
        {
            cell = [[ShopCell alloc] initWithGoodsCellStyle:ShopCellTypeDefault reuseIdentifier:ShopCellIdentifier];
        }
        
        Shop *data = [_shopDataList objectAtIndex:indexPath.row];
        [cell setDataForShop:data];
        
        if (indexPath.row == (_shopDataList.count - PAGE_SIZE/2))
        {
            //没有下一页则不显示分页刷新
            if (_footerShop.hidden == NO)
            {
                [_footerShop beginRefreshing];
            }
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_goodsTableView)
    {
        GoodsViewController *viewController=[[GoodsViewController alloc]init];
        Goods *goods = [_goodsDataList objectAtIndex:indexPath.row];
        [viewController setItemId:[goods.goodsID longValue]];
        AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
        [myDelegate.navigationController pushViewController:viewController animated:YES];
    }
    else if (tableView==_shopTableView)
    {
        Shop *shop = [_shopDataList objectAtIndex:indexPath.row];
        NSDictionary *data = [NSDictionary dictionaryWithObject:shop.shopID forKey:KEY_SHOPID];
        [CommonMethods pushShopViewControllerWithData:data];
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar==_shopSearchBar) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [_shopSearchBar setFrame:CGRectMake(SCREEN_WIDTH,
                                                                 _shopSearchBar.frame.origin.y,
                                                                 _shopSearchBar.frame.size.width,
                                                                 _shopSearchBar.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             _shopMaskView.hidden=YES;
                             [_shopSearchBar resignFirstResponder];
                             self.shopSearchKeyword=searchBar.text;
                             [self reloadShopDataList];
                         }];
    }
    
    if (searchBar==_goodsSearchBar) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [_goodsSearchBar setFrame:CGRectMake(SCREEN_WIDTH,
                                                                  _goodsSearchBar.frame.origin.y,
                                                                  _goodsSearchBar.frame.size.width,
                                                                  _goodsSearchBar.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             _goodsMaskView.hidden=YES;
                             [_goodsSearchBar resignFirstResponder];
                             self.goodsSearchKeyword=searchBar.text;
                             [self reloadItemDataList];
                         }];
    }
}

- (void)reloadItemDataList
{
    self.goodsPageNo=0;
    [self loadItemDataList];
}

- (void)loadItemDataList
{
    NSString *title=[self getTitle];
    [self.titleLable setText:title];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
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
                                                  [NSNumber numberWithInt:self.goodsPageNo+1], @"page",
                                                  [NSNumber numberWithInt:self.goodsOrderBy],KEY_ORDERBY,
                                                  @"item", @"classification",
                                                  priceFrom, @"priceFrom",
                                                  priceTo, @"priceTo",
                                                  [_data valueForKey:KEY_KEYWORD], @"keyword",
                                                  self.goodsSearchKeyword, @"filterKey",
                                                  nil];
                       
                       if([_data objectForKey:KEY_CATEGORYID])
                       {
                           [obj setObject:[_data objectForKey:KEY_CATEGORYID] forKey:KEY_CATEGORYID];
                           [obj setObject:@"" forKey:KEY_KEYWORD];
                       }
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.goodsTableView setLoading:YES];
                                      });
                       
                       NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,SEARCH_SUGGEST];
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                          [_headerGoods endRefreshing];
                                          [_footerGoods endRefreshing];
                                          [self.goodsTableView setLoading:NO];
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
                                              NSArray *dataList=[[BusinessManager sharedManager].naviManager parseGoodsListData:data];
                                              if ([dataList count]==0 || dataList.count<PAGE_SIZE) {
                                                  _footerGoods.hidden=YES;
                                              }
                                              
                                              self.goodsPageNo++;
                                              if (self.goodsPageNo==1) {
                                                  _goodsDataList=[NSMutableArray arrayWithArray:dataList];
                                              }else{
                                                  [_goodsDataList addObjectsFromArray:dataList];
                                              }
                                              
                                              NSInteger iCount = [[data objectForKey:@"count"] integerValue];
                                              [_segement changeSegementTitleWithIndex:0 andCount:iCount];
                                              [self.goodsTableView reloadData];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)reloadShopDataList
{
    self.shopPageNo=0;
    [self loadShopDataList];
}

- (void)loadShopDataList
{
    NSString *title= [self getTitle];
    [self.titleLable setText:title];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       ShopFilterViewController *rightController=(ShopFilterViewController *)self.viewDeckController.rightController;
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
                                                  [NSNumber numberWithInt:self.shopPageNo+1], @"page",
                                                  [NSNumber numberWithInt:self.shopOrderBy],KEY_ORDERBY,
                                                  @"shop", @"classification",
                                                  priceFrom, @"priceFrom",
                                                  priceTo, @"priceTo",
                                                  self.shopSearchKeyword, @"keyword",
                                                  nil];
                       
                       if([_data objectForKey:KEY_CATEGORYID])
                       {
                           [obj setObject:[_data objectForKey:KEY_CATEGORYID] forKey:KEY_CATEGORYID];
                           [obj setObject:self.shopSearchKeyword forKey:KEY_KEYWORD];
                       }else{
                           [obj setObject:title forKey:KEY_KEYWORD];
                       }
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.shopTableView setLoading:YES];
                                      });
                       
                       NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILE,SEARCH_SUGGEST] ;
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                          [_headerShop endRefreshing];
                                          [_footerShop endRefreshing];
                                          [self.shopTableView setLoading:NO];
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
                                              NSArray *dataList=[[BusinessManager sharedManager].naviManager parseShopListData:data];

                                              if ([dataList count]==0 || dataList.count<PAGE_SIZE) {
                                                  _footerShop.hidden=YES;
                                              }
                                              
                                              self.shopPageNo++;
                                              if (self.shopPageNo==1) {
                                                  _shopDataList=[NSMutableArray arrayWithArray:dataList];
                                              }else{
                                                  [_shopDataList addObjectsFromArray:dataList];
                                              }
                                              
                                              NSInteger iCount = [[data objectForKey:@"count"] integerValue];
                                              [_segement changeSegementTitleWithIndex:1 andCount:iCount];
                                              [self.shopTableView reloadData];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(NSString *)getTitle
{
    NSMutableString *title=[NSMutableString stringWithFormat:@"%@",[_data valueForKey:KEY_KEYWORD]];
    if (_goodsView.hidden==NO)
    {
        if (self.goodsSearchKeyword!=nil && self.goodsSearchKeyword.length>0)
        {
            [title appendString:@" "];
            [title appendString:self.goodsSearchKeyword];
        }
    }
    else if (_shopView.hidden==NO)
    {
        if (self.shopSearchKeyword!=nil && self.shopSearchKeyword.length>0)
        {
            [title appendString:@" "];
            [title appendString:self.shopSearchKeyword];
        }
    }
    
    return title;
}

@end
