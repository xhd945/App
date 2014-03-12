//
//  OrderNoCell.m
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OrderNoCell.h"

@implementation OrderNoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _orderNoLabel=[[UILabel alloc]init];
        [_orderNoLabel setText:@"订单号:"];
        [_orderNoLabel setTextColor:COLOR_999999];
        [_orderNoLabel setHighlightedTextColor:COLOR_999999];
        [_orderNoLabel setBackgroundColor:[UIColor clearColor]];
        [_orderNoLabel setFont:FONT_12];
        [self.contentView addSubview:_orderNoLabel];
        
        _alipayNoLabel=[[UILabel alloc]init];
        [_alipayNoLabel setText:@"支付宝订单号:"];
        [_alipayNoLabel setTextColor:COLOR_999999];
        [_alipayNoLabel setHighlightedTextColor:COLOR_999999];
        [_alipayNoLabel setBackgroundColor:[UIColor clearColor]];
        [_alipayNoLabel setFont:FONT_12];
        //[self.contentView addSubview:_alipayNoLabel];
        
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setText:@"收货时间:"];
        [_timeLabel setTextColor:COLOR_999999];
        [_timeLabel setHighlightedTextColor:COLOR_999999];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:FONT_12];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    _orderNoLabel.frame=CGRectMake(20, 10, SCREEN_WIDTH, 20);
    _alipayNoLabel.frame=CGRectMake(20, 30, SCREEN_WIDTH, 20);
    _timeLabel.frame=CGRectMake(20, 50, SCREEN_WIDTH, 20);
}

-(void)setData:(NSMutableDictionary*)data
{
    NSString *orderNo=[NSString stringWithFormat:@"订单号:%@",[data objectForKey:@"orderNo"]];
    [_orderNoLabel setText:orderNo];
    
    NSString *payNo=[NSString stringWithFormat:@"支付宝订单号:%@",[data objectForKey:@"payNo"]];
    [_alipayNoLabel setText:payNo];
    
    NSString *receivedTime=[NSString stringWithFormat:@"收货时间:%@",[data objectForKey:@"receivedTime"]];
    [_timeLabel setText:receivedTime];
}

@end
