//
//  Home2Cell.m
//  occ
//
//  Created by RS on 13-8-20.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Home2Cell.h"

@implementation Home2Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_leftImageView];
        
        _leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_leftButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leftButton];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_rightImageView];
        
        _rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightButton];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.leftImageView setFrame:CGRectMake(10, 5, 145, 166)];
    [self.rightImageView setFrame:CGRectMake(165, 5, 145, 166)];
    self.leftButton.frame = self.leftImageView.frame;
    self.rightButton.frame = self.rightImageView.frame;
}

-(void)setData:(AdvertisementSeat *)tempSeat
{
    _adSeat = tempSeat;
    NSArray *array = tempSeat.adList;
    if ([array count] >= 2)
    {
        Advertisement *leftAdver = [array objectAtIndex:0];
        Advertisement *rightAdver = [array objectAtIndex:1];
        NSString *imageURLStringLeft = leftAdver.adImageUrl;
        NSString *imageURLStringright = rightAdver.adImageUrl;
        [_leftImageView setImageWithURL:[NSURL URLWithString:imageURLStringLeft] placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
        [_rightImageView setImageWithURL:[NSURL URLWithString:imageURLStringright] placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
}

- (void)buttonTap:(id)sender
{
    UIButton *tapedBtn = (UIButton *)sender;
    Advertisement *tempAdver = nil;
    if (tapedBtn == _leftButton)
    {
        tempAdver = [_adSeat.adList objectAtIndex:0];
    }
    else
    {
        tempAdver = [_adSeat.adList objectAtIndex:1];
    }
    
    if ([_delegate respondsToSelector:@selector(doubleAdverTaped:)])
    {
        [_delegate doubleAdverTaped:tempAdver];
    }
}

@end
