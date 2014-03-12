//
//  ReturnSalesViewController.m
//  occ
//
//  Created by mac on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#define KEY_TITLE   @"title"
#define KEY_VALUE   @"value"

#import "ReturnSalesViewController.h"

@interface ReturnSalesViewController ()

@end

@implementation ReturnSalesViewController

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
    UIImageView *backGroundImgv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backGroundImgv.backgroundColor=COLOR_BG_CLASSONE;
    [self.view addSubview:backGroundImgv];
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"%@",[_data objectForKey:@"name"]]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    // webview
    OCCWebView *webView = [[OCCWebView alloc]init];
    [webView setFrame:CGRectMake(0, HEADER_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT-HEADER_HEIGHT)];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    [webView setDelegate:self];
    [webView setUserInteractionEnabled:YES];
    [webView setScalesPageToFit:YES];
    [self.view addSubview:webView];
    _webView=webView;
    webView.scrollView.zoomScale=1.0;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    [activityIndicatorView setFrame:CGRectMake(0, 20.0f, 32.0f, 32.0f)];
    [activityIndicatorView setCenter:CGPointMake(SCREEN_WIDTH/2, 100)];
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView setHidesWhenStopped:YES];
    [activityIndicatorView setColor:[UIColor blackColor]];
    [self.webView addSubview:activityIndicatorView];
    _activityIndicatorView=activityIndicatorView;
    
    [self toWeb];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate method
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicatorView stopAnimating];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"IncreaseZoomFactor" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
    [webView stringByEvaluatingJavaScriptFromString:@"increaseMaxZoomFactor()"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)toWeb
{
    NSURL *url =[NSURL URLWithString:[_data objectForKey:@"url"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(void)setData:(NSDictionary*)data
{
    _data=data;
}

@end
