//
//  CartViewController.m
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "CartViewController.h"
#import "CartItemCell.h"
#import "CartHeadCell.h"
#import "CartFootCell.h"
#import "PayViewController.h"
#import "AppDelegate.h"
#import "GoodsViewController.h"
#import "GrouponViewController.h"

@interface CartViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation CartViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessNotification:)
                                                 name:@"loginSuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutSuccessNotification:)
                                                 name:@"logoutSuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addItemToCartSuccessNotification:)
                                                 name:@"addItemToCartSuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paySuccessNotification:)
                                                 name:@"paySuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addGoodsToCartCallBack:)
                                                 name:OCC_NOTIFI_USER_ADDGOODSTOCART_RETURN
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMallNotification:)
                                                 name:@"changeMallNotification"
                                               object:nil];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    OCCTableView *tableView=[[OCCTableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-49-44) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setDataType:DataTypeCart];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    UIView *headView = [[UIView alloc]init];
    headView.clipsToBounds=YES;
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_BG_CLASSONE];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"购物车"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIImageView *footView = [[UIImageView alloc]init];
    [footView setFrame:CGRectMake(0, SCREEN_HEIGHT-HEADER_HEIGHT-TABBAR_HEIGHT-50, SCREEN_WIDTH, 50)];
    [footView setBackgroundColor:COLOR_BG_CLASSFOUR];
    [footView setUserInteractionEnabled:YES];
    [self.view addSubview:footView];
    
    UILabel *totalLable = [[UILabel alloc]init];
    [totalLable setTextColor:COLOR_FBB714];
    [totalLable setFont:FONT_18];
    [totalLable setBackgroundColor:[UIColor clearColor]];
    [totalLable setText:[NSString stringWithFormat:@"合计:0元"]];
    [totalLable setFrame:CGRectMake(85,0, SCREEN_WIDTH, footView.frame.size.height)];
    [totalLable setTextAlignment:NSTextAlignmentLeft];
    [footView addSubview:totalLable];
    _totalLable=totalLable;
    
    _allButton= [CommonMethods buttonWithTitle:@"全选" withTarget:self andSelector:@selector(doSelectAll) andFrame:CGRectMake(10, 3,65, 44) andButtonType:OCCButtonTypeLightGray];
    [footView addSubview:_allButton];
    
    _payButton= [CommonMethods buttonWithTitle:@"结算" withTarget:self andSelector:@selector(gotoCount) andFrame:CGRectMake(230, 3,80, 44) andButtonType:OCCButtonTypeYellow];
    [footView addSubview:_payButton];
    
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [footView setFrame:CGRectMake(0, SCREEN_HEIGHT-TABBAR_HEIGHT-FOOTER_HEIGHT, SCREEN_WIDTH, FOOTER_HEIGHT)];
    [tableView setFrame:CGRectMake(0,FOOTER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-TABBAR_HEIGHT-FOOTER_HEIGHT)];
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
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

- (void) paySuccessNotification:(NSNotification*)notification
{
    [_header beginRefreshing];
}

- (void) loginSuccessNotification:(NSNotification*)notification
{
    [_header beginRefreshing];
}

- (void) logoutSuccessNotification:(NSNotification*)notification
{
    [Singleton sharedInstance].cartData=[[NSMutableDictionary alloc]init];
    [self relodaUIView];
}

- (void) addItemToCartSuccessNotification:(NSNotification*)notification
{
    [_header beginRefreshing];
}

- (void) changeMallNotification:(NSNotification*)notification
{
    [_header beginRefreshing];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doSelectAll
{
    BOOL check=![self checkIsAll];
    NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
    NSMutableArray *shopList=[cartData objectForKey:@"shopList"];
    for (NSMutableDictionary *shop in shopList)
    {
        [shop setObject:[NSNumber numberWithBool:YES] forKey:@"check"];
        NSMutableArray *itemList=[shop objectForKey:@"itemList"];
        for (NSMutableDictionary *item in itemList)
        {
            [item setObject:[NSNumber numberWithBool:check] forKey:@"check"];
        }
    }
    
    [self relodaUIView];
}

- (void) addGoodsToCartCallBack:(NSNotification*)notification
{
    [self loadDataList];
}

- (void)gotoCount
{
    PayViewController *viewController=[[PayViewController alloc]init];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(loadDataList) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
    return [[cartData objectForKey:@"shopList"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
    NSDictionary *shop=[[cartData objectForKey:@"shopList"]objectAtIndex:section];
    int total=[[shop objectForKey:@"itemList"]count];
    return (total+2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
    NSDictionary *shop=[[cartData objectForKey:@"shopList"]objectAtIndex:section];
    int total=[[shop objectForKey:@"itemList"]count];
    if (row==0)
    {
        return 44.0;
    }
    else if (row==(total+2-1))
    {
        return 44.0+5;
    }
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSMutableDictionary *item=[[shop objectForKey:@"itemList"]objectAtIndex:row-1];
    NSMutableArray *itemBargainList=[item objectForKey:@"itemBargainList"];
    for (int i=0; i<[itemBargainList count]; i++)
    {
        NSDictionary *item=[itemBargainList objectAtIndex:i];
        if ([[item objectForKey:@"name"] isKindOfClass:[NSString class]])
        {
            [arr addObject:[item objectForKey:@"name"]];
        }
    }
    
    NSString *text=[arr componentsJoinedByString:@"\n"];
    float height=[CommonMethods heightForString:text andFont:FONT_12 andWidth:kBargainLabelWidth-30];
    return 100.0+height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0.01;
    }
    
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==[tableView numberOfSections]-1)
    {
        return 55.0+80.0;
    }
    
    return 5.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
    NSMutableArray *shopList=[cartData objectForKey:@"shopList"];
    NSMutableDictionary *shop=[shopList objectAtIndex:section];
    NSMutableArray *itemList=[shop objectForKey:@"itemList"];
    int total=[itemList count];
    
    if (row==0)
    {
        static NSString *CartHeadCellIdentifier=@"CartHeadCellIdentifier";
        
        CartHeadCell *cell = (CartHeadCell *)[tableView dequeueReusableCellWithIdentifier:CartHeadCellIdentifier];
        if (cell == nil)
        {
            cell = [[CartHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CartHeadCellIdentifier];
        }

        [cell setData:shop];
        cell.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    else if (row==(total+2-1))
    {
        static NSString *CartFootCellIdentifier=@"CartFootCellIdentifier";
        
        CartFootCell *cell = (CartFootCell *)[tableView dequeueReusableCellWithIdentifier:CartFootCellIdentifier];
        if (cell == nil)
        {
            cell = [[CartFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CartFootCellIdentifier];
        }
        
        [cell setData:shop];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    else
    {
        static NSString *CartItemCellIdentifier=@"CartItemCellIdentifier";
        
        CartItemCell *cell = (CartItemCell *)[tableView dequeueReusableCellWithIdentifier:CartItemCellIdentifier];
        if (cell == nil)
        {
            cell = [[CartItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CartItemCellIdentifier];
        }
        
        NSMutableDictionary *item=[[shop objectForKey:@"itemList"]objectAtIndex:row-1];
        [cell setData:item];
        [cell setShopId:[[shop objectForKey:@"id"]intValue]];
        [cell setCartId:[[cartData objectForKey:@"cartId"]intValue]];
        cell.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[CartItemCell class]])
    {
        NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
        NSMutableArray *shopList=[cartData objectForKey:@"shopList"];
        NSMutableDictionary *shop=[shopList objectAtIndex:section];
        if ([[shop objectForKey:@"edit"]intValue]==1)
        {
            return;
        }
        
        NSMutableArray *itemList=[shop objectForKey:@"itemList"];
        NSMutableDictionary *item=[itemList objectAtIndex:row-1];
        int type=[[item objectForKey:@"type"]intValue];
        if (type==0)
        {
            GoodsViewController *viewController=[[GoodsViewController alloc]init];
            [viewController setItemId:[[item objectForKey:@"id"]longValue]];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
        }
        else if(type==1)
        {
            GrouponViewController *viewController=[[GrouponViewController alloc]init];
            [viewController setGrouponId:[[item objectForKey:@"id"]longValue]];
            AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark Table Data Source Methods
- (void)cartCellDidChange
{
    [self relodaUIView];
}

- (void)cartCellPlusMInus:(NSMutableDictionary*)data
{
    [self relodaUIView];
}

- (void)reloadDataList
{
    [self loadDataList];
}

- (void)loadDataList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self.tableView setLoading:YES];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadCart_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                          [_header endRefreshing];
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
                                              [CommonMethods showErrorDialog:@"网络故障" inView:self.view];
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
                           NSDictionary *data=[root objectForKey:@"data"];
                           [Singleton sharedInstance].cartData = [[NSMutableDictionary alloc]initWithDictionary:data];
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [self relodaUIView];
                                              [self doSelectAll];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [Singleton sharedInstance].cartData=[[NSMutableDictionary alloc]init];
                                              [self relodaUIView];
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)relodaUIView
{
    int totalNum=0;
    int totalBuyNum=0;
    double totalBuyPrice=0;
    NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
    NSMutableArray *shopList=[cartData objectForKey:@"shopList"];
    for (NSMutableDictionary *shop in shopList) {
        int num=0;
        double price=0;
        NSMutableArray *itemList=[shop objectForKey:@"itemList"];
        
        for (int i=0;i<[itemList count];i++) {
            NSMutableDictionary *item=[itemList objectAtIndex:i];
            if ([[item objectForKey:@"check"]boolValue]==NO) {
                [shop setObject:[NSNumber numberWithBool:NO] forKey:@"check"];
                break;
            }
            if (i==[itemList count]-1) {
                [shop setObject:[NSNumber numberWithBool:YES] forKey:@"check"];
            }
        }
    
        if ([[shop objectForKey:@"edit"]boolValue]) {
            for (NSMutableDictionary *item in itemList) {
                [item setObject:[NSNumber numberWithBool:YES] forKey:@"edit"];
            }
        }else{
            for (NSMutableDictionary *item in itemList) {
                [item setObject:[NSNumber numberWithBool:NO] forKey:@"edit"];
            }
        }
        
        for (NSMutableDictionary *item in itemList) {
            totalNum++;
            if ([[item objectForKey:@"check"]boolValue]) {
                int buyNum=[[item objectForKey:@"buyNum"]intValue];
                double plPrice=[[item objectForKey:@"plPrice"]doubleValue];
                price+=(buyNum*plPrice);
                num+=buyNum;
            }
        }
        
        totalBuyNum+=num;
        totalBuyPrice+=price;
        [shop setObject:[NSNumber numberWithInt:num] forKey:@"num"];
        [shop setObject:[NSNumber numberWithFloat:price] forKey:@"price"];
    }
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.tabbarItemFour setUnReadCount:totalNum];
    [myDelegate.cartButton setCount:totalNum];
    
    [_totalLable setText:[NSString stringWithFormat:@"合计:%@元",[NSNumber numberWithFloat:totalBuyPrice]]];
    [(UIButton *)_payButton setTitle:[NSString stringWithFormat:@"结算(%d)",totalBuyNum] forState:UIControlStateNormal];
    
    [_tableView reloadData];
    [self.segement changeSegementTitleWithIndex:0 andCount:totalNum];
    
    if (totalBuyNum>0)
    {
        [_payButton setUserInteractionEnabled:YES];
        UIImage *orangeImage=[UIImage imageNamed:@"btn_bg_yellow"];
        orangeImage=[orangeImage stretchableImageWithLeftCapWidth:orangeImage.size.width/2 topCapHeight:orangeImage.size.height/2];
        [(UIButton *)_payButton setBackgroundImage:orangeImage forState:UIControlStateNormal];
        [(UIButton *)_payButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        [_payButton setUserInteractionEnabled:YES];
        [_totalLable setTextColor:COLOR_FBB714];
    }
    else
    {
        [_payButton setUserInteractionEnabled:NO];
        UIImage *grayImage=[UIImage imageNamed:@"btn_bg_light_gray"];
        grayImage=[grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
        [(UIButton *)_payButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [(UIButton *)_payButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [_payButton setUserInteractionEnabled:NO];
        [_totalLable setTextColor:COLOR_FBB714];
    }
}

- (BOOL)checkIsAll
{
    NSMutableDictionary *cartData=[[Singleton sharedInstance]cartData];
    NSMutableArray *shopList=[cartData objectForKey:@"shopList"];
    for (NSMutableDictionary *shop in shopList) {
        [shop setObject:[NSNumber numberWithBool:YES] forKey:@"check"];
        NSMutableArray *itemList=[shop objectForKey:@"itemList"];
        for (NSMutableDictionary *item in itemList) {
            if (![[item objectForKey:@"check"]boolValue]) {
                return NO;
            }
        }
    }
    
    return YES;
}

@end
