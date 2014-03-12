//
//  GoodsViewController.m
//  occ
//
//  Created by RS on 13-9-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsViewController.h"
#import "DetailWebViewController.h"
#import "GoodsCommentViewController.h"
#import "GrouponViewController.h"
#import "ShopViewController.h"
#import "CartViewController.h"
#import "PayViewController.h"
#import "MsgViewController.h"
#import "OneLineCell.h"

@interface GoodsViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation GoodsViewController

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
    _headCell=[[GoodsHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsHeadCellIdentifier"];
    _footCell=[[GoodsFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsFootCellIdentifier"];
    _footCell.delegate=self;
    _barginCell=[[GoodsBarginCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsBarginCellIdentifier"];
    _propCell=[[GoodsPropCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsPropCellIdentifier"];
    _propCell.delegate=self;
    
    _dataList = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2*HEADER_HEIGHT)];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:@"商品详情"];
    [titleLable setFrame:CGRectMake(70,0, SCREEN_WIDTH-140, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    _titleLable=titleLable;
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    //UIView *rightButton = [CommonMethods toolBarButtonWithTarget:self andSelector:@selector(doShare:) andButtonType:OCCToolBarButtonTypeShare andLeft:NO];
    //[headView addSubview:rightButton];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
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

- (void)doShare:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO) {
        return;
    }
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
#pragma mark GoodsPropCellDelegate Methods
- (void)updownChange;
{
    [self.tableView reloadData];
}

- (void)itemChange:(long)itemId
{
    self.itemId=itemId;
    [self reloadData];
}

#pragma mark -
#pragma mark GoodsFootCellDelegate Methods
- (void)goodsAddToCart
{
    [_propCell addItemToCart:nil];
}

- (void)goodsAddToFavorite
{
    [_propCell addItemToFavorite:nil];
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
    int section=indexPath.section;
    if (section==0)
    {
        return 270.0;
    }
    if (section==1)
    {
        return [_barginCell getCellHeight];
    }
    if (section==2)
    {
        return [_propCell getCellHeight];
    }
    if (section==3)
    {
        if ([_data objectForKey:@"grouponId"]==nil)
        {
            return 0.0;
        }
        if ([[_data objectForKey:@"grouponId"]isKindOfClass:[NSString class]])
        {
            return 0.0;
        }
        return 44.0;
    }
    if (section==4)
    {
        return 44.0;
    }
    if (section==5)
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
    if (indexPath.section==0)
    {
        return _headCell;
    }
    
    if (indexPath.section==1)
    {
        return _barginCell;
    }
    
    if (indexPath.section==2)
    {
        return _propCell;
    }
    
    if (indexPath.section==5)
    {
        return _footCell;
    }
    
    static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
    
    OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
    if (cell == nil)
    {
        cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
    }
    cell.lineStyle=OneLineCellLineTypeLine1;
    
    if ([tableView numberOfRowsInSection:section]==1) {
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bgwhite_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
        [cell setBackgroundView:backgroundView];
    }
    else if (row==0) {
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bgwhite1_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
        [cell setBackgroundView:backgroundView];
    }else if(row==[tableView numberOfRowsInSection:section]-1){
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bgwhite3_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
        [cell setBackgroundView:backgroundView];
        cell.lineStyle=OneLineCellLineTypeNone;
    }else {
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bgwhite2_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
        [cell setBackgroundView:backgroundView];
    }
    
    UIView *selectedBackgroundView=[[UIView alloc]init];
    [selectedBackgroundView setBackgroundColor:COLOR_EAEAEA];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    
    NSDictionary *data = [[_dataList objectAtIndex:section]objectAtIndex:row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.rightStyle = OneLineCellRightCheck;
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row=indexPath.row;
    int section=indexPath.section;
    
    if (section==3)
    {
        if (row==0)
        {
            GrouponViewController *viewController=[[GrouponViewController alloc]init];
            [viewController setGrouponId:[[_data objectForKey:@"grouponId"]longValue]];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
        }
    }
    
    if (section==4)
    {
        if (row==0)
        {
            DetailWebViewController *viewController=[[DetailWebViewController alloc]init];
            [viewController setDetailURL:[_data objectForKey:@"detailUrl"]];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
        }
        else if (row==1)
        {
            NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                                [NSNumber numberWithLong:self.itemId],KEY_ITEMID,
                                nil];
            GoodsCommentViewController *viewController=[[GoodsCommentViewController alloc]init];
            [viewController setData:data];
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
                                                  [NSNumber numberWithLong:self.itemId], KEY_ITEMID,
                                                  nil];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadItem_URL andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSMutableDictionary *data=[root objectForKey:@"data"];
                                              _data=data;
                                              [_data setObject:[NSNumber numberWithLong:self.itemId] forKey:@"itemId"];
                                              [_headCell setData:data];
                                              [_footCell setData:data];
                                              [_barginCell setData:data];
                                              [_propCell setData:data];
                                              
                                              //[_titleLable setText:[data objectForKey:@"name"]];

                                              _dataList = [[NSMutableArray alloc]initWithObjects:
                                                           [[NSMutableArray alloc]initWithObjects:_headCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:_barginCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:_propCell, nil],
                                                           [[NSMutableArray alloc]initWithObjects:
                                                            [NSDictionary dictionaryWithObjectsAndKeys:@"查看所属团购",@"name",@"",@"value",nil],
                                                            nil],
                                                           [[NSMutableArray alloc]initWithObjects:
                                                            [NSDictionary dictionaryWithObjectsAndKeys:@"查看电脑完整版本",@"name",@"",@"value",nil],
                                                            nil],
                                                           [[NSMutableArray alloc]initWithObjects:_footCell, nil],
                                                           nil];

                                              [self.tableView reloadData];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

@end

