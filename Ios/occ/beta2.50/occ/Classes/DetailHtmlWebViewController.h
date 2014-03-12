//
//  DetailHtmlWebViewController.h
//  occ
//
//  Created by plocc on 13-12-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHtmlWebViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString *detailURL;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UILabel *titleLable;

@end
