//
//  DetailWebViewController.h
//  occ
//
//  Created by RS on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailWebViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString *detailURL;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UILabel *titleLable;

@end
