//
//  LoginWeiBoViewController.m
//  occ
//
//  Created by mac on 13-9-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

//#define  WEIBO_APP_ID @"3523447775"
//#define  WEIBO_APP_SECRET @"c719bff1d10ad2f3af0ebddc5c2f4d73"
//#define  WEIBO_LOGIN_CALLBACK_URL @"http://test.weibo.com"

#define  WEIBO_APP_ID @"3752948646"
#define  WEIBO_APP_SECRET @"6fcbf911e03d4f840b0b9530873a3602"
#define  WEIBO_LOGIN_CALLBACK_URL @"http://www.powerlongmall.cn"

#import "LoginWeiBoViewController.h"

@interface LoginWeiBoViewController ()

@end

@implementation LoginWeiBoViewController

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
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"新浪微博账号登录"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.view addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    _webView = [[UIWebView alloc]init];
    [_webView setFrame:CGRectMake(0, HEADER_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT-HEADER_HEIGHT)];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setOpaque:NO];
    [_webView setDelegate:self];
    [_webView setUserInteractionEnabled:YES];
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    
    [self startRequest];
}

-(void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRequest
{
    NSString *detailURL=[NSString stringWithFormat:@"https://open.weibo.cn/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code&display=mobile&forcelogin=true",
                WEIBO_APP_ID,
                WEIBO_LOGIN_CALLBACK_URL];
    NSURL *url =[NSURL URLWithString:[detailURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webView location = '%@'", webView.request.URL.absoluteString);
    NSString *str=[[NSString alloc]initWithString:_webView.request.URL.absoluteString];
    if ([str hasPrefix:WEIBO_LOGIN_CALLBACK_URL])
    {
        NSArray *arr=[str componentsSeparatedByString:@"?"];
        if ([arr count]>=2)
        {
            NSString *str0=[arr objectAtIndex:0];
            NSString *str1=[arr objectAtIndex:1];
            [self getAccessToken:str1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)getAccessToken:(NSString *)str
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSURL *url = [NSURL URLWithString:[@"https://api.weibo.com/oauth2/access_token" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                       ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
                       [request setRequestMethod:@"POST"];
                       [request setShouldAttemptPersistentConnection:NO];
                       [request setTimeOutSeconds:TIME_OUT_TIME_INTERVAL];
                       [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
                       [request addRequestHeader:@"type" value:@"app"];
                       [request setPostValue:WEIBO_APP_ID forKey:@"client_id"];
                       [request setPostValue:WEIBO_APP_SECRET forKey:@"client_secret"];
                       [request setPostValue:WEIBO_LOGIN_CALLBACK_URL forKey:@"redirect_uri"];
                       [request setPostValue:[[str componentsSeparatedByString:@"="]objectAtIndex:1] forKey:@"code"];
                       [request setPostValue:@"authorization_code" forKey:@"grant_type"];
                       //[request setDelegate:self];
                       [request startSynchronous];
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       NSLog(@"root=%@",root);
                       NSString *access_token=[root objectForKey:@"access_token"];
                       NSString *uid=[root objectForKey:@"uid"];
                       [self getUserInfoWithAccessToken:access_token andUid:uid];
                   });
}

-(void)getUserInfoWithAccessToken:(NSString*)access_token andUid:(NSString*)uid
{
    NSString *urlStr=[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",
                     access_token,
                     uid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
    NSDictionary *root = [jsonParser objectWithString:result];
    NSLog(@"root=%@",root);
    
    [self loginWeibo:access_token andUid:uid andUserInfo:root];
}

-(void)loginWeibo:(NSString *)access_token andUid:(NSString*)uid andUserInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               uid,@"open",
                               access_token,@"token",
                               [userInfo objectForKey:@"avatar_large"],@"head",
                               [userInfo objectForKey:@"name"],@"nickname",
                               @"1",@"sex",
                               nil];
    
    NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
    
    
    ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:qq_URL andData:reqdata andDelegate:nil];
    
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
                           [CommonMethods showFailDialog:@"网络异常,请检查您的网络设置!" inView:self.view];
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
                           NSDictionary *data=[root objectForKey:@"data"];
                           NSLog(@"login%@",data);
                           [[Singleton sharedInstance] setUserNickname:[data objectForKey:@"nickname"]];
                           [[Singleton sharedInstance] setUserName:[data objectForKey:@"username"]];
                           [[Singleton sharedInstance] setUserEmail:[data objectForKey:@"email"]];
                           [[Singleton sharedInstance] setUserMobile:[data objectForKey:@"mobile"]];
                           [[Singleton sharedInstance] setTGC:[data objectForKey:@"TGC"]];
                           [[Singleton sharedInstance] setUserId:[[data objectForKey:@"id"]intValue]];
                           
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessNotification" object:nil];
                       });
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                       });
    }
}

@end
