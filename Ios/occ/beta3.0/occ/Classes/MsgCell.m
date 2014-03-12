//
//  MsgCell.m
//  occ
//
//  Created by RS on 13-9-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MsgCell.h"

@implementation MsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];

        UIImage *image = [UIImage imageNamed:@"massge_bg_left"];
        _leftImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height* 4/5];
        image = [UIImage imageNamed:@"massge_bg_right"];
        _rightImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height* 4/5];
        
        image = [UIImage imageNamed:@"icon_message_yellowA"];
        _leftDotImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:2];
        image = [UIImage imageNamed:@"icon_message_greenB"];
        _rightDotImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:2];
        
        UIImageView *headImageView = [[UIImageView alloc]init];
        [headImageView setFrame:CGRectMake(0, 0, 32, 32)];
        [headImageView setImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypePortrait]];
        [self addSubview:headImageView];
        _headImageView=headImageView;
        
        UILabel *timeLabel = [[UILabel alloc]init];
        [timeLabel setTextColor:COLOR_999999];
        [timeLabel setFont:FONT_10];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFrame:CGRectZero];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:timeLabel];
        _timeLabel=timeLabel;
        
        UIImageView *timeImageView = [[UIImageView alloc]init];
        [timeImageView setFrame:CGRectZero];
        [timeImageView setImage:[UIImage imageNamed:@"bg_message_time"]];
        [timeLabel addSubview:timeImageView];
        _timeImageView=timeImageView;
        
        UIImageView *dotImageView = [[UIImageView alloc]init];
        [dotImageView setFrame:CGRectZero];
        [dotImageView setImage:[UIImage imageNamed:@"bg_message_time"]];
        [self addSubview:dotImageView];
        _dotImageView=dotImageView;
        
        UILabel *contentLabel = [[UILabel alloc]init];
        [contentLabel setTextColor:COLOR_333333];
        [contentLabel setFont:FONT_12];
        [contentLabel setNumberOfLines:0];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setText:[NSString stringWithFormat:@"总经理"]];
        [contentLabel setFrame:CGRectZero];
        [contentLabel setTextAlignment:NSTextAlignmentLeft];
        _contentLabel=contentLabel;
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_bgImageView];
        [_bgImageView addSubview:contentLabel];
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

    switch (self.type)
    {
        case MsgFormatType1:
        {
            _dotImageView.frame=CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width/2-5, _headImageView.frame.origin.y+_headImageView.frame.size.height, 10, self.contentView.frame.size.height*10);
        }
            break;
        case MsgFormatType2:
        {
            _dotImageView.frame=CGRectZero;
        }
            break;
        case MsgFormatType3:
        {
            _dotImageView.frame=CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width/2-5, _headImageView.frame.origin.y+_headImageView.frame.size.height, 10, self.contentView.frame.size.height*10);
        }
            break;
        case MsgFormatType4:
        {
            _dotImageView.frame=CGRectZero;
        }
            break;
        case MsgFormatType5:
        {
            _dotImageView.frame=CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width/2-5, 0, 10, self.contentView.frame.size.height*10);
        }
            break;
        case MsgFormatType6:
        {
            _dotImageView.frame=CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width/2-5, 0, 10, self.contentView.frame.size.height/2+5);
        }
            break;
        default:
            break;
    }
}

-(void)setData:(NSDictionary*)data
{
    float y=0.0;
    switch (self.type)
    {
        case MsgFormatType1:
        case MsgFormatType2:
        {
            _timeLabel.hidden=NO;
            _headImageView.hidden=NO;
            y=25.0;
        }
            break;
        case MsgFormatType3:
        case MsgFormatType4:
        {
            _timeLabel.hidden=YES;
            _headImageView.hidden=NO;
            y=5.0;
        }
            break;
        case MsgFormatType5:
        case MsgFormatType6:
        {
            _timeLabel.hidden=YES;
            _headImageView.hidden=YES;
            y=5.0;
        }
            break;
        default:
            break;
    }
    
    if ( [data objectForKey:@"userIcon"]!=nil)
    {
        NSString *strURL = [data objectForKey:@"userIcon"];
        NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.headImageView setImageWithURL:url
                           placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    
    NSString *time=[NSString stringWithFormat:@"(%@)",[data objectForKey:@"createDate"]];
    [_timeLabel setText:time];
    [_timeLabel sizeToFit];
    _timeLabel.frame=CGRectMake(0,5, SCREEN_WIDTH, _timeLabel.frame.size.height);
    _timeImageView.frame=CGRectMake(0,_timeLabel.frame.size.height/2,  _timeLabel.frame.size.width, 2);

    int type=[[data objectForKey:@"type"]intValue];
    BOOL isLeft=(type==0?NO:YES);
    if (isLeft)
    {
        _bgImageView.image = _leftImage;
        NSString *content = [data objectForKey:@"content"];
        CGSize sizeToFit = [content sizeWithFont:_contentLabel.font constrainedToSize:CGSizeMake(230, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        [_contentLabel setText:content];
        [_contentLabel setFrame:CGRectMake(10,5,sizeToFit.width,sizeToFit.height)];
        CGRect selfRect = _bgImageView.frame;
        selfRect.size.width = _contentLabel.frame.size.width + 20;
        selfRect.size.height = _contentLabel.frame.size.height + 10;
        selfRect.origin.x = 50.0;
        selfRect.origin.y = y;
        _bgImageView.frame = selfRect;
        
        _headImageView.frame=CGRectMake(10, _bgImageView.frame.origin.y, 32, 32);
        
        _dotImageView.image=_leftDotImage;
    }
    else
    {
        _bgImageView.image = _rightImage;
        NSString *content = [data objectForKey:@"content"];
        CGSize sizeToFit = [content sizeWithFont:_contentLabel.font constrainedToSize:CGSizeMake(230, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        [_contentLabel setText:content];
        [_contentLabel setFrame:CGRectMake(10,5,sizeToFit.width,sizeToFit.height)];
        CGRect selfRect = _bgImageView.frame;
        selfRect.size.width = _contentLabel.frame.size.width + 20;
        selfRect.size.height = _contentLabel.frame.size.height + 10;
        selfRect.origin.x = 270-selfRect.size.width;
        selfRect.origin.y = y;
        _bgImageView.frame = selfRect;
        
        _headImageView.frame=CGRectMake(320-10-32, _bgImageView.frame.origin.y, 32, 32);
        
        _dotImageView.image=_rightDotImage;
    }
}

+(float)getCellHeight:(NSDictionary*)data andType:(MsgFormatType)type
{
    //return MAX(70,height+50);
    NSString *content=[data objectForKey:@"content"];
    int height=[CommonMethods heightForString:content andFont:FONT_12 andWidth:MAX_MSG_WIDTH];
    
    switch (type)
    {
        case MsgFormatType1:
        case MsgFormatType2:
        {
            return MAX(60,height+40);
        }
            break;
        case MsgFormatType3:
        case MsgFormatType4:
        case MsgFormatType5:
        case MsgFormatType6:
        {
            return MAX(40,height+20);
        }
            break;
        default:
            break;
    }
    
    return 0.0;
}

@end
