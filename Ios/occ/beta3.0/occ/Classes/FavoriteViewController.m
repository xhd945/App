//
//  FavoriteViewController.m
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "FavoriteViewController.h"
#import "NaviManager.h"
#import "BusinessManager.h"
#import "GoodsViewController.h"
#import "AppDelegate.h"
#import "Goods.h"

@interface FavoriteViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation FavoriteViewController
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
    _dataList = [[NSMutableArray alloc] init];
    _selectedItemArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessNotification:)
                                                 name:@"loginSuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutSuccessNotification:)
                                                 name:@"logoutSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addItemToFavoriteSuccessNotification:)
                                                 name:@"addItemToFavoriteSuccessNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteItemFromFavoriteSuccessNotification:)
                                                 name:@"deleteItemFromFavoriteSuccessNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMallNotification:)
                                                 name:@"changeMallNotification"
                                               object:nil];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    OCCTableView *tableView = [[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-TABBAR_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setDataType:DataTypeFavoriteGoods];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.backgroundColor=[UIColor clearColor];
    _footer.scrollView = self.tableView;
    
    UIImageView *footView = [[UIImageView alloc]init];
    [footView setFrame:CGRectMake(0, SCREEN_HEIGHT-TABBAR_HEIGHT-50, SCREEN_WIDTH, 50)];
    [footView setBackgroundColor:COLOR_BG_CLASSFOUR];
    [footView setUserInteractionEnabled:YES];
    [self.view addSubview:footView];
    
    _cartButton= [CommonMethods buttonWithTitle:@"加入购物车" withTarget:self andSelector:@selector(addItemToCart:) andFrame:CGRectMake(220, 3,90, 44) andButtonType:OCCButtonTypeLightGray];
    [footView addSubview:_cartButton];
    
    _deleteButton= [CommonMethods buttonWithTitle:@"删除" withTarget:self andSelector:@selector(deleteItemFromFavorite:) andFrame:CGRectMake(10, 3,90, 44) andButtonType:OCCButtonTypeLightGray];
    [footView addSubview:_deleteButton];
    
    //[headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [footView setFrame:CGRectMake(0, SCREEN_HEIGHT-TABBAR_HEIGHT-FOOTER_HEIGHT, SCREEN_WIDTH, FOOTER_HEIGHT)];
    [tableView setFrame:CGRectMake(0,FOOTER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-TABBAR_HEIGHT-FOOTER_HEIGHT)];

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) loginSuccessNotification:(NSNotification*)notification
{
    [self reloadDataList];
}

- (void) logoutSuccessNotification:(NSNotification*)notification
{
    _dataList = [[NSMutableArray alloc]init];
    _selectedItemArray = [[NSMutableArray alloc]init];
    [self.tableView reloadData];
}

- (void)addItemToFavoriteSuccessNotification:(NSNotification *)noti
{
    [self reloadDataList];
}

- (void)deleteItemFromFavoriteSuccessNotification:(NSNotification *)noti
{
    [self reloadDataList];
}

- (void) changeMallNotification:(NSNotification*)notification
{
    [_header beginRefreshing];
}

#pragma mark -
#pragma mark Methods
- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
                                              [CommonMethods showAutoDismissView:@"删除收藏成功" inView:self.view];
                                              
                                              NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:_dataList];
                                              for (int i=0; i<[_selectedItemArray count]; i++)
                                              {
                                                  int favId = [[_selectedItemArray objectAtIndex:i]intValue];
                                                  for (Goods *goods in dataArray)
                                                  {
                                                      if ([goods.goodsFavourID intValue]==favId)
                                                      {
                                                          [_dataList removeObject:goods];
                                                      }
                                                  }
                                              }
                                              [_selectedItemArray removeAllObjects];
                                              [_tableView reloadData];
                                              [self reloadButton];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)addItemToCart:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableArray *itemList = [[NSMutableArray array]init];
                       for (int i = 0; i < [_selectedItemArray count]; i++)
                       {
                           NSInteger selectedId = [[_selectedItemArray objectAtIndex:i] integerValue];
                           for (Goods *goods in _dataList)
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
                                              
                                              NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:_dataList];
                                              for (int i = 0; i < [_selectedItemArray count]; i++)
                                              {
                                                  int favId = [[_selectedItemArray objectAtIndex:i]intValue];
                                                  for (Goods *goods in dataArray)
                                                  {
                                                      if ([goods.goodsFavourID integerValue] == favId)
                                                      {
                                                          [_dataList removeObject:goods];
                                                      }
                                                  }
                                              }
                                              [_selectedItemArray removeAllObjects];
                                              [_tableView reloadData];
                                              [self reloadButton];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

- (void)reloadButton
{
    if ([_selectedItemArray count]>0)
    {
        UIImage *redImage=[UIImage imageNamed:@"btn_bg_red"];
        redImage = [redImage stretchableImageWithLeftCapWidth:redImage.size.width/2 topCapHeight:redImage.size.height/2];
        
        [(UIButton*)_deleteButton setBackgroundImage:redImage forState:UIControlStateNormal];
        [(UIButton*)_deleteButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        [(UIButton*)_deleteButton setUserInteractionEnabled:YES];
        
        UIImage *orangeImage=[UIImage imageNamed:@"btn_bg_yellow"];
        orangeImage = [orangeImage stretchableImageWithLeftCapWidth:orangeImage.size.width/2 topCapHeight:orangeImage.size.height/2];
        
        [(UIButton*)_cartButton setBackgroundImage:orangeImage forState:UIControlStateNormal];
        [(UIButton*)_cartButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        [(UIButton*)_cartButton setUserInteractionEnabled:YES];
    }
    else
    {
        UIImage *grayImage=[UIImage imageNamed:@"btn_bg_light_gray"];
        grayImage = [grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
        
        [(UIButton*)_deleteButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [(UIButton*)_deleteButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [(UIButton*)_deleteButton setUserInteractionEnabled:NO];
        
        [(UIButton*)_cartButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [(UIButton*)_cartButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [(UIButton*)_cartButton setUserInteractionEnabled:NO];
    }
}

#pragma mark -
#pragma mark MJRefreshDelegate
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
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int total=[_dataList count];
    [self.segement changeSegementTitleWithIndex:1 andCount:total];
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int total=[_dataList count];
    return total;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [_dataList count]>0?55:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodsCellIdentifier=@"goodsCellIdentifier";
    GoodsCell *cell = (GoodsCell *)[tableView dequeueReusableCellWithIdentifier:goodsCellIdentifier];
    if (cell == nil)
    {
        cell = [[GoodsCell alloc] initWithGoodsCellStyle:GoodsCellTypeSelected reuseIdentifier:goodsCellIdentifier];
        cell.delegate = self;
    }
    
    Goods *data = [_dataList objectAtIndex:indexPath.row];
    [cell setDataForGoods:data];
    
    if (indexPath.row == (_dataList.count - PAGE_SIZE/2))
    {
        //没有下一页则不显示分页刷新
        if (_footer.hidden == NO)
        {
            [_footer beginRefreshing];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsViewController *viewController = [[GoodsViewController alloc]init];
    Goods *goods = [_dataList objectAtIndex:indexPath.row];
    [viewController setItemId:[goods.goodsID longValue]];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark GoodsCellDelegate
- (void)goodsCellIsSelected:(BOOL)isSelected withId:(NSInteger)selectedId;
{
    if (isSelected)
    {
        [_selectedItemArray addObject:[NSNumber numberWithInteger:selectedId]];
    }
    else
    {
        [_selectedItemArray removeObject:[NSNumber numberWithInteger:selectedId]];
    }
    //修改UI
    [self reloadButton];
}

-(void)reloadDataList
{
    self.page = 0;
    [self loadDataList];
    [self reloadButton];
}

-(void)loadDataList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSDictionary *obj = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                            [[Singleton sharedInstance]TGC], @"TGC",
                                            [NSNumber numberWithInt:self.page+1],KEY_PAGE,
                                            nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.tableView setLoading:YES];
                                      });

                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:itemFavourList_URL andData:reqdata andDelegate:nil];
                       
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
                                              NSArray *dataList=[[BusinessManager sharedManager].naviManager parseGoodsListData:data];
                                              
                                              if ([dataList count]==0 || dataList.count<PAGE_SIZE) {
                                                  _footer.hidden=YES;
                                              }
                                              
                                              self.page++;
                                              if (self.page==1) {
                                                  _dataList=[NSMutableArray arrayWithArray:dataList];
                                                  [_selectedItemArray removeAllObjects];
                                              }else{
                                                  [_dataList addObjectsFromArray:dataList];
                                              }
                                              
                                              [self.tableView reloadData];
                                              [self reloadButton];
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
