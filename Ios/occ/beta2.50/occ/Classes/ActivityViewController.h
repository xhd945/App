//
//  ActivityViewController.h
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCAttributedLabel.h"

@interface ActivityViewController : UIViewController <UIWebViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *activityImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UILabel *ownerLabel;
@property(nonatomic,strong) OCCAttributedLabel *tipLabel;
@property(nonatomic,strong) OCCWebView *webView;

@property(nonatomic,strong)NSDictionary *data;

-(void)setData:(NSDictionary*)data;
@end
