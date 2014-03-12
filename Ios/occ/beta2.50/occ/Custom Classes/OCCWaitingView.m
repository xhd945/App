//
//  OCCWaitingView.m
//  occ
//
//  Created by zhangss on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCWaitingView.h"

@implementation OCCWaitingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _progressHUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD];
    }
    return self;
}

- (void)showWaitView:(NSString *)showStr
{
    if (showStr == nil || [showStr length] < 1)
    {
        showStr = NSLocalizedString(@"正在请求中,请稍候...",nil);
    }
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_progressHUD];
    _progressHUD.detailsLabelText = showStr;
    _progressHUD.yOffset=-80;
    [_progressHUD show:YES];
}

- (void)hideWaitView
{
    [_progressHUD hide:NO];
}

- (void)showAutoDismissView:(NSString*)showStr inView:(UIView *)aView
{
    if (showStr == nil || [showStr length] < 1)
    {
        return;
    }
    if (_autoDisMissHUD != nil)
    {
        [_autoDisMissHUD removeFromSuperview];
        _autoDisMissHUD = nil;
    }
    
    if (aView)
    {
        _autoDisMissHUD = [[MBProgressHUD alloc] initWithView:aView];
        [aView addSubview:_autoDisMissHUD];
    }
    else
    {
        _autoDisMissHUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:_autoDisMissHUD];
    }
    
    _autoDisMissHUD.frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    _autoDisMissHUD.removeFromSuperViewOnHide = YES;
    _autoDisMissHUD.mode = MBProgressHUDModeText;
    _autoDisMissHUD.yOffset=-80;
    _autoDisMissHUD.detailsLabelText = showStr;
    [_autoDisMissHUD show:YES];
    
    [_autoDisMissHUD hide:YES afterDelay:1.0f];
}

@end
