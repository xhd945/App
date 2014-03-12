//
//  ShopListViewController.m
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopViewController.h"
#import "ShopCell.h"
#import "AppDelegate.h"
#import "ShopFilterViewController.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "Shop.h"

@interface ShopListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation ShopListViewController

#pragma mark -
#pragma mark initData

#pragma mark -
#pragma mark View Life Cycel
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.keyword=@"";
    self.dataList =[[NSMutableArray alloc]init];
    self.page=0;
    
    ShopFilterViewController *shopFilterViewController=[[ShopFilterViewController alloc]init];
    shopFilterViewController.titleString = [_data objectForKey:KEY_KEYWORD];
    self.shopFilterViewController=shopFilterViewController;
    self.viewDeckController.rightController=self.shopFilterViewController;
    
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
    CGFloat pointX = leftButton.frame.origin.x + leftButton.frame.size.width + 10/2;
    CGFloat labelWidth = rightButton.frame.origin.x - pointX - 10/2;
    [titleLable setFrame:CGRectMake(pointX,0, labelWidth, HEADER_HEIGHT)];
    [self.view addSubview:titleLable];
    _titleLable=titleLable;
    
    //sort===========================================================
    OCCTabbar *tabbarView = [[OCCTabbar alloc] initWithFrame:CGRectMake(10, HEADER_HEIGHT, SCREEN_WIDTH-20, HEADER_HEIGHT)
                                                 andTitleArr:[NSArray arrayWithObjects:@"人气",@"类别",@"等级",@"搜索", nil]];
    tabbarView.delegate = self;
    [self.view addSubview:tabbarView];
    
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,tabbarView.frame.origin.y+tabbarView.frame.size.height+1,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-tabbarView.frame.size.height)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setDataType:DataTypeShop];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = _tableView;
    _header.backgroundColor = [UIColor clearColor];
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = _tableView;
    _footer.backgroundColor = [UIColor clearColor];
    
    UIView *maskView=[[UIView alloc]init];
    [maskView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [maskView setBackgroundColor:COLOR_333333];
    [maskView setAlpha:0.5];
    [maskView setHidden:YES];
    [self.view addSubview:maskView];
    _maskView=maskView;
    
    OCCSearchBar *searchBar = [[OCCSearchBar alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, tabbarView.frame.origin.y, SCREEN_WIDTH, 45)];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    _searchBar=searchBar;
    
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_header beginRefreshing];
    });
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
}

#pragma mark -
#pragma mark Methods
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    UITouch *touch = [[event allTouches]anyObject];
    UIView *touchView=touch.view;
    if (touchView==_maskView) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _searchBar.text=self.keyword;
                             [_searchBar setFrame:CGRectMake(SCREEN_WIDTH,_searchBar.frame.origin.y,_searchBar.frame.size.width,_searchBar.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             _maskView.hidden=YES;
                             [_searchBar resignFirstResponder];
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
#pragma mark OCCTabbarDelegate
- (void)tabbar:(OCCTabbar *)tabbar tapIndex:(NSInteger)index andType:(SortType)sortType
{
    switch (index) {
        case 0:
        {
            self.orderBy=0;
        }
            break;
        case 1:
        {
            self.orderBy=1;
        }
            break;
        case 2:
        {
            if (sortType==SortTypeDown) {
                self.orderBy=3;
            }
            else if (sortType==SortTypeUp) {
                self.orderBy=2;
            }
        }
            break;
        case 3:
        {
            _maskView.hidden=NO;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _searchBar.text=self.keyword;
                                 [_searchBar setFrame:CGRectMake(0.0, _searchBar.frame.origin.y, _searchBar.frame.size.width, _searchBar.frame.size.height)];
                                 [_searchBar becomeFirstResponder];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
            break;
        default:
            break;
    }
    
    [_header beginRefreshing];
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
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
    static NSString *ShopCellIdentifier=@"ShopCellIdentifier";
    
    ShopCell *cell = (ShopCell *)[tableView dequeueReusableCellWithIdentifier:ShopCellIdentifier];
    if (cell == nil)
    {
        cell = [[ShopCell alloc] initWithGoodsCellStyle:ShopCellTypeDefault reuseIdentifier:ShopCellIdentifier];
    }
    
    Shop *data = [_dataList objectAtIndex:indexPath.row];
    [cell setDataForShop:data];
    
    if (indexPath.row == (_dataList.count - PAGE_SIZE/2))
    {
        //没有下一页则不显示分页刷新
        if (_footer.hidden == NO)
        {
            [_footer beginRefreshing];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Shop *shop = [_dataList objectAtIndex:indexPath.row];
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",shop.shopID] forKey:KEY_SHOPID];
    [CommonMethods pushShopViewControllerWithData:data];
}

#pragma mark -
#pragma mark UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.keyword=searchBar.text;
                         [_searchBar setFrame:CGRectMake(SCREEN_WIDTH, _searchBar.frame.origin.y,_searchBar.frame.size.width,_searchBar.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         _maskView.hidden=YES;
                         [_searchBar resignFirstResponder];
                         [self reloadDataList];
                     }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)filterDataList
{
    [self reloadDataList];
}

- (void)reloadDataList
{
    self.page = 0;
    [self loadDataList];
}

- (void)loadDataList
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
                       
                       NSMutableDictionary *obj = [NSMutableDictionary dictionaryWithDictionary:[self.data valueForKey:HTTP_KEY_DATA]];
                       [obj setObject:[[Singleton sharedInstance]TGC] forKey:KEY_TGC];
                       [obj setObject:[NSNumber numberWithInt:[[Singleton sharedInstance]mall]] forKey:KEY_MALL];
                       [obj setObject:[NSNumber numberWithInt:self.orderBy] forKey:KEY_ORDERBY];
                       [obj setObject:[NSNumber numberWithInt:self.page+1] forKey:KEY_PAGE];
                       [obj setObject:self.keyword forKey:KEY_KEYWORD];
                       [obj setObject:priceFrom forKey:KEY_PRICEFROM];
                       [obj setObject:priceTo forKey:KEY_PRICETO];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.tableView setLoading:YES];
                                      });
                       
                       NSString *methodsStr = [self.data valueForKey:KEY_METHOD];
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:methodsStr andData:reqdata andDelegate:nil];
                       
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
                                              NSArray *dataList=[[BusinessManager sharedManager].naviManager parseShopListData:data];
                                              
                                              if ([dataList count]==0 || dataList.count<PAGE_SIZE) {
                                                  _footer.hidden=YES;
                                              }
                                              
                                              self.page++;
                                              if (self.page==1) {
                                                  _dataList=[NSMutableArray arrayWithArray:dataList];
                                              }else{
                                                  [_dataList addObjectsFromArray:dataList];
                                              }
                                              
                                              NSInteger iCount = [[data objectForKey:@"count"] integerValue];
                                              [self.tableView reloadData];
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
    if (self.keyword!=nil && self.keyword.length>0)
    {
        [title appendString:@" "];
        [title appendString:self.keyword];
    }
    
    return title;
}

@end
