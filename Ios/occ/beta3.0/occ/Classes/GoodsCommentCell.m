//
//  shopPingLunCell.m
//  occ
//
//  Created by mac on 13-9-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsCommentCell.h"

@implementation GoodsCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        _userNameLabel.textColor=COLOR_333333;
        _userNameLabel.backgroundColor=[UIColor clearColor];
        _userNameLabel.textAlignment=UITextAlignmentCenter;
        _userNameLabel.font=FONT_14;
        [self.contentView addSubview:_userNameLabel];
        
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 310, 50)];
        _contentLabel.font=FONT_14;
        _contentLabel.backgroundColor=[UIColor clearColor];
        _contentLabel.textColor=COLOR_333333;
        _contentLabel.numberOfLines=0;
        [self.contentView addSubview:_contentLabel];
        
        _propLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, 310, 30)];
        _propLabel.font=FONT_14;
        _propLabel.textColor=[UIColor grayColor];
        _propLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_propLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 110, 310, 30)];
        _timeLabel.textColor=COLOR_999999;
        _timeLabel.backgroundColor=[UIColor clearColor];
        _timeLabel.font=FONT_14;
        [self.contentView addSubview:_timeLabel];
        
        _ratingView=[[OCCRatingView alloc]init];
        [_ratingView setFrame:CGRectZero];
        [self.contentView addSubview:_ratingView];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundView:backgroundView];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        [self setSelectedBackgroundView:selectedBackgroundView];
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

- (void)setData:(NSDictionary *)data
{
    self.userNameLabel.text=[data objectForKey:@"nickname"];
    [self.ratingView setRating:[data objectForKey:@"evaluation"]];
    self.contentLabel.text=[data objectForKey:@"content"];
    self.propLabel.text=[data objectForKey:@"prop"];
    self.timeLabel.text=[data objectForKey:@"createdDate"];
    
    [_userNameLabel setFrame:CGRectMake(10, 10, 50, 30)];
    [_userNameLabel sizeToFit];
    [_ratingView setFrame:CGRectMake(_userNameLabel.frame.origin.x+_userNameLabel.frame.size.width+10, _userNameLabel.frame.origin.y, 100, 20)];
    [_contentLabel setFrame:CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.origin.y+_userNameLabel.frame.size.height+10, 300, 0)];
    [_contentLabel sizeToFit];
    [_propLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y+_contentLabel.frame.size.height+10, 300, 0)];
    [_propLabel sizeToFit];
    [_timeLabel setFrame:CGRectMake(_propLabel.frame.origin.x, _propLabel.frame.origin.y+_propLabel.frame.size.height+10, 300, 0)];
    [_timeLabel sizeToFit];
    
    self.height=(_timeLabel.frame.origin.y+_timeLabel.frame.size.height+10);
}

@end
