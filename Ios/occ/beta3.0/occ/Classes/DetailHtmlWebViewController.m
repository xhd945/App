//
//  DetailHtmlWebViewController.m
//  occ
//
//  Created by plocc on 13-12-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "DetailHtmlWebViewController.h"

@implementation DetailHtmlWebViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor=COLOR_BG_CLASSONE;
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2*HEADER_HEIGHT)];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:@"详情"];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    _titleLable=titleLable;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [_webView loadHTMLString:_detailURL baseURL:nil];
}

@end
