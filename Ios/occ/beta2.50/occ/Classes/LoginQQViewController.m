//
//  LoginQQViewController.m
//  occ
//
//  Created by mac on 13-9-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

//#define  QQ_APP_ID @"222222"
//#define  QQ_LOGIN_CALLBACK_URL @"http://connect.qq.com/"

#define  QQ_APP_ID @"100538118"
#define  QQ_LOGIN_CALLBACK_URL @"http://www.powerlongmall.cn"

#import "LoginQQViewController.h"
#import "AppDelegate.h"

@interface LoginQQViewController ()

@end

@implementation LoginQQViewController

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
    [titleLable setText:[NSString stringWithFormat:@"QQ账号登录"]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"webView location = '%@'", request.URL.absoluteString);
    NSString *str=[[NSString alloc]initWithString:request.URL.absoluteString];
    if ([str hasPrefix:QQ_LOGIN_CALLBACK_URL])
    {
        NSArray *arr=[str componentsSeparatedByString:@"?#"];
        if ([arr count]>=2)
        {
            switch (self.loginQQType)
            {
                case LoginQQTypePC:
                    [self getAccessTokenFromPC:[arr objectAtIndex:1]];
                    break;
                case LoginQQTypeWAP:
                    [self getAccessTokenFromWAP:[arr objectAtIndex:1]];
                    break;
                default:
                    break;
            }
            return NO;
        }
    }
    
    return YES;
}

- (void)startRequest
{
    self.loginQQType=LoginQQTypePC;
    NSString *urlString=@"";
    //NSString *urlString = @"https://graph.z.qq.com/moc2/authorize?response_type=token&client_id=222222&redirect_uri=http://connect.qq.com/&state=test";  //WAP
    //NSString *urlString = @"https://graph.qq.com/oauth2.0/authorize?response_type=token&client_id=222222&redirect_uri=http://connect.qq.com/&state=test&display=mobile"; //PC
    //NSString *urlString = @"https://openmobile.qq.com/oauth2.0/m_authorize";
    
    switch (self.loginQQType)
    {
        case LoginQQTypePC:
            urlString=[NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/authorize?response_type=token&client_id=%@&redirect_uri=%@&state=test&display=mobile",
                       QQ_APP_ID,
                       QQ_LOGIN_CALLBACK_URL];
            break;
        case LoginQQTypeWAP:
            urlString=[NSString stringWithFormat:@"https://graph.z.qq.com/moc2/authorize?response_type=token&client_id=%@&redirect_uri=%@&state=test",
                       QQ_APP_ID,
                       QQ_LOGIN_CALLBACK_URL];
            break;
        default:
            break;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *requestURL = [[NSMutableURLRequest alloc] initWithURL:url];
    [_webView loadRequest:requestURL];
}

-(void)getAccessTokenFromPC:(NSString *)str
{
    //获取openid
    NSString *access_token=[self parseText:@"access_token" fromHtmlString:str];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.z.qq.com/moc2/me?access_token=%@",access_token]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil
                                                           error:nil];
    NSString *result = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    NSString *openid=[self parseText:@"openid" fromHtmlString:result];
    
    //获取get_user_info
    [self getUserInfoWithAccessToken:access_token andOpenid:openid];
}

-(void)getAccessTokenFromWAP:(NSString *)str
{
    //获取openid
    NSString *access_token=[self parseText:@"access_token" fromHtmlString:str];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@",access_token]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil
                                                           error:nil];
    NSString *result = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    NSString *openid=[self parseText:@"openid" fromJsonString:result];
    
    //获取get_user_info
    [self getUserInfoWithAccessToken:access_token andOpenid:openid];
}

-(void)getUserInfoWithAccessToken:(NSString *)access_token andOpenid:(NSString*)openid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?oauth_consumer_key=%@&access_token=%@&openid=%@&format=json",QQ_APP_ID,access_token,openid]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:10];
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
    NSDictionary *root = [jsonParser objectWithString:result];
    NSLog(@"root=%@",root);
    
    [self loginQQ:access_token andOpenid:openid andUserInfo:root];
}

-(void)loginQQ:(NSString *)access_token andOpenid:(NSString*)openid andUserInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                               [[Singleton sharedInstance]TGC], @"TGC",
                               openid,@"open",
                               access_token,@"token",
                               [userInfo objectForKey:@"figureurl_qq_2"],@"head",
                               [userInfo objectForKey:@"nickname"],@"nickname",
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

- (NSString*)parseText:(NSString*)text fromHtmlString:(NSString*)str
{
    NSArray *arr=[str componentsSeparatedByString:@"&"];
    for (NSString *str in arr)
    {
        NSArray *list=[str componentsSeparatedByString:@"="];
        NSString *str0=[list objectAtIndex:0];
        NSString *str1=[list objectAtIndex:1];
        if ([str0 isEqualToString:text])
        {
            return str1;
        }
    }
    
    return @"";
}

- (NSString*)parseText:(NSString*)text fromJsonString:(NSString*)str
{
    SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
    NSDictionary *root = [jsonParser objectWithString:[str substringWithRange:NSMakeRange(9,str.length-12)]];
    NSString *openid=[root objectForKey:text];
    return openid;
}

@end
