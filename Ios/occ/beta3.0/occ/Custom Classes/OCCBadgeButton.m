//
//  OCCOrderButton.m
//  occ
//
//  Created by plocc on 13-12-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCBadgeButton.h"

@implementation OCCBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 18, 12)];
        [_badgeLabel setFont:FONT_12];
        [_badgeLabel setTextColor:COLOR_FFFFFF];
        [_badgeLabel setBackgroundColor:COLOR_FAB731];
        [_badgeLabel setTextAlignment:NSTextAlignmentCenter];
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.layer.cornerRadius = 6;
        _badgeLabel.hidden = YES;
        [self addSubview:_badgeLabel];
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

- (void)setCount:(NSInteger)count
{
    if (count > 0)
    {
        _badgeLabel.hidden = NO;
        NSString *countStr = [NSString stringWithFormat:@"%d",count];
        CGSize countSzie = [countStr sizeWithFont:_badgeLabel.font];
        CGRect selfRect = _badgeLabel.frame;
        selfRect.size = CGSizeMake(countSzie.width + 16, countSzie.height);
        selfRect.origin.x = self.frame.size.width - selfRect.size.width - 5;
        _badgeLabel.frame = selfRect;
        _badgeLabel.text = countStr;
    }
    else
    {
        _badgeLabel.hidden = YES;
    }
}

@end
