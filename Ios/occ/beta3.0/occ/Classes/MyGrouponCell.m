//
//  CouponCell.m
//  occ
//
//  Created by RS on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyGrouponCell.h"

@implementation MyGrouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        [nameLabel setTextColor:COLOR_333333];
        [nameLabel setFont:FONT_14];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:[NSString stringWithFormat:@""]];
        [nameLabel setFrame:CGRectZero];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setNumberOfLines:2];
        [self addSubview:nameLabel];
        _nameLabel=nameLabel;
        
        UILabel *codeLabel = [[UILabel alloc]init];
        [codeLabel setTextColor:COLOR_333333];
        [codeLabel setFont:FONT_14];
        [codeLabel setBackgroundColor:[UIColor clearColor]];
        [codeLabel setText:[NSString stringWithFormat:@""]];
        [codeLabel setFrame:CGRectZero];
        [codeLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:codeLabel];
        _codeLabel=codeLabel;
        
        UILabel *timeLabel = [[UILabel alloc]init];
        [timeLabel setTextColor:COLOR_999999];
        [timeLabel setFont:FONT_12];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setText:[NSString stringWithFormat:@""]];
        [timeLabel setFrame:CGRectZero];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:timeLabel];
        _timeLabel=timeLabel;
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
    [_timeLabel setFrame:CGRectMake(20,5, SCREEN_WIDTH-40, 20)];
    [_timeLabel sizeToFit];
    [_codeLabel setFrame:CGRectMake(20,_timeLabel.frame.origin.y+_timeLabel.frame.size.height, SCREEN_WIDTH-40, 20)];
    [_codeLabel sizeToFit];
    [_nameLabel setFrame:CGRectMake(20,_codeLabel.frame.origin.y+_codeLabel.frame.size.height, SCREEN_WIDTH-40, 20)];
    [_nameLabel sizeToFit];
}

-(void)setData:(NSDictionary*)data
{
    NSString *updateTime=[data objectForKey:@"updateDate"];
    NSString *limitTime=[data objectForKey:@"limitTime"];
    if (updateTime!=nil&&[updateTime length]>0)
    {
        [_timeLabel setText:[NSString stringWithFormat:@"使用时间:%@",updateTime]];
    }
    else if (limitTime!=nil)
    {
        [_timeLabel setText:[NSString stringWithFormat:@"有效时间:%@",limitTime]];
    }
    else
    {
        [_timeLabel setText:@""];
    }
    
    NSString *grouponTicketCode=[data objectForKey:@"grouponTicketCode"];
    if (grouponTicketCode!=nil)
    {
        [_codeLabel setText:[NSString stringWithFormat:@"券码:%@",grouponTicketCode]];
    }
    
    if ([data objectForKey:@"grouponName"]!=nil)
    {
        [_nameLabel setText:[data objectForKey:@"grouponName"]];
    }
    else
    {
        [_nameLabel setText:[data objectForKey:@"name"]];
    }
}

@end
