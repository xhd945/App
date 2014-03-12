//
//  OCCNormalTableView.m
//  occ
//
//  Created by RS on 13-11-28.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCNormalTableView.h"

@implementation OCCNormalTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;

        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self setSeparatorInset:UIEdgeInsetsZero];
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
