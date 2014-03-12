//
//  Home3Cell.m
//  occ
//
//  Created by RS on 13-8-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Home3Cell.h"

@implementation Home3Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170.0)];
        _csView.delegate = self;
        _csView.datasource = self;
        [self.contentView addSubview:_csView];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 170.0);

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
}

-(void)setData:(AdvertisementSeat *)data
{
    _dataArray = [NSArray arrayWithArray:data.adList];
    [_csView reloadData];
}

- (NSInteger)numberOfPages
{
    return [_dataArray count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    Advertisement *adver = [_dataArray objectAtIndex:index];
    NSString *imageUrlStr = adver.adImageUrl;
    UIImageView *imageView=[[UIImageView alloc]init];
    [imageView setFrame:CGRectMake(0, 2, 320, 165)];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    return imageView;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(circleAdverTaped:)])
    {
        [_delegate circleAdverTaped:[_dataArray objectAtIndex:index]];
    }
}

-(void)changeImage
{
    [_csView cycleView];
}

@end
