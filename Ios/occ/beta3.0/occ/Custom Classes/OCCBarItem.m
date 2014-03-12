//
//  OCCBarItem.m
//  occ
//
//  Created by zhangss on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCBarItem.h"

@implementation OCCBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - HEADER_HEIGHT/2)/2, 10, HEADER_HEIGHT/2, HEADER_HEIGHT/2)];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frame.size.width, 11)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = UITextAlignmentCenter;
        _nameLabel.font = FONT_10;
        [self addSubview:_nameLabel];
        
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 18, 12)];
        [_badgeLabel setFont:FONT_10];
        [_badgeLabel setTextColor:COLOR_FFFFFF];
        [_badgeLabel setBackgroundColor:COLOR_DA6432];
        [_badgeLabel setTextAlignment:NSTextAlignmentCenter];
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.layer.cornerRadius = 6;
        _badgeLabel.hidden = YES;
        [self addSubview:_badgeLabel];
        
        //Default Color
        _titleColor = COLOR_FFFFFF;
        _titleSelectedColor = COLOR_FFFFFF;

        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)isSelected
{
    _nameLabel.text = _title;
    if (isSelected)
    {
        _imageView.image = _selectedImage;
        _nameLabel.textColor = _titleSelectedColor;
    }
    else
    {
        _imageView.image = _normalImage;
        _nameLabel.textColor = _titleColor;
    }
}

- (void)setUnReadCount:(NSInteger)count
{    
    if (count > 0)
    {
        _badgeLabel.hidden = NO;
        NSString *countStr = [NSString stringWithFormat:@"%d",count];
        CGSize countSzie = [countStr sizeWithFont:_badgeLabel.font];
        CGRect selfRect = _badgeLabel.frame;
        selfRect.size = CGSizeMake(countSzie.width + 8, countSzie.height);
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
