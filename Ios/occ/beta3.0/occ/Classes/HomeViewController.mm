//
//  HomeViewController.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "HomeViewController.h"
#import "NaviManager.h"
#import "ActivityViewController.h"
#import "GoodsViewController.h"
#import "GrouponViewController.h"
#import "OCCWebViewController.h"
#import "AdvertisementSeat.h"
#import "DetailWebViewController.h"
#import "GrouponListViewController.h"
#import "NavBrandViewController.h"
#import <ZXingWidgetController.h>
#import <QRCodeReader.h>
#import "SecurityUtil.h"

#define kTitle @"title"

@interface HomeViewController ()<MJRefreshBaseViewDelegate,ZXingDelegate,DecoderDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    UILabel             *cityLbl;
    UIImageView         *arrowImg;
}

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFrontPageCallBack:) name:OCC_NOTIFI_FRONTPAGE_RETURN object:nil];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    [self initTitleView];
    
    self.popupMenuItems = [[NSMutableArray alloc]init];
    self.dataListMall = [[NSMutableArray alloc]init];

    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-FOOTER_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    //增加遮罩层
    UIImage *maskImage = [UIImage imageNamed:@"header_mask"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, maskImage.size.height)];
    imageView.image = maskImage;
    [self.view addSubview:imageView];
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
    //获取首页数据
    [self getFrontPageData];
    [self getMallInfo];
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
    
    if (self.myTimer!=nil)
    {
        [self.myTimer invalidate];
        self.myTimer=nil;
    }
}

//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    self.myTimer=[NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(pageChange)
                                                userInfo:nil
                                                 repeats:YES];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [self.myTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    double delayInSeconds = REFRESH_TIME_INTERVAL;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self regetFrontPageData];
        [self getMallInfo];
    });
}

#pragma mark -
#pragma mark LKPopupMenuDelegate

- (void)willDisappearPopupMenuController:(LKPopupMenuController*)popupMenuController
{
    arrowImg.image = [UIImage imageNamed:@"site_pull_default"];
}

- (void)popupMenuController:(LKPopupMenuController*)popupMenuController didSelectRowAtIndex:(NSUInteger)index
{
    NSLog(@"index is %d",index);

    arrowImg.image = [UIImage imageNamed:@"site_pull_default"];
    cityLbl.text = [self.popupMenuItems objectAtIndex:index];
    
    int mall=[[[self.dataListMall objectAtIndex:index]objectForKey:@"mall"]intValue];
    if ([Singleton sharedInstance].mall!=mall)
    {
        [Singleton sharedInstance].mall=[[[self.dataListMall objectAtIndex:index]objectForKey:@"mall"]intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMallNotification" object:nil];
        [_header beginRefreshing];
    }
}

- (void)popupAt:(CGPoint)location arrangementMode:(LKPopupMenuControllerArrangementMode)arrangementMode
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (self.popupMenu.popupmenuVisible) {
        [self.popupMenu dismiss];
    } else {
        if (self.popupMenu == nil) {
            self.popupMenu = [LKPopupMenuController popupMenuControllerOnView:self.view];
            self.popupMenu.textList = self.popupMenuItems;
            self.popupMenu.delegate = self;
            self.popupMenu.selectedIndexSet = [NSIndexSet indexSetWithIndex:0];
        }
        self.popupMenu.title = nil;
        self.popupMenu.autoresizeEnabled = YES;
        self.popupMenu.autocloseEnabled = YES;
        self.popupMenu.bounceEnabled = NO;
        self.popupMenu.multipleSelectionEnabled = NO;
        self.popupMenu.arrangementMode = arrangementMode;
        self.popupMenu.animationMode = LKPopupMenuControllerAnimationModeSlide;
        self.popupMenu.modalEnabled = YES;
        
        LKPopupMenuAppearance* appearance = [LKPopupMenuAppearance defaultAppearanceWithSize:LKPopupMenuControllerSizeMedium
                                                                                       color:LKPopupMenuControllerColorWhite];
        appearance.shadowEnabled = YES;
        appearance.triangleEnabled = YES;
        appearance.separatorEnabled = YES;
        appearance.outlineEnabled = NO;
        appearance.titleHighlighted = YES;
        appearance.menuTextColor = [UIColor blackColor];
        appearance.menuHilightedColor = UIColorFromRGB(0x27813a);
        self.popupMenu.appearance = appearance;
        [self.popupMenu presentPopupMenuFromLocation:location];
    }
}

- (void)switchMallAction:(UIButton *)sender
{
    if (self.dataListMall==nil||[self.dataListMall count]<=1)
    {
        return;
    }
    
    arrowImg.image = [UIImage imageNamed:@"site_pull_hover"];
    
    CGPoint location = CGPointMake(CGRectGetMidX(sender.frame), CGRectGetMaxY(cityLbl.frame));
    [self popupAt:location arrangementMode:LKPopupMenuControllerArrangementModeDown];
}

#pragma mark -
#pragma mark Methods
- (void)doToggleLeftView:(id)sender
{
    [_delegate toggleLeftView];
}

- (void)doShow2Code:(id)sender
{
    /*
    //测试支付宝支付
    NSString *tradeNO=[self generateTradeNO];
    NSString *partner=PartnerID;
    NSString *seller=SellerID;
    NSString *notifyURL=@"http%3A%2F%2Fwwww.xxx.com";
    
    Product *product=[[Product alloc]init];
    product.amount=[NSString stringWithFormat:@"%.2f",0.01];
    product.body=@"福州宝龙";
    product.subject=@"福州宝龙";
    product.partner=partner;
    product.seller=seller;
    product.notifyURL=notifyURL;
    product.tradeNO=tradeNO;
    [CommonMethods alipay:product];
    return;
     */
    
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO)
    {
        return;
    }
    
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    NSMutableSet *readers = [[NSMutableSet alloc] init];
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
    widController.readers = readers;
    [self presentViewController:widController animated:NO completion:^{}];
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdvertisementSeat *adSeat = [_dataList objectAtIndex:indexPath.row];
    if ([adSeat.seatType integerValue] == AdvertisementTypeImages)
    {
        //多图循环
        static NSString *Home3CellIdentifier=@"Home3CellIdentifier";
        
        Home3Cell *cell = (Home3Cell *)[tableView dequeueReusableCellWithIdentifier:Home3CellIdentifier];
        if (cell == nil)
        {
            cell = [[Home3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Home3CellIdentifier];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:adSeat];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if ([adSeat.seatType integerValue] == AdvertisementTypeSingleImage)
    {
        //单图
        static NSString *Home1CellIdentifier=@"Home1CellIdentifier";
        Home1Cell *cell = (Home1Cell*)[tableView dequeueReusableCellWithIdentifier:Home1CellIdentifier];
        if (cell == nil)
        {
            cell = [[Home1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Home1CellIdentifier];
            cell.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell setData:adSeat];
        return cell;
    }
    else if ([adSeat.seatType integerValue] == AdvertisementTypeDoubleImage)
    {
        //双图
        static NSString *Home2CellIdentifier=@"Home2CellIdentifier";
        Home2Cell *cell = (Home2Cell*)[tableView dequeueReusableCellWithIdentifier:Home2CellIdentifier];
        if (cell == nil)
        {
            cell = [[Home2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Home2CellIdentifier];
            cell.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setData:adSeat];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else
    {
        ZSLog(@"Error:首页广告类型错误");
        return nil;
    }
}

#pragma mark -
#pragma mark Cell Delegate
- (void)singleAdverTaped:(Advertisement *)tempAdver
{
    [self adverTaped:tempAdver];
}

- (void)doubleAdverTaped:(Advertisement *)tempAdver
{
    [self adverTaped:tempAdver];
}

- (void)circleAdverTaped:(Advertisement *)tempAdver
{
    [self adverTaped:tempAdver];
}


#pragma mark - ZXingDelegate
- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:NO completion:^{[self outPutResult:result];}];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissViewControllerAnimated:NO completion:^{NSLog(@"cancel!");}];
}

//自动循环展示
- (void)pageChange
{
    Home3Cell *cell=(Home3Cell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell != nil && [cell respondsToSelector:@selector(changeImage)])
    {
        [cell changeImage];
    }
}

- (void)initTitleView
{
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    UIView *leftButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doToggleLeftView:) andButtonType:OCCNavigationButtonTypeShowLeft andLeft:YES];
    [topImageView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doShow2Code:) andButtonType:OCCNavigationButtonTypeTwoCode andLeft:NO];
    [topImageView addSubview:rightButton];
    
    UIImage *logoImage = [UIImage imageNamed:@"header_logo"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height)];
    imageView.image = [UIImage imageNamed:@"header_logo"];
    [topImageView addSubview:imageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"%@",kBaoLongCityTitle]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [titleLable sizeToFit];
    [topImageView addSubview:titleLable];
    cityLbl = titleLable;
    
    //调整位置
    CGRect selfRect = imageView.frame;
    selfRect.origin = CGPointMake((SCREEN_WIDTH - (logoImage.size.width + titleLable.frame.size.width))/2, (HEADER_HEIGHT - logoImage.size.height)/2);
    imageView.frame = selfRect;
    
    selfRect = titleLable.frame;
    selfRect.origin = CGPointMake(imageView.frame.origin.x+imageView.frame.size.width + 5, imageView.frame.origin.y + 3);
    titleLable.frame = selfRect;
    
    UIImage *aimage = [UIImage imageNamed:@"site_pull_default"];
    UIImageView *img = [[UIImageView alloc] initWithImage:aimage];
    img.frame = CGRectMake(CGRectGetMaxX(titleLable.frame)+ 5, (44-aimage.size.height)/2, aimage.size.width, aimage.size.height);
    img.hidden=YES;
    [topImageView addSubview:img];
    arrowImg = img;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(switchMallAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(CGRectGetMinX(titleLable.frame)-10, 0, CGRectGetWidth(titleLable.frame) + 30, 44);
    [topImageView addSubview:button];
}

//Cell点击进入广告详情
- (void)adverTaped:(Advertisement *)tempAdver
{
    if ([tempAdver.adLink isEqualToString:@"#"])
    {
        return;
    }
    
    NSInteger type = [tempAdver.adType integerValue];
    if (type == AdvertisementPageTypeActivity)
    {
        //活动类型广告
        NSDictionary *dataDic = [CommonMethods getJsonValueFromString:tempAdver.adLink];
        //活动 需要传入id
        ActivityViewController *viewController = [[ActivityViewController alloc]init];
        [viewController setData:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [dataDic valueForKey:KEY_ACTIVITYID],KEY_ID,
                                 nil]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (type == AdvertisementPageTypeGoods)
    {
        //商品类型广告
        NSDictionary *dataDic = [CommonMethods getJsonValueFromString:tempAdver.adLink];
        //商品详情
        GoodsViewController *viewController=[[GoodsViewController alloc]init];
        NSString *setItemId = [dataDic valueForKey:KEY_ITEMID];
        [viewController setItemId:[setItemId integerValue]];
        [self.navigationController pushViewController:viewController animated:YES];

    }
    else if (type == AdvertisementPageTypeGroupon)
    {
        //团购类型广告
        NSDictionary *dataDic = [CommonMethods getJsonValueFromString:tempAdver.adLink];
        NSString *grouponId = [dataDic objectForKey:KEY_GROUPONID];
        //团购详情
        GrouponViewController *viewController=[[GrouponViewController alloc]init];
        [viewController setGrouponId:[grouponId integerValue]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (type == AdvertisementPageTypeLink)
    {
        //链接类型广告 直接WebView打开
        OCCWebViewController *viewController = [[OCCWebViewController alloc] init];
        viewController.data = [NSDictionary dictionaryWithObjectsAndKeys:
                               tempAdver.adLink,KEY_ADLINK,
                               tempAdver.adDis,kTitle,
                               nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (type == AdvertisementPageTypeShop)
    {
        NSDictionary *dataDic = [CommonMethods getJsonValueFromString:tempAdver.adLink];
        //直接使用Data请求即可
        [CommonMethods pushShopViewControllerWithData:dataDic];
    }
    else if (type == AdvertisementPageTypeGrouponList)
    {
        //团购列表
        GrouponListViewController *centerController=[[GrouponListViewController alloc]init];
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
    }
    else if (type == AdvertisementPageTypeBrand)
    {
        NavBrandViewController *viewController=[[NavBrandViewController alloc]init];
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark -
#pragma mark Front Page Data CallBack
//请求数据返回
- (void)requestFrontPageCallBack:(NSNotification *)noti
{
    [_header endRefreshing];
    
    NSDictionary *dic = [noti userInfo];
    ReturnCodeModel *returnCode = [[noti userInfo] valueForKey:kReturnCodeKey];
    if (returnCode.code == kReturnSuccess)
    {
        //返回成功 解析数据
        NSArray *returnData = [dic valueForKey:kReturnDataKey];
        _dataList = [[NSMutableArray alloc] initWithArray:returnData];
        [_tableView reloadData];
    }
    else
    {
        //错误提示
        [CommonMethods showAutoDismissView:returnCode.codeDesc inView:self.view];
    }
}

- (void)getFrontPageData
{
    NSArray *adSeatArr = [[BusinessManager sharedManager].naviManager getLocalFrontPageData];
    if (adSeatArr && [adSeatArr count] > 0)
    {
        //1.获取本地数据
        _dataList = [[NSMutableArray alloc] initWithArray:adSeatArr];
    }
    else
    {
        //2.缓存数据不存在 则请求数据
        [self regetFrontPageData];
    }
}

- (void)regetFrontPageData
{
    [[BusinessManager sharedManager].naviManager requestFrontPage];
    return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  @"1",KEY_PLATFORM,
                                                  @"baolongtiandi", KEY_CHANNELCODE,
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       NSString *str=[NSString stringWithFormat:@"%@%@%@",PLOCC_PORT,PLOCC_MOBILECENTER,NAVI_FRONTPAGE];
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                          [_header endRefreshing];
                                          [_footer endRefreshing];
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
                                              NSString *fileName=[NSString stringWithFormat:@"mall_%d_frontpage.plist",[[Singleton sharedInstance]mall]];
                                              NSString *filePath = [CommonMethods getDataCachePathWithFileName:fileName];
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              [data writeToFile:filePath atomically:YES];
                                              NSArray *dataList = [[BusinessManager sharedManager].naviManager parseAdvertisementData:data];
                                              self.dataList=dataList;
                                              [self.tableView reloadData];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                              
                                              NSString *fileName=[NSString stringWithFormat:@"mall_%d_frontpage.plist",[[Singleton sharedInstance]mall]];
                                              NSString *filePath = [CommonMethods getDataCachePathWithFileName:fileName];
                                              NSDictionary *data=[NSDictionary dictionaryWithContentsOfFile:filePath];
                                              self.dataList=[[BusinessManager sharedManager].naviManager parseAdvertisementData:data];
                                              [self.tableView reloadData];
                                          });
                       }
                   });
}

- (void)outPutResult:(NSString *)result
{
    NSLog(@"result:%@", result);
    if ([result rangeOfString:@"powerlong" options:NSCaseInsensitiveSearch].location!=NSNotFound||[result hasPrefix:OCC_IP])
    {
        NSString *mac=[OCCUtiil getWifiMac];
        NSString *openUDID = [OpenUDID value];
        NSString *nid=[NSString stringWithFormat:@"%d",[[Singleton sharedInstance]userId]];
        NSString *key=MD5_KEY;
        NSString *md5Str=[SecurityUtil encryptMD5String:[NSString stringWithFormat:@"%@|%@,%@|%@",nid,mac,openUDID,key]];
        
        NSString *all=[NSString stringWithFormat:@"%@|%@|%@",nid,mac,md5Str];
        NSLog(@"all:%@", all);
        NSString *desStr=[SecurityUtil encryptDESString:all withKey:DES_KEY];
        
        NSString *urlStr=[NSString stringWithFormat:@"%@param=%@",result,[self encodeURL:desStr]];
        DetailWebViewController *viewController=[[DetailWebViewController alloc]init];
        [viewController setDetailURL:urlStr];
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate.navigationController pushViewController:viewController animated:YES];
        viewController.titleLable.text=@"扫描结果";
    }
    else if([result hasPrefix:@"http://"]||[result hasPrefix:@"https://"]||[result hasPrefix:@"tel://"]||[result hasPrefix:@"sms://"]||[result hasPrefix:@"malito://"])
    {
        NSURL *url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [CommonMethods showTip:result];
    }
}

- (NSString*)encodeURL:(NSString *)string
{
    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
    NSString *encodedValue = [formDataRequest encodeURL:string];
    return encodedValue;
}

- (void)getMallInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:getMallInfo_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          
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
                                              
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSArray *dataList=[root objectForKey:@"data"];
                                              self.dataListMall=dataList;
                                              
                                              if (self.dataListMall==nil||[self.dataListMall count]<=1)
                                              {
                                                  arrowImg.hidden=YES;
                                              }
                                              else
                                              {
                                                  arrowImg.hidden=NO;
                                              }
                                              
                                              NSMutableArray *array = [NSMutableArray array];
                                              for (NSDictionary *data in dataList)
                                              {
                                                  NSString *name=[NSString stringWithFormat:@"%@站",[data objectForKey:@"name"]];
                                                  [array addObject:name];
                                              }
                                              self.popupMenuItems = array;
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                          });
                       }
                   });
}

@end
