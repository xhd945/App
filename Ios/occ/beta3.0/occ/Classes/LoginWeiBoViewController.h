//
//  LoginWeiBoViewController.h
//  occ
//
//  Created by mac on 13-9-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginWeiBoViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    NSString *_detailURL;

}

@end
