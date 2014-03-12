//
//  OCCWaitingView.h
//  occ
//
//  Created by zhangss on 13-9-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface OCCWaitingView : UIView
{
    MBProgressHUD *_progressHUD;
    MBProgressHUD *_autoDisMissHUD;
}

- (void)showWaitView:(NSString *)showStr;
- (void)hideWaitView;
- (void)showAutoDismissView:(NSString*)showStr inView:(UIView *)aView;

@end
