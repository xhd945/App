//
//  FavoriteListViewController.m
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyFavoriteListViewController.h"
#import "MyMsgCell.h"
#import "BusinessManager.h"
#import "UserManager.h"
#import "NaviManager.h"
#import "GoodsViewController.h"
#import "Goods.h"
#import "Shop.h"

@interface MyFavoriteListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footerShop;
    MJRefreshHeaderView *_headerShop;
    MJRefreshFooterView *_footerGoods;
    MJRefreshHeaderView *_headerGoods;
}

@end

@implementation MyFavoriteListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    _shopDataList = [[NSMutableArray alloc] init];
    _goodsDataList = [[NSMutableArray alloc] init];
    _selectedItemArray = [[NSMutableArray alloc] initWithCapacity:3];
    _selectedShopArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"我的收藏"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    //tab===========================================================
    UIView *segementView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    segementView.backgroundColor = COLOR_BG_CLASSONE;
    [self.view addSubview:segementView];
    
    OCCSegement *segement = [[OCCSegement alloc] initWithFrame:CGRectMake(10, (HEADER_HEIGHT - 28)/2, SCREEN_WIDTH - 10*2, 28)
                                                          type:OCCSegementTypeDefaultThree
                                                 andTitleArray:[NSArray arrayWithObjects:@"店铺",@"商品",nil]];
    segement.delegate = self;
    [segementView addSubview:segement];
        
    _goodsTable = [[OCCTableView alloc]init];
    [_goodsTable setFrame:CGRectMake(0,2*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - 3*HEADER_HEIGHT)];
    [_goodsTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_goodsTable setDelegate:self];
    [_goodsTable setDataSource:self];
    [_goodsTable setDataType:DataTypeFavoriteGoods];
    [_goodsTable setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    _goodsTable.hidden = YES;
    [self.view addSubview:_goodsTable];
    
    _shopTable = [[OCCTableView alloc]init];
    [_shopTable setFrame:CGRectMake(0,2*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - 3*HEADER_HEIGHT)];
    [_shopTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_shopTable setDelegate:self];
    [_shopTable setDataSource:self];
    [_shopTable setDataType:DataTypeFavoriteShop];
    [_shopTable setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    _shopTable.hidden = NO;
    [self.view addSubview:_shopTable];
    
    _headerShop = [[MJRefreshHeaderView alloc] init];
    _headerShop.delegate = self;
    _headerShop.backgroundColor = [UIColor clearColor];
    _headerShop.scrollView = _shopTable;
    
    _footerShop = [[MJRefreshFooterView alloc] init];
    _footerShop.delegate = self;
    _footerShop.backgroundColor = [UIColor clearColor];
    _footerShop.scrollView = _shopTable;
    
    //==
    _headerGoods = [[MJRefreshHeaderView alloc] init];
    _headerGoods.delegate = self;
    _headerGoods.backgroundColor = [UIColor clearColor];
    _headerGoods.scrollView = _goodsTable;
    
    _footerGoods = [[MJRefreshFooterView alloc] init];
    _footerGoods.delegate = self;
    _footerGoods.backgroundColor = [UIColor clearColor];
    _footerGoods.scrollView = _goodsTable;
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    toolBar.backgroundColor = COLOR_BG_CLASSTHREE;
    [self.view addSubview:toolBar];
    
    _leftBarButton = [CommonMethods toolBarButtonWithTitle:@"删除" WithTarget:self andSelector:@selector(doDelete:) andLeft:YES];
    [(UIButton *)_leftBarButton setEnabled:NO];
    [toolBar addSubview:_leftBarButton];
    
    _rightBarButton = [CommonMethods toolBarButtonWithTitle:@"加入购物车" WithTarget:self andSelector:@selector(addItemToCart:) andLeft:NO];
    _rightBarButton.hidden = YES;
    [(UIButton *)_rightBarButton setEnabled:NO];
    [toolBar addSubview:_rightBarButton];
    
    [_headerShop beginRefreshing];
    [_headerGoods beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_headerShop free];
    [_footerShop free];
    [_headerGoods free];
    [_footerGoods free];
}

#pragma mark -
#pragma mark Btn Methods
- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doFilter:(id)sender
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)addItemToCart:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableArray *itemList = [[NSMutableArray array]init];
                       for (int i = 0; i < [_selectedItemArray count]; i++)
                       {
                           NSInteger selectedId = [[_selectedItemArray objectAtIndex:i] integerValue];
                           for (Goods *goods in _goodsDataList)
                           {
                               if ([goods.goodsFavourID integerValue] == selectedId)
                               {
                                   NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            @"1",@"buyNum",
                                                            goods.goodsType,KEY_TYPE,
                                                            goods.goodsID,KEY_ID,
                                                            nil];
                                   [itemList addObject:dataDic];
                               }
                           }
                       }
                       
                       NSMutableDictionary *obj =[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  itemList,KEY_ITEMLIST,
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:addItemsCart_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
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
                                              [CommonMethods showErrorDialog:@"网络异常,请检查您的网络设置!" inView:nil];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:nil];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showSuccessDialog:@"添加到购物车成功" inView:nil];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"addItemToCartSuccessNotification" object:nil];
                                              
                                              NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:_goodsDataList];
                                              for (int i=0; i<[_selectedItemArray count]; i++)

                                              {
                                                  int favId = [[_selectedItemArray objectAtIndex:i]intValue];
                                                  for (Goods *goods in dataArray)
                                                  {
                                                      if ([goods.goodsFavourID integerValue] == favId)
                                                      {
                                                          [_goodsDataList removeObject:goods];
                                                      }
                                                  }
                                              }
                                              [_selectedItemArray removeAllObjects];
                                              [_goodsTable reloadData];
                                              [self changeUI];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

- (void)doDelete:(id)sender
{
    if (_shopTable.hidden == YES)
    {
        [self deleteItemFromFavorite:sender];
    }
    else
    {
        [self deleteShopFromFavorite:sender];
    }
}

- (void)deleteItemFromFavorite:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableArray *favoriteIdArr = [NSMutableArray arrayWithCapacity:3];
                       for (NSNumber *favId in _selectedItemArray)
                       {
                           [favoriteIdArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:favId,KEY_ID, nil]];
                       }
                       
                       NSDictionary *obj = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                            [[Singleton sharedInstance]TGC], @"TGC",
                                            favoriteIdArr,KEY_FAVOURLIST,
                                            nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:mobileRemoveItemFavour_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
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
                                              [CommonMethods showSuccessDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showTextDialog:@"删除收藏成功" inView:self.view];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteItemFromFavoriteSuccessNotification" object:nil];
                                              
                                              NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:_goodsDataList];
                                              for (int i=0; i<[_selectedItemArray count]; i++)
                                              {
                                                  int favId = [[_selectedItemArray objectAtIndex:i]intValue];
                                                  for (Goods *goods in dataArray)
                                                  {
                                                      if ([goods.goodsFavourID intValue]==favId)
                                                      {
                                                          [_goodsDataList removeObject:goods];
                                                      }
                                                  }
                                              }
                                              [_selectedItemArray removeAllObjects];
                                              [_goodsTable reloadData];
                                              [self changeUI];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)deleteShopFromFavorite:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableArray *favoriteIdArr = [NSMutableArray arrayWithCapacity:3];
                       for (NSNumber *favId in _selectedShopArray)
                       {
                           [favoriteIdArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:favId,KEY_ID, nil]];
                       }
                       
                       NSDictionary *obj = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                            [[Singleton sharedInstance]TGC], @"TGC",
                                            favoriteIdArr,KEY_FAVOURLIST,
                                            nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:mobileRemoveStoreFavour_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
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
                                              [CommonMethods showSuccessDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showTextDialog:@"删除收藏成功" inView:self.view];
                                              
                                              NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:_shopDataList];
                                              for (int i=0; i<[_selectedShopArray count]; i++)
                                              {
                                                  int favId = [[_selectedShopArray objectAtIndex:i]intValue];
                                                  for (Shop *shop in dataArray)
                                                  {
                                                      if ([shop.shopFavourID intValue]==favId)
                                                      {
                                                          [_shopDataList removeObject:shop];
                                                      }
                                                  }
                                              }
                                              [_selectedShopArray removeAllObjects];
                                              [_shopTable reloadData];
                                              [self changeUI];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(void)reloadDataListGoods
{
    self.goodsPage=0;
    [self loadDataListGoods];
}

-(void)loadDataListGoods
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSDictionary *obj = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                            [[Singleton sharedInstance]TGC], @"TGC",
                                            [NSNumber numberWithInt:self.goodsPage+1],KEY_PAGE,
                                            nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.goodsTable setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:itemFavourList_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                          [_headerGoods endRefreshing];
                                          [_footerGoods endRefreshing];
                                          [self.goodsTable setLoading:NO];
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
                                              
                                              self.goodsPage++;
                                              if (self.goodsPage==1) {
                                                  _goodsDataList=[NSMutableArray arrayWithArray:dataList];
                                                  [_selectedItemArray removeAllObjects];
                                              }else{
                                                  [_goodsDataList addObjectsFromArray:dataList];
                                              }
                                              
                                              [self.goodsTable reloadData];
                                              [self changeUI];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(void)reloadDataListShop
{
    self.shopPage=0;
    [self loadDataListShop];
}

-(void)loadDataListShop
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSDictionary *obj = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                            [[Singleton sharedInstance]TGC], @"TGC",
                                            [NSNumber numberWithInt:self.shopPage+1],KEY_PAGE,
                                            nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.shopTable setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:storeListMobile_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                          [_headerShop endRefreshing];
                                          [_footerShop endRefreshing];
                                          [self.shopTable setLoading:NO];
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
                                              
                                              self.shopPage++;
                                              if (self.shopPage==1) {
                                                  _shopDataList=[NSMutableArray arrayWithArray:dataList];
                                                  [_selectedShopArray removeAllObjects];
                                              }else{
                                                  [_shopDataList addObjectsFromArray:dataList];
                                              }
                                              
                                              [self.shopTable reloadData];
                                              [self changeUI];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}


#pragma mark -
#pragma mark OCCSegementDelegate
- (void)selectedSegementIndex:(NSInteger)index
{
    if (index == 0)
    {
        _shopTable.hidden = NO;
        _goodsTable.hidden = YES;
        _rightBarButton.hidden = YES;
    }
    else
    {
        _shopTable.hidden = YES;
        _goodsTable.hidden = NO;
        _rightBarButton.hidden = NO;
    }
    [self changeUI];
}

#pragma mark -
#pragma mark MJRefreshDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    double delayInSeconds = REFRESH_TIME_INTERVAL;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (refreshView==_headerGoods)
        {
            [self reloadDataListGoods];
        }
        else if (refreshView==_footerGoods)
        {
            [self loadDataListGoods];
        }
        
        else if (refreshView==_headerShop)
        {
            [self reloadDataListShop];
        }
        else if (refreshView==_footerShop)
        {
            [self loadDataListShop];
        }
    });
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
    if (tableView == _shopTable)
    {
        return [_shopDataList count];
    }
    else
    {
        return [_goodsDataList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _shopTable)
    {
        return [_shopDataList count]>0?1:0;
    }
    else
    {
        return [_goodsDataList count]>0?1:0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _goodsTable)
    {
        static NSString *goodsCellIdentifierSelected=@"goodsCellIdentifierSelected";
        
        GoodsCell *cell = (GoodsCell *)[tableView dequeueReusableCellWithIdentifier:goodsCellIdentifierSelected];
        if (cell == nil)
        {
            cell = [[GoodsCell alloc] initWithGoodsCellStyle:GoodsCellTypeSelected reuseIdentifier:goodsCellIdentifierSelected];
            cell.delegate = self;
        }
        
        cell.accessoryType = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setDataForGoods:[_goodsDataList objectAtIndex:indexPath.row]];
        
        if (indexPath.row == (_goodsDataList.count - PAGE_SIZE/2))
        {
            //没有下一页则不显示分页刷新
            if (_footerShop.hidden == NO)
            {
                [_footerShop beginRefreshing];
            }
        }
        return cell;
    }
    else
    {
        static NSString *shopCellIdentifierSelected=@"shopCellIdentifierSelected";
        
        ShopCell *cell = (ShopCell *)[tableView dequeueReusableCellWithIdentifier:shopCellIdentifierSelected];
        if (cell == nil)
        {
            cell = [[ShopCell alloc] initWithGoodsCellStyle:ShopCellTypeSelected reuseIdentifier:shopCellIdentifierSelected];
            cell.delegate = self;
        }
        
        cell.accessoryType = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setDataForShop:[_shopDataList objectAtIndex:indexPath.row]];
        
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _shopTable)
    {
        Shop *shop = [_shopDataList objectAtIndex:indexPath.row];
        NSDictionary *data = [NSDictionary dictionaryWithObject:shop.shopID forKey:KEY_SHOPID];
        [CommonMethods pushShopViewControllerWithData:data];
    }
    else
    {
        GoodsViewController *viewController = [[GoodsViewController alloc]init];
        Goods *goods = [_goodsDataList objectAtIndex:indexPath.row];
        [viewController setItemId:[goods.goodsID longValue]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark -
#pragma mark GoodsCellDelegate
- (void)goodsCellIsSelected:(BOOL)isSelected withId:(NSInteger)selectedId
{
    if (isSelected)
    {
        [_selectedItemArray addObject:[NSNumber numberWithInteger:selectedId]];
    }
    else
    {
        [_selectedItemArray removeObject:[NSNumber numberWithInteger:selectedId]];
    }
    [self changeUI];
}

- (void)changeUI
{
    if (_shopTable.hidden==YES)
    {
        if ([_selectedItemArray count] > 0)
        {
            [(UIButton *)_leftBarButton setEnabled:YES];
            [(UIButton *)_rightBarButton setEnabled:YES];
        }
        else
        {
            [(UIButton *)_leftBarButton setEnabled:NO];
            [(UIButton *)_rightBarButton setEnabled:NO];
        }
    }
    else
    {
        if ([_selectedShopArray count] > 0)
        {
            [(UIButton *)_leftBarButton setEnabled:YES];
            [(UIButton *)_rightBarButton setEnabled:YES];
        }
        else
        {
            [(UIButton *)_leftBarButton setEnabled:NO];
            [(UIButton *)_rightBarButton setEnabled:NO];
        }
    }
}

#pragma mark -
#pragma mark ShopCellDelegate
- (void)shopCellIsSelected:(BOOL)isSelected withId:(NSInteger)selectedId
{
    if (isSelected)
    {
        [_selectedShopArray addObject:[NSNumber numberWithInteger:selectedId]];
    }
    else
    {
        [_selectedShopArray removeObject:[NSNumber numberWithInteger:selectedId]];
    }
    [self changeUI];
}

@end
