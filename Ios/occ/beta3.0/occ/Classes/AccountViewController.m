//
//  AccountViewController.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "AccountViewController.h"
#import "MySettingViewController.h"
#import "AccountCell.h"
#import "MyGrouponListViewController.h"
#import "MyCouponListViewController.h"
#import "MyOrderListViewController.h"
#import "MyOOrderListViewController.h"
#import "MyMsgListViewController.h"
#import "MyNotifyListViewController.h"
#import "MyFavoriteListViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AddressListViewController.h"

#define  ACCOUNT_HEIGHT  125
#define  ORDER_BUTTON_HEIGHT  60

@interface AccountViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation AccountViewController

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
    _dataList=[NSArray arrayWithObjects:
               /*
               [NSDictionary dictionaryWithObjectsAndKeys:
                @"我的订单",@"name",
                @"myorder.png",@"image",
                nil],
                 */
               [NSDictionary dictionaryWithObjectsAndKeys:
                @"团购券",@"name",
                @"mygroupon.png",@"image",
                nil],
               [NSDictionary dictionaryWithObjectsAndKeys:
                @"优惠券",@"name",
                @"mycoupon.png",@"image",
                nil],
               [NSDictionary dictionaryWithObjectsAndKeys:
                @"我的收藏",@"name",
                @"myfavorite.png",@"image",
                nil],
               [NSDictionary dictionaryWithObjectsAndKeys:
                @"设置",@"name",
                @"mysetting.png",@"image",
                nil],
               nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessNotification:)
                                                 name:@"loginSuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutSuccessNotification:)
                                                 name:@"logoutSuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMallNotification:)
                                                 name:@"changeMallNotification"
                                               object:nil];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    UIView *leftButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doToggleLeftView:) andButtonType:OCCNavigationButtonTypeShowLeft andLeft:YES];
    [topImageView addSubview:leftButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"我的账户"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.view addSubview:titleLable];
    
    //登录前===================================
    UIView *notloginView=[[UIView alloc]init];
    [notloginView setFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-HEADER_HEIGHT-TABBAR_HEIGHT)];
    [self.view addSubview:notloginView];
    _notloginView=notloginView;
    
    UIImageView *logoImageView=[[UIImageView alloc]init];
    [logoImageView setFrame:CGRectMake(0, 20, 214, 66)];
    [logoImageView setCenter:CGPointMake(self.view.center.x, logoImageView.center.y)];
    [logoImageView setImage:[UIImage imageNamed:@"powerlong"]];
    [notloginView addSubview:logoImageView];
    
    UILabel *tipLable = [[UILabel alloc]init];
    [tipLable setTextColor:COLOR_999999];
    [tipLable setTextAlignment:NSTextAlignmentCenter];
    [tipLable setBackgroundColor:[UIColor clearColor]];
    [tipLable setFont:FONT_16];
    [tipLable setText:[NSString stringWithFormat:@"注册登录,更多便捷带给您和您的家人"]];
    [tipLable setFrame:CGRectMake(0,80, SCREEN_WIDTH, HEADER_HEIGHT)];
    [notloginView addSubview:tipLable];
    
    UIView *registerButton = [CommonMethods buttonWithTitle:@"注册" withTarget:self andSelector:@selector(doRegister:) andFrame:CGRectMake(10, 140, 145, 44) andButtonType:OCCButtonTypeGreen];
    [notloginView addSubview:registerButton];
    
    UIView *loginButton = [CommonMethods buttonWithTitle:@"登录" withTarget:self andSelector:@selector(doLogin:) andFrame:CGRectMake(165, 140, 145, 44) andButtonType:OCCButtonTypeYellow];
    [notloginView addSubview:loginButton];
    
    //登录后======================================
    UIView *accountView = [[UIView alloc]init];
    [accountView setFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-HEADER_HEIGHT-TABBAR_HEIGHT)];
    [self.view addSubview:accountView];
    _accountView=accountView;
    
    UIView *accountTableHeadView = [[UIView alloc]init];
    [accountTableHeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, ACCOUNT_HEIGHT+ORDER_BUTTON_HEIGHT)];
    [accountView addSubview:accountTableHeadView];
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
    [bgImageView setFrame:CGRectMake(0,0, SCREEN_WIDTH, ACCOUNT_HEIGHT)];
    [bgImageView setImage:[UIImage imageNamed:@"bg_account.png"]];
    [bgImageView setHighlightedImage:[UIImage imageNamed:@"bg_account.png"]];
    [accountTableHeadView addSubview:bgImageView];
    
    UIImageView *defaultImageView = [[UIImageView alloc]init];
    [defaultImageView setFrame:CGRectMake(20,40, 65, 65)];
    [defaultImageView setImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypePortrait]];
    [defaultImageView setHighlightedImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypePortrait]];
    defaultImageView.layer.masksToBounds=YES;
    defaultImageView.layer.cornerRadius=5.0;
    [accountTableHeadView addSubview:defaultImageView];
    defaultImageView.center=CGPointMake(defaultImageView.center.x, bgImageView.frame.size.height/2);
    
    UIImageView *personImageView = [[UIImageView alloc]init];
    [personImageView setFrame:CGRectInset(defaultImageView.frame, 4, 4)];
    [personImageView setImage:[UIImage imageNamed:@"bg_person.png"]];
    [personImageView setHighlightedImage:[UIImage imageNamed:@"bg_person.png"]];
    [accountTableHeadView addSubview:personImageView];
    _personImageView=personImageView;
    
     _nameLable = [[UILabel alloc]init];
    [_nameLable setTextColor:COLOR_27813A];
    [_nameLable setFont:FONT_20];
    [_nameLable setBackgroundColor:[UIColor clearColor]];
    [_nameLable setText:[[Singleton sharedInstance] userNickname]];
    [_nameLable setFrame:CGRectMake(95,30, SCREEN_WIDTH, HEADER_HEIGHT)];
    [_nameLable setTextAlignment:NSTextAlignmentLeft];
    [accountTableHeadView addSubview:_nameLable];
    
    UIButton *noticeButton = [[UIButton alloc]init];
    [noticeButton setFrame:CGRectMake(80, 60, 88, 44)];
    //[noticeButton setBackgroundImage:[UIImage imageNamed:@"btn_white.png"] forState:UIControlStateNormal];
    [noticeButton setImage:[UIImage imageNamed:@"btn_notice.png"] forState:UIControlStateNormal];
    [noticeButton addTarget:self action:@selector(showNoticeList:) forControlEvents:UIControlEventTouchUpInside];
    noticeButton.titleLabel.font = FONT_16;
    [noticeButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [noticeButton setTitle:@"通知" forState:UIControlStateNormal];
    [accountTableHeadView addSubview:noticeButton];
    
    UILabel *notifyNumLable = [[UILabel alloc]init];
    [notifyNumLable setFont:FONT_12];
    [notifyNumLable setTextColor:COLOR_FFFFFF];
    [notifyNumLable setBackgroundColor:COLOR_FAB731];
    [notifyNumLable setText:@""];
    [notifyNumLable setFrame:CGRectMake(65,10, 20, 12)];
    [notifyNumLable setTextAlignment:NSTextAlignmentCenter];
    notifyNumLable.layer.masksToBounds=YES;
    notifyNumLable.layer.cornerRadius=6;
    [noticeButton addSubview:notifyNumLable];
    _notifyNumLable=notifyNumLable;
    _notifyNumLable.hidden=YES;
    
    UIButton *msgButton = [[UIButton alloc]init];
    [msgButton setFrame:CGRectMake(170, 60, 88, 44)];
    [msgButton setImage:[UIImage imageNamed:@"btn_msg.png"] forState:UIControlStateNormal];
    [msgButton addTarget:self action:@selector(showMsgList:) forControlEvents:UIControlEventTouchUpInside];
    msgButton.titleLabel.font = FONT_16;
    [msgButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [msgButton setTitle:@"消息" forState:UIControlStateNormal];
    [accountTableHeadView addSubview:msgButton];
    
    UILabel *msgNumLable = [[UILabel alloc]init];
    [msgNumLable setFont:FONT_12];
    [msgNumLable setTextColor:COLOR_FFFFFF];
    [msgNumLable setBackgroundColor:COLOR_FAB731];
    [msgNumLable setText:@""];
    [msgNumLable setFrame:CGRectMake(65,10, 20, 12)];
    [msgNumLable setTextAlignment:NSTextAlignmentCenter];
    msgNumLable.layer.masksToBounds=YES;
    msgNumLable.layer.cornerRadius=6;
    [msgButton addSubview:msgNumLable];
    _msgNumLable=msgNumLable;
    _msgNumLable.hidden=YES;
    
    OCCBadgeButton *orderButton1 = [[OCCBadgeButton alloc]init];
    [orderButton1 setFrame:CGRectMake(0, ACCOUNT_HEIGHT, SCREEN_WIDTH/4, ORDER_BUTTON_HEIGHT)];
    [orderButton1 setBackgroundColor:COLOR_FFF6DA];
    [orderButton1 setImage:[UIImage imageNamed:@"icon_ayment"] forState:UIControlStateNormal];
    [orderButton1 addTarget:self action:@selector(showOrderList:) forControlEvents:UIControlEventTouchUpInside];
    orderButton1.titleLabel.font = FONT_12;
    [orderButton1 setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [orderButton1 setTitle:@"待付款" forState:UIControlStateNormal];
    [accountTableHeadView addSubview:orderButton1];
    _orderButton1=orderButton1;
    
    OCCBadgeButton *orderButton2 = [[OCCBadgeButton alloc]init];
    [orderButton2 setFrame:CGRectMake(SCREEN_WIDTH/4*1, ACCOUNT_HEIGHT, SCREEN_WIDTH/4, ORDER_BUTTON_HEIGHT)];
    [orderButton2 setBackgroundColor:COLOR_FFF6DA];
    [orderButton2 setImage:[UIImage imageNamed:@"icon_ship"] forState:UIControlStateNormal];
    [orderButton2 addTarget:self action:@selector(showOOrderList:) forControlEvents:UIControlEventTouchUpInside];
    orderButton2.titleLabel.font = FONT_12;
    [orderButton2 setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [orderButton2 setTitle:@"待发货" forState:UIControlStateNormal];
    orderButton2.tag=MyOOrderStatWillSend;
    [accountTableHeadView addSubview:orderButton2];
    _orderButton2=orderButton2;
    
    OCCBadgeButton *orderButton3 = [[OCCBadgeButton alloc]init];
    [orderButton3 setFrame:CGRectMake(SCREEN_WIDTH/4*2, ACCOUNT_HEIGHT, SCREEN_WIDTH/4, ORDER_BUTTON_HEIGHT)];
    [orderButton3 setBackgroundColor:COLOR_FFF6DA];
    [orderButton3 setImage:[UIImage imageNamed:@"icon_receipt"] forState:UIControlStateNormal];
    [orderButton3 addTarget:self action:@selector(showOOrderList:) forControlEvents:UIControlEventTouchUpInside];
    orderButton3.titleLabel.font = FONT_12;
    [orderButton3 setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [orderButton3 setTitle:@"待收货" forState:UIControlStateNormal];
    orderButton3.tag=MyOOrderStatWillReceive;
    [accountTableHeadView addSubview:orderButton3];
    _orderButton3=orderButton3;
    
    OCCBadgeButton *orderButton4 = [[OCCBadgeButton alloc]init];
    [orderButton4 setFrame:CGRectMake(SCREEN_WIDTH/4*3, ACCOUNT_HEIGHT, SCREEN_WIDTH/4, ORDER_BUTTON_HEIGHT)];
    [orderButton4 setBackgroundColor:COLOR_FFF6DA];
    [orderButton4 setImage:[UIImage imageNamed:@"icon_complete"] forState:UIControlStateNormal];
    [orderButton4 addTarget:self action:@selector(showOOrderList:) forControlEvents:UIControlEventTouchUpInside];
    orderButton4.titleLabel.font = FONT_12;
    [orderButton4 setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [orderButton4 setTitle:@"已完成" forState:UIControlStateNormal];
    orderButton4.tag=MyOOrderStatWillComplete;
    [accountTableHeadView addSubview:orderButton4];
    _orderButton4=orderButton4;
    [orderButton4 setCount:10];
    
    for (int i=0; i<4; i++)
    {
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.frame=CGRectMake(SCREEN_WIDTH/4*i, ACCOUNT_HEIGHT+5, 1, ORDER_BUTTON_HEIGHT-10);
        imageView.image=[UIImage imageNamed:@"line_account"];
        [accountTableHeadView addSubview:imageView];
    }
    
    //===================================
    OCCTableView *tableView=[[OCCTableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-TABBAR_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS2];
    [tableView setTableHeaderView:accountTableHeadView];
    [accountView addSubview:tableView];
    _tableView=tableView;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
    // 上拉加载
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.backgroundColor=[UIColor clearColor];
    _footer.scrollView = self.tableView;
    _footer.hidden=YES;
    
    [self reloadUIView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_nameLable setText:[[Singleton sharedInstance] userNickname]];
    [self loadNotifyCountData];
    [self loadOrderCountData];
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
    [_footer free];
}

- (void) loginSuccessNotification:(NSNotification*)notification
{
    [self reloadUIView];
}

- (void) logoutSuccessNotification:(NSNotification*)notification
{
    [self reloadUIView];
}

- (void) changeMallNotification:(NSNotification*)notification
{
    [self reloadUIView];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doLogin:(id)sender
{
    LoginViewController *viewController=[[LoginViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:viewController];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController presentModalViewController:nav animated:YES];
}

- (void)doRegister:(id)sender
{
    RegisterViewController *viewController=[[RegisterViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:viewController];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController presentModalViewController:nav animated:YES];
}

- (void)showMsgList:(id)sender
{
    MyMsgListViewController *viewController=[[MyMsgListViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    [self reloadUIView];
}

- (void)showNoticeList:(id)sender
{
    MyNotifyListViewController *viewController=[[MyNotifyListViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    [self reloadUIView];
}

- (void)showOrderList:(id)sender
{
    MyOrderListViewController *viewController=[[MyOrderListViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showOOrderList:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    MyOOrderListViewController *viewController=[[MyOOrderListViewController alloc]init];
    [viewController setStat:btn.tag];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)doToggleLeftView:(id)sender
{
    [_delegate toggleLeftView];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
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
    static NSString *AccountCellIdentifier=@"AccountCellIdentifier";
    
    AccountCell *cell = (AccountCell*)[tableView dequeueReusableCellWithIdentifier:AccountCellIdentifier];
    if (cell == nil)
    {
        cell=[[AccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AccountCellIdentifier];
    }
    
    int row=indexPath.row;
    NSDictionary *data = [_dataList objectAtIndex:row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row=indexPath.row;
    switch (row)
    {
            /*
        case 0:
        {
            MyOrderListViewController *viewController=[[MyOrderListViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
             */
        case 0:
        {
            MyGrouponListViewController *viewController=[[MyGrouponListViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 1:
        {
            MyCouponListViewController *centerController=[[MyCouponListViewController alloc]init];
            IIViewDeckController *deckController=[[IIViewDeckController alloc]init];
            deckController.leftController=nil;
            deckController.centerController=centerController;
            deckController.rightController=nil;
            deckController.leftSize = 60;
            deckController.rightSize = 60;
            deckController.openSlideAnimationDuration = 0.3f;
            deckController.closeSlideAnimationDuration = 0.3f;
            deckController.bounceOpenSideDurationFactor = 0.3f;
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:deckController animated:YES];
            return;
        }
            break;
        case 2:
        {
            MyFavoriteListViewController *viewController=[[MyFavoriteListViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 3:
        {
            MySettingViewController *viewController=[[MySettingViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4:
        {
            AddressListViewController *viewController=[[AddressListViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}

-(void)reloadData
{
    [self loadNotifyCountData];
    [self loadOrderCountData];
}

-(void)loadNotifyCountData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:unReadNumsMobile_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
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
                                              int unReadMessageNum=[[data objectForKey:@"unReadMessageNum"]intValue];
                                              int unReadNotifyNum=[[data objectForKey:@"unReadNotifyNum"]intValue];
                                              int totalNum=unReadMessageNum+unReadNotifyNum;
                                              [UIApplication sharedApplication].applicationIconBadgeNumber = totalNum;
                                              
                                              AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                              [myDelegate.tabbarItemFive setUnReadCount:totalNum];
                                              
                                              if (unReadMessageNum==0)
                                              {
                                                  _msgNumLable.hidden=YES;
                                              }
                                              else
                                              {
                                                  _msgNumLable.hidden=NO;
                                              }
                                              
                                              if (unReadNotifyNum==0)
                                              {
                                                  _notifyNumLable.hidden=YES;
                                              }
                                              else
                                              {
                                                  _notifyNumLable.hidden=NO;
                                              }
                                              
                                              [_msgNumLable setText:[NSString stringWithFormat:@"%d",unReadMessageNum]];
                                              [_msgNumLable sizeToFit];
                                              [_msgNumLable setFrame:CGRectMake(_msgNumLable.frame.origin.x,
                                                                                _msgNumLable.frame.origin.y,
                                                                                _msgNumLable.frame.size.width+10,
                                                                                _msgNumLable.frame.size.height)];
                                              [_notifyNumLable setText:[NSString stringWithFormat:@"%d",unReadNotifyNum]];
                                              [_notifyNumLable sizeToFit];
                                              [_notifyNumLable setFrame:CGRectMake(_notifyNumLable.frame.origin.x,
                                                                                   _notifyNumLable.frame.origin.y,
                                                                                   _notifyNumLable.frame.size.width+10,
                                                                                   _msgNumLable.frame.size.height)];
                                              
                                              NSString *strURL  = [[data objectForKey:@"userIcon"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                              NSURL *url = [NSURL URLWithString:strURL];
                                              [self.personImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypePortrait]];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(void)loadOrderCountData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadOrderCount_URL andData:reqdata andDelegate:nil];
                       
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
                                              int finishCount=[[data objectForKey:@"finishCount"]intValue];
                                              int noPayCount=[[data objectForKey:@"noPayCount"]intValue];
                                              int waitRecvCount=[[data objectForKey:@"waitRecvCount"]intValue];
                                              int waitSendCount=[[data objectForKey:@"waitSendCount"]intValue];
                                              [_orderButton1 setCount:noPayCount];
                                              [_orderButton2 setCount:waitSendCount];
                                              [_orderButton3 setCount:waitRecvCount];
                                              [_orderButton4 setCount:finishCount];
                                              
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(void) reloadUIView
{
    if ([[Singleton sharedInstance]TGC]==nil|| [[[Singleton sharedInstance]TGC]length]==0)
    {
        _notloginView.hidden=NO;
        _accountView.hidden=YES;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate.tabbarItemFive setUnReadCount:0];
    }
    else
    {
        _notloginView.hidden=YES;
        _accountView.hidden=NO;
        [self reloadData];
    }
}
@end
