//
//  MapViewController.m
//  occ
//
//  Created by RS on 13-9-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MapViewController.h"
#import "ShopViewController.h"
#import "OneLineCell.h"
#import "OCCUtiil.h"

#define HIDE_TIME_INTERVAL 8

@interface MapViewController ()

@end

@implementation MapViewController

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
    self.floor=-1;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    OCCWebView *webView = [[OCCWebView alloc]init];
    webView.delegate=self;
    [webView setFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:webView];
    [self.view sendSubviewToBack:webView];
    _webView=webView;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.webView addGestureRecognizer:singleTap];
    singleTap.delegate=self;
    singleTap.cancelsTouchesInView =NO;
    
    [self initHeadView];
    [self initFootView];
    
    UIButton *btnShow = [[UIButton alloc]init];
    [btnShow setFrame:CGRectMake(10, SCREEN_HEIGHT-HEADER_HEIGHT, 44, 44)];
    [btnShow setBackgroundImage:[UIImage imageNamed:@"btn_hide_shrink.png"] forState:UIControlStateNormal];
    [btnShow setImage:[UIImage imageNamed:@"icon_hide_up.png"] forState:UIControlStateNormal];
    [btnShow addTarget:self action:@selector(showFloor) forControlEvents:UIControlEventTouchUpInside];
    [btnShow setEnabled:YES];
    [self.view addSubview:btnShow];
    _btnShow=btnShow;
    
    UIButton *btnHide = [[UIButton alloc]init];
    [btnHide setFrame:CGRectMake(10, SCREEN_HEIGHT-HEADER_HEIGHT, 44, 44)];
    [btnHide setBackgroundImage:[UIImage imageNamed:@"btn_hide_shrink.png"] forState:UIControlStateNormal];
    [btnHide setImage:[UIImage imageNamed:@"icon_hide_down.png"] forState:UIControlStateNormal];
    [btnHide addTarget:self action:@selector(hideFloor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnHide];
    _btnHide=btnHide;
    
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setBounces:NO];
    [self.view addSubview:tableView];
    _tableView=tableView;

    [self hideFloor];
    
    if (self.shopId>0)
    {
        [self searchByShopId:self.shopId];
    }
    else
    {
        [self research];
    }
    
    _myTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(handleTimer:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_myTimer!=nil)
    {
        [_myTimer invalidate];
        _myTimer=nil;
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    //UITouch *touch = [[event allTouches]anyObject];
    //UIView *touchView=touch.view;
    [self.searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"unlockAutoLocate()"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"lockAutoLocate()"];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doLocate:(id)sender
{
    [_webView stopLoading];
    [self research];
}

-(void) initHeadView
{
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2*HEADER_HEIGHT)];
    [self.view addSubview:headView];
    _headView=headView;
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [topImageView setAlpha:0.6];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"地图"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doLocate:) andButtonType:OCCNavigationButtonTypeLocate andLeft:NO];
    [headView addSubview:rightButton];
    
    OCCSearchBar *searchBar = [[OCCSearchBar alloc]initWithFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    searchBar.delegate = self;
    [searchBar setText:@""];
    [searchBar setBackgroundColor:COLOR_BG_CLASSFOUR];
    [headView addSubview:searchBar];
    _searchBar=searchBar;
}

-(void) initFootView
{
    UIView *footView = [[UIView alloc]init];
    [footView setFrame:CGRectMake(0, SCREEN_HEIGHT-HEADER_HEIGHT, SCREEN_WIDTH, FOOTER_HEIGHT)];
    [footView setBackgroundColor:COLOR_BG_CLASSFOUR];
    [self.view addSubview:footView];
    _footView=footView;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [scrollView setFrame:CGRectMake(64, 0, SCREEN_WIDTH - 64, FOOTER_HEIGHT)];
    [scrollView setContentSize:CGSizeMake(57 * 6, FOOTER_HEIGHT)];
    [scrollView setPagingEnabled:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setUserInteractionEnabled:YES];
    [footView addSubview:scrollView];
    
    _btnB1 = [[UIButton alloc]init];
    [_btnB1 setFrame:CGRectMake(0, 2, 57, 45)];
    [_btnB1 setBackgroundImage:nil forState:UIControlStateHighlighted];
    [_btnB1 addTarget:self action:@selector(switchFloor:) forControlEvents:UIControlEventTouchUpInside];
    [_btnB1 setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [_btnB1 setTitleColor:COLOR_FABE00 forState:UIControlStateHighlighted];
    [_btnB1 setTitle:@"B1" forState:UIControlStateNormal];
    [_btnB1 setTitle:@"B1" forState:UIControlStateHighlighted];
    [_btnB1 setTag:1];
    [scrollView addSubview:_btnB1];
    
    _btn1F = [[UIButton alloc]init];
    [_btn1F setFrame:CGRectMake(57, 2, 57, 45)];
    [_btn1F setBackgroundImage:nil forState:UIControlStateNormal];
    [_btn1F addTarget:self action:@selector(switchFloor:) forControlEvents:UIControlEventTouchUpInside];
    [_btn1F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [_btn1F setTitleColor:COLOR_FABE00 forState:UIControlStateHighlighted];
    [_btn1F setTitle:@"1F" forState:UIControlStateNormal];
    [_btn1F setTitle:@"1F" forState:UIControlStateHighlighted];
    [_btn1F setTag:2];
    [scrollView addSubview:_btn1F];
    
    _btn2F = [[UIButton alloc]init];
    [_btn2F setFrame:CGRectMake(57 * 2, 2, 57, 45)];
    [_btn2F setBackgroundImage:nil forState:UIControlStateHighlighted];
    [_btn2F addTarget:self action:@selector(switchFloor:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [_btn2F setTitleColor:COLOR_FABE00 forState:UIControlStateHighlighted];
    [_btn2F setTitle:@"2F" forState:UIControlStateNormal];
    [_btn2F setTitle:@"2F" forState:UIControlStateHighlighted];
    [_btn2F setTag:3];
    [scrollView addSubview:_btn2F];
    
    _btn3F = [[UIButton alloc]init];
    [_btn3F setFrame:CGRectMake(57 * 3, 2, 57, 45)];
    [_btn3F setBackgroundImage:nil forState:UIControlStateHighlighted];
    [_btn3F addTarget:self action:@selector(switchFloor:) forControlEvents:UIControlEventTouchUpInside];
    [_btn3F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [_btn3F setTitleColor:COLOR_FABE00 forState:UIControlStateHighlighted];
    [_btn3F setTitle:@"3F" forState:UIControlStateNormal];
    [_btn3F setTitle:@"3F" forState:UIControlStateHighlighted];
    [_btn3F setTag:4];
    [scrollView addSubview:_btn3F];
    
    _btn4F = [[UIButton alloc]init];
    [_btn4F setFrame:CGRectMake(57 * 4, 2, 57, 45)];
    [_btn4F setBackgroundImage:nil forState:UIControlStateHighlighted];
    [_btn4F addTarget:self action:@selector(switchFloor:) forControlEvents:UIControlEventTouchUpInside];
    [_btn4F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [_btn4F setTitleColor:COLOR_FABE00 forState:UIControlStateHighlighted];
    [_btn4F setTitle:@"4F" forState:UIControlStateNormal];
    [_btn4F setTitle:@"4F" forState:UIControlStateHighlighted];
    [_btn4F setTag:5];
    [scrollView addSubview:_btn4F];
    
    _btn5F = [[UIButton alloc]init];
    [_btn5F setFrame:CGRectMake(57 * 5, 2, 57, 45)];
    [_btn5F setBackgroundImage:nil forState:UIControlStateHighlighted];
    [_btn5F addTarget:self action:@selector(switchFloor:) forControlEvents:UIControlEventTouchUpInside];
    [_btn5F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [_btn5F setTitleColor:COLOR_FABE00 forState:UIControlStateHighlighted];
    [_btn5F setTitle:@"5F" forState:UIControlStateNormal];
    [_btn5F setTitle:@"5F" forState:UIControlStateHighlighted];
    [_btn5F setTag:6];
    [scrollView addSubview:_btn5F];
}

- (void)switchFloor:(id)sender
{
    self.downup=HIDE_TIME_INTERVAL;
    [self resetSwitchButton];
    UIButton *pButton = (UIButton*)sender;
    [pButton setBackgroundImage:[UIImage imageNamed:@"btn_hide_press.png"] forState:UIControlStateNormal];
    [pButton setTitleColor:COLOR_FABE00 forState:UIControlStateNormal];
    
    self.floor=pButton.tag;
    [self search];
}

- (void)resetSwitchButton
{
    [_btnB1 setBackgroundImage:nil forState:UIControlStateNormal];
    [_btnB1 setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    
    [_btn1F setBackgroundImage:nil forState:UIControlStateNormal];
    [_btn1F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    
    [_btn2F setBackgroundImage:nil forState:UIControlStateNormal];
    [_btn2F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    
    [_btn3F setBackgroundImage:nil forState:UIControlStateNormal];
    [_btn3F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    
    [_btn4F setBackgroundImage:nil forState:UIControlStateNormal];
    [_btn4F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    
    [_btn5F setBackgroundImage:nil forState:UIControlStateNormal];
    [_btn5F setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
}

#pragma mark - UIWebViewDelegate method
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint point =[sender locationInView:self.view];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
}

#pragma mark - UIWebViewDelegate method
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"IncreaseZoomFactor" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
    [webView stringByEvaluatingJavaScriptFromString:@"increaseMaxZoomFactor()"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSDictionary *obj =[NSDictionary dictionaryWithObjectsAndKeys:@"111",@"id",nil];
    //NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
    //
    //NSString *rurl=[NSString stringWithFormat:@"plocc://shop.plocc.htm?data=%@",reqdata];
    //NSString* rurl=@"plocc://shop.plocc.htm?data={\"id\":\"3\"}";
    
    //此url解析规则自己定义
    NSString* rurl=[[request URL] absoluteString];
    NSString *fix=@"plocc://shop.plocc.htm?shopid=";
    if ([rurl hasPrefix:fix])
    {
        NSString *shopId=[rurl substringWithRange:NSMakeRange([fix length],[rurl length]-[fix length])];
        NSDictionary *data=[NSDictionary dictionaryWithObjectsAndKeys:shopId,KEY_SHOPID,nil];
        ShopViewController *viewController=[[ShopViewController alloc]init];
        [viewController setData:data];
        [CommonMethods pushShopViewControllerWithData:data];
        return false;
    }
    return YES;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
    
    OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
    if (cell == nil)
    {
        cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
    }
    cell.rightStyle=OneLineCellRightCheck;
    
    UIView *backgroundView=[[UIView alloc]init];
    [backgroundView setBackgroundColor:COLOR_BG_CLASSONE];
    cell.backgroundView=backgroundView;
    
    UILabel *selectedBackgroundView=[[UILabel alloc]init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView=selectedBackgroundView;
    
    NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:[[_dataList objectAtIndex:indexPath.row]objectForKey:@"shopName"],@"name",@"",@"value",nil];
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setHidden:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    
    int row=indexPath.row;
    NSDictionary *data=[self.dataList objectAtIndex:row];
    if (row==0)
    {
        NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                   [[Singleton sharedInstance]TGC], @"TGC",
                                   [OCCUtiil getWifiMac], @"mac",
                                   self.floor==-1?@"":[NSNumber numberWithInt:self.floor],@"currfloor",
                                   @"-1",@"x",
                                   @"-1",@"y",
                                   [data objectForKey:@"rotate"],@"info",
                                   nil];
        [self searchByInfo:obj];
    }
    else
    {
        NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                   [[Singleton sharedInstance]TGC], @"TGC",
                                   [OCCUtiil getWifiMac], @"mac",
                                   [NSNumber numberWithInt:self.floor],@"currfloor",
                                   [data objectForKey:@"floorid"],@"floor",
                                   [data objectForKey:@"locationX"],@"x",
                                   [data objectForKey:@"locationY"],@"y",
                                   [data objectForKey:@"shopId"],@"shopId",
                                   [data objectForKey:@"shopName"],@"info",
                                   nil];
        [self searchByInfo:obj];
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    [self.tableView setHidden:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchShopInfo];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self searchShopInfo];
    /*
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], KEY_TGC,
                               [OCCUtiil getWifiMac], @"mac",
                               @"-1",@"x",
                               @"-1",@"y",
                               self.floor==-1?@"":[NSNumber numberWithInt:self.floor],@"currfloor",
                               self.searchBar.text,@"info",
                               nil];
    [self searchByInfo:obj];
     */
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text=@"";
}

#pragma mark -
#pragma mark - Your actions
- (void)showFloor
{
    self.downup=HIDE_TIME_INTERVAL;
    [_btnShow setEnabled:NO];
    [_btnShow setHidden:YES];
    [_btnHide setEnabled:YES];
    [_btnHide setHidden:NO];
    [_headView setHidden:NO];
    [_footView setHidden:NO];
}

- (void)hideFloor
{
    [_btnShow setEnabled:YES];
    [_btnShow setHidden:NO];
    [_btnHide setEnabled:NO];
    [_btnHide setHidden:YES];
    [_headView setHidden:YES];
    [_footView setHidden:YES];
}

- (void)research
{
    self.floor=-1;
    [self search];
}

- (void)search
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               [OCCUtiil getWifiMac], @"mac",
                               self.floor==-1?@"":[NSNumber numberWithInt:self.floor],@"floor",
                               nil];
    
    NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
    
    NSString *strURL=[NSString stringWithFormat:@"%@?data=%@",search_URL,reqdata];
    NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)searchShopInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [OCCUtiil getWifiMac], @"mac",
                                                  self.searchBar.text,KEY_INFO,
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:searchShopInfo_URL andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              NSMutableArray *dataList=[data objectForKey:@"shopList"];
                                              _dataList=dataList;
                                              [self.tableView setHidden:NO];
                                              [self.tableView setFrame:CGRectMake(0, 2*HEADER_HEIGHT, SCREEN_WIDTH, 44*[dataList count])];
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

- (void)searchByInfo:(NSDictionary *)data
{
    NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:data];
    
    NSString *strURL=[NSString stringWithFormat:@"%@?data=%@",searchByInfo_URL,reqdata];
    NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)searchByShopId:(int)shopId
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               [OCCUtiil getWifiMac], @"mac",
                               [NSNumber numberWithInt:shopId],@"shopId",
                               nil];
    
    NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
    
    NSString *strURL=[NSString stringWithFormat:@"%@?data=%@",searchByShopId_URL,reqdata];
    NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(void)handleTimer:(NSTimer *)timer
{
    return;
    self.downup--;
    if (self.downup<=0)
    {
        [self hideFloor];
    }
}

@end
