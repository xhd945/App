//
//  OCCSearchBar.m
//  occ
//
//  Created by RS on 13-10-28.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCSearchBar.h"

@implementation OCCSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.showsCancelButton = NO;
        self.barStyle=UIBarStyleDefault;
        self.placeholder=@"搜索";
        self.text=@"";
        self.keyboardType=UIKeyboardTypeNamePhonePad;
        [self setTintColor:COLOR_FFFFFF];
        
        if ([self respondsToSelector: @selector (barTintColor)])
        {
            [self  setBarTintColor:[UIColor clearColor]];
        }
        
        for (UIView *subview in self.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
                break;
            }
        }
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
