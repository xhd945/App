//
//  LoginQQViewController.h
//  occ
//
//  Created by mac on 13-9-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoginQQType)
{
    LoginQQTypePC,  //PC网站
    LoginQQTypeWAP,  //WAP网站
};

@interface LoginQQViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    NSString *_detailURL;
    NSString *_token;
    NSString *_openID;
}

@property(nonatomic,assign) LoginQQType loginQQType;
@end
