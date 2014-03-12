//
//  OCCButton.m
//  occ
//
//  Created by RS on 13-8-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCButton.h"

@implementation OCCButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)setData:(NSDictionary *)data
{
    _data = [[NSDictionary alloc]initWithDictionary:data];
}

@end
