//
//  OCCWebView.m
//  occ
//
//  Created by RS on 13-10-30.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCWebView.h"

@implementation OCCWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setOpaque:NO];
        [self setUserInteractionEnabled:YES];
        [self setScalesPageToFit:YES];
        
        //self.transform = CGAffineTransformMakeRotation(M_PI/2);
        //self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
        
        // 隐藏拖拽webview时上下的两个有阴影效果的subview
        for (UIView *subView in [self subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
        
        [(UIScrollView *)[[self subviews] objectAtIndex:0] setBounces:YES];
        [(UIScrollView *)[[self subviews] objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
        [(UIScrollView *)[[self subviews] objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
