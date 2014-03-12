//
//  GroupViewController.m
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponViewController.h"
#import "GrouponMoreViewController.h"
#import "DetailWebViewController.h"
#import "DetailHtmlWebViewController.h"
#import "MsgViewController.h"
#import "OneLineCell.h"

@interface GrouponViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation GrouponViewController

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
    
    _dataList = [[NSMutableArray alloc]init];
    _headCell=[[GrouponHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponHeadCellIdentifier"];
    _footCell=[[GrouponFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponFootCellIdentifier"];
    _buyCell=[[GrouponBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponBuyCellIdentifier"];
    _buyCell.delegate=self;
    _baseCell=[[GrouponBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponBaseCellIdentifier"];
    _shopCell=[[GrouponShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponShopCellIdentifier"];
    _noticeCell=[[GrouponNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponNoticeCellIdentifier"];
    _propCell=[[GrouponPropCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponPropCellIdentifier"];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    [scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scrollView setContentSize:CGSizeMake(320,934-20)];
    [scrollView setPagingEnabled:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [scrollView setBackgroundColor:COLOR_BG_CLASSONE];
    //[self.view addSubview:scrollView];
    
    UIImageView *detailImageView=[[UIImageView alloc]init];
    [detailImageView setFrame:CGRectMake(0, -20, 320, 934)];
    [detailImageView setImage:[UIImage imageNamed:@"tmp_groupon_detail@2x.jpg"]];
    [scrollView addSubview:detailImageView];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];

    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"团购详情"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doChat:) andButtonType:OCCNavigationButtonTypeMessage andLeft:NO];
    [headView addSubview:rightButton];
    
    UIView *tableHeadView = [[UIView alloc]init];
    [tableHeadView setFrame:CGRectMake(0, 200, SCREEN_WIDTH, 200)];
    _tableHeadView=tableHeadView;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,1*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.view addSubview:myDelegate.cartButton];
    
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
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doChat:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO)
    {
        return;
    }
    
    NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                        [_data objectForKey:@"shopId"],KEY_SHOPID,
                        [_data objectForKey:@"shopName"],@"sender",
                        [NSNumber numberWithInt:AskTypeShop],@"type",
                        [_data objectForKey:@"shopId"],@"objectId",
                        nil];
    MsgViewController *viewController=[[MsgViewController alloc]init];
    [viewController setData:data];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)doToCart:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toCartNotification" object:nil];
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView==_header) {
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (void)grouponBuyItem
{
   [_propCell addItemToCart:nil];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataList objectAtIndex:section]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    if (section==0)
    {
        return [_headCell getCellHeight];
    }
    if (section==1)
    {
        return [_baseCell getCellHeight];
    }
    if (section==2)
    {
        return [_propCell getCellHeight];
    }
    if (section==3)
    {
        return 44.0;
    }
    if (section==4)
    {
        return [_shopCell getCellHeight];
    }
    if (section==5)
    {
        return [_buyCell getCellHeight];
    }
    if (section==6)
    {
        return [_noticeCell getCellHeight];
    }
    if (section==7)
    {
        return [_footCell getCellHeight];
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==[tableView numberOfSections]-1)
    {
        return 55.0;
    }
    
    return 5.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    if (indexPath.section!=3)
    {
        return [[_dataList objectAtIndex:section]objectAtIndex:row];
    }
    
    static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
    
    OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
    if (cell == nil)
    {
        cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
    }
    cell.lineStyle=OneLineCellLineTypeLine1;
    
    if (row==0)
    {
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bgwhite1_nor.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
        [cell setBackgroundView:backgroundView];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_EAEAEA];
        [cell setSelectedBackgroundView:selectedBackgroundView];
    }
    else if(row==[tableView numberOfRowsInSection:section]-1)
    {
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bgwhite3_nor.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
        [cell setBackgroundView:backgroundView];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_EAEAEA];
        [cell setSelectedBackgroundView:selectedBackgroundView];
    }
    else
    {
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bgwhite2_nor.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
        [cell setBackgroundView:backgroundView];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_EAEAEA];
        [cell setSelectedBackgroundView:selectedBackgroundView];
    }
    
    NSDictionary *data = [[_dataList objectAtIndex:section]objectAtIndex:row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.rightStyle = OneLineCellRightCheck;
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    int section=indexPath.section;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (section==3)
    {
        if (row==0)
        {
            DetailHtmlWebViewController *viewController=[[DetailHtmlWebViewController alloc]init];
            [viewController setDetailURL:[_data objectForKey:@"content"]];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
            NSDictionary *data=[[_dataList objectAtIndex:section]objectAtIndex:row];
            viewController.titleLable.text=[data objectForKey:@"name"];
        }
        
        if (row==1)
        {
            GrouponMoreViewController *viewController=[[GrouponMoreViewController alloc]init];
            [viewController setGroupId:self.grouponId];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
        }
        if (row==2)
        {
            GrouponCommentViewController *viewController=[[GrouponCommentViewController alloc]init];
            [viewController setGrouponId:self.grouponId];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)reloadData
{
    [self loadData];
}

-(void)loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [NSNumber numberWithLong:self.grouponId], @"grouponId",
                                                  nil];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadGroupon_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [_header endRefreshing];
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
                                              _data=[NSMutableDictionary dictionaryWithDictionary:data];
                                              [_data setObject:[NSString stringWithFormat:@"%ld",self.grouponId] forKey:@"groupId"];
                                              _dataList = [[NSMutableArray alloc]initWithObjects:
                                                           [[NSMutableArray alloc]initWithObjects:_headCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:_baseCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:_propCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:
                                                            [NSDictionary dictionaryWithObjectsAndKeys:@"更多详情",@"name",@"",@"value",nil],
                                                            [NSDictionary dictionaryWithObjectsAndKeys:@"团购商品",@"name",@"",@"value",nil],
                                                            nil],
                                                           [[NSMutableArray alloc]initWithObjects:_shopCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:_buyCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:_noticeCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:_footCell, nil],
                                                           nil];
                                              
                                              [_headCell setData:_data];
                                              [_footCell setData:_data];
                                              [_baseCell setData:_data];
                                              [_buyCell setData:_data];
                                              [_propCell setData:_data];
                                              [_noticeCell setData:_data];
                                              [_shopCell setData:_data];
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

@end
