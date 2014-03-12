//
//  Home1Cell.m
//  occ
//
//  Created by RS on 13-8-20.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Home1Cell.h"

#define kSingleAdverHeight 180

@implementation Home1Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        //ImageView
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_fullImageView];
        
        //点击事件
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        [_button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    }
    return self;
}

-(void)setData:(AdvertisementSeat *)seat
{
    _adSeat = seat;
    NSArray *array = seat.adList;
    if ([array count] > 0)
    {
        Advertisement *adver = [array objectAtIndex:0];
        NSString *imageURL = adver.adImageUrl;
        NSInteger imageWidth = [seat.seatWidth integerValue];
        NSInteger imageHeight = [seat.seatHeight integerValue];
        if (imageWidth >= 300)
        {
            imageHeight = 300 * imageHeight / imageWidth;
            imageWidth = 300;
        }
        self.fullImageView.frame = CGRectMake(10, 0, imageWidth, imageHeight);
        [self.fullImageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
        
        _button.frame = self.fullImageView.frame;
        
        CGRect selfRect = self.frame;
        selfRect.size.height = self.fullImageView.frame.size.height + 10;
        self.frame = selfRect;
    }
}

- (void)buttonTap:(id)sender
{
    //广告点击事件
    if ([_delegate respondsToSelector:@selector(singleAdverTaped:)])
    {
        NSArray *array = _adSeat.adList;
        if ([array count]>0)
        {
            Advertisement *adver = [array objectAtIndex:0];
            [_delegate singleAdverTaped:adver];
        }
    }
}

@end
