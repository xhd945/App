//
//  ActivityViewController.m
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ActivityViewController.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "Activity.h"

#define kImageHeight 140
#define kLabelPointX 10

@interface ActivityViewController ()

@end

@implementation ActivityViewController

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
                                             selector:@selector(requestActivityInfoCallBack:)
                                                 name:OCC_NOTIFI_ACTIVITYINFO_RETURN
                                               object:nil];
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"活动"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [topImageView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [topImageView addSubview:leftButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_HEIGHT)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    //Header部分
    CGFloat posionY = 0.0;
    CGFloat width = SCREEN_WIDTH - kLabelPointX - 10;
    _activityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, posionY, SCREEN_WIDTH, kImageHeight)];
    _activityImageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_activityImageView];
    posionY += _activityImageView.frame.size.height + 10;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelPointX, posionY, width, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = FONT_18;
    _titleLabel.textColor = COLOR_333333;
    _titleLabel.highlightedTextColor = COLOR_FFFFFF;
    [_scrollView addSubview:_titleLabel];
    posionY += _titleLabel.frame.size.height+10;
    
    UIImageView *lineImageView=[CommonMethods lineWithWithType:OCCLineType2];
    [lineImageView setFrame:CGRectMake(0, posionY, SCREEN_WIDTH, 1)];
    [_scrollView addSubview:lineImageView];
    posionY += lineImageView.frame.size.height + 10;
    
    _webView = [[OCCWebView alloc] initWithFrame:CGRectMake(0, posionY, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_HEIGHT - posionY)];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    [_scrollView addSubview:_webView];
    
    [CommonMethods showWaitView:@"正在请求中,请稍候..."];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect selfRect = _webView.frame;
    selfRect.size.height = _webView.scrollView.contentSize.height;
    _webView.frame = selfRect;
    
    _webView.scrollView.scrollEnabled = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _webView.frame.origin.y + _webView.frame.size.height);
}

- (void)refreshUIWithData:(NSDictionary *)data
{
    NSString *strURL  = [[data objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [_activityImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    [_titleLabel setText: [data objectForKey:@"name"]];
    
    NSString *htmlStr = [data objectForKey:@"introduction"];
    [_webView loadHTMLString:htmlStr baseURL:nil];
}

-(void)loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"id"], @"activityId",
                                                  nil];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadActivity_URL andData:reqdata andDelegate:nil];
                       
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
                                              [self refreshUIWithData:data];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(void)setData:(NSDictionary*)data
{
    _data = [NSDictionary dictionaryWithDictionary:data];
}

@end
