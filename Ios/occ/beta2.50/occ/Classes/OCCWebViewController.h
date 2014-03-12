//
//  OCCWebViewController.h
//  occ
//
//  Created by zhangss on 13-9-16.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCCWebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong)NSDictionary *data;

@end
