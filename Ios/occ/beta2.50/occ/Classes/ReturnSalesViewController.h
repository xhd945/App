//
//  ReturnSalesViewController.h
//  occ
//
//  Created by mac on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnSalesViewController : UIViewController<UIWebViewDelegate>
@property(strong, nonatomic) NSString *tittle;
@property(strong, nonatomic) NSString *strContent;
@property(strong, nonatomic) UITextView *tvContent;
@property(strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIWebView *webView;

-(void)setData:(NSDictionary*)data;

@end
