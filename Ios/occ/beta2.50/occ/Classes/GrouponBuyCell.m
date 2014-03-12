//
//  GrouponBuyCell.m
//  occ
//
//  Created by plocc on 13-12-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponBuyCell.h"

@implementation GrouponBuyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImage *redImage = [UIImage imageNamed:@"btn_bg_red"];
        redImage=[redImage stretchableImageWithLeftCapWidth:redImage.size.width/2 topCapHeight:redImage.size.height/2];
        _redImage=redImage;
        
        UIImage *grayImage = [UIImage imageNamed:@"btn_bg_light_gray"];
        grayImage=[grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
        _grayImage=grayImage;
        
        _cartButton = [[UIButton alloc]init];
        [_cartButton setFrame:CGRectMake(0, 0, 250, 40)];
        [_cartButton setCenter:CGPointMake(SCREEN_WIDTH/2, _cartButton.center.y)];
        [_cartButton setBackgroundImage:redImage forState:UIControlStateNormal];
        [_cartButton addTarget:self action:@selector(addItemToCart:) forControlEvents:UIControlEventTouchUpInside];
        [_cartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [self.contentView addSubview:_cartButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [self setBackgroundView:nil];
    [super layoutSubviews];
}

- (void)addItemToCart:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO) {
        return;
    }
    
    [_delegate grouponBuyItem];
}

-(void)setData:(NSDictionary*)data
{
    if ([data objectForKey:@"stockNum"]!=nil&&[[data objectForKey:@"stockNum"]intValue]==0)
    {
        [_cartButton setTitleColor:COLOR_000000 forState:UIControlStateNormal];
        [_cartButton setBackgroundImage:_grayImage forState:UIControlStateNormal];
        [_cartButton setUserInteractionEnabled:NO];
        [_cartButton setTitle:@"卖光了" forState:UIControlStateNormal];
        return;
    }
    
    long nowTime=(long)[[NSDate date] timeIntervalSince1970];
    long startTime=[[data objectForKey:@"startDate"]longLongValue]/1000;
    long endTime=[[data objectForKey:@"endDate"]longLongValue]/1000;
    if (nowTime<startTime)
    {
        [_cartButton setTitleColor:COLOR_000000 forState:UIControlStateNormal];
        [_cartButton setBackgroundImage:_grayImage forState:UIControlStateNormal];
        [_cartButton setUserInteractionEnabled:NO];
        [_cartButton setTitle:@"即将开始" forState:UIControlStateNormal];
    }
    else if (nowTime>startTime && nowTime<endTime)
    {
        [_cartButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        [_cartButton setBackgroundImage:_redImage forState:UIControlStateNormal];
        [_cartButton setUserInteractionEnabled:YES];
        [_cartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    else
    {
        [_cartButton setTitleColor:COLOR_000000 forState:UIControlStateNormal];
        [_cartButton setBackgroundImage:_grayImage forState:UIControlStateNormal];
        [_cartButton setUserInteractionEnabled:NO];
        [_cartButton setTitle:@"团购已经结束" forState:UIControlStateNormal];
    }
}

-(float)getCellHeight
{
    return 44.0;
}

@end
