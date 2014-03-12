//
//  OCCCartButton.m
//  occ
//
//  Created by plocc on 13-12-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCCartButton.h"

@implementation OCCCartButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        self.frame=CGRectMake(0, 0, 50, 50);
        UIImage *grayImage = [UIImage imageNamed:@"btn_bg_gray"];
        grayImage=[grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];

        //[self setImage:[UIImage imageNamed:@"btn_shopcar_white"] forState:UIControlStateNormal];
        //[self setBackgroundImage:grayImage forState:UIControlStateNormal];
        [self setBackgroundColor:COLOR_5F5E5D];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        [self setAlpha:1.0];
        
        _bgImageView=[[UIImageView alloc]init];
        _bgImageView.frame=CGRectMake(5, 10, 40, 40);
        _bgImageView.image=[UIImage imageNamed:@"btn_shopcar_white"];
        [self addSubview:_bgImageView];
        
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_badgeLabel setFont:FONT_12];
        [_badgeLabel setTextColor:COLOR_FFFFFF];
        [_badgeLabel setBackgroundColor:COLOR_DA6432];
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
        _badgeLabel.text = countStr;
        [_badgeLabel sizeToFit];
        _badgeLabel.frame = CGRectMake(0, 0, _badgeLabel.frame.size.width+8, _badgeLabel.frame.size.height);
        _badgeLabel.center=CGPointMake(self.frame.size.width/2, 10);
        //CGSize countSzie = [countStr sizeWithFont:_badgeLabel.font];
        //CGRect selfRect = _badgeLabel.frame;
        //selfRect.size = CGSizeMake(countSzie.width + 8, countSzie.height);
        //selfRect.origin.x = (self.frame.size.width - selfRect.size.width)/2;
    }
    else
    {
        _badgeLabel.hidden = YES;
    }
}

@end
