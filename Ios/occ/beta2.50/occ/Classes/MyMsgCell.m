//
//  MsgCell.m
//  occ
//
//  Created by RS on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyMsgCell.h"

@implementation MyMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_EAEAEA];
        self.selectedBackgroundView=selectedBackgroundView;
        
        UIView *whiteImageView = [[UIView alloc]init];
        [whiteImageView setFrame:CGRectMake(10, 10, 65, 65)];
        [whiteImageView setBackgroundColor:COLOR_FFFFFF];
        [self addSubview:whiteImageView];
        _whiteImageView=whiteImageView;
        
        UIImageView *userImageVIew = [[UIImageView alloc]init];
        [userImageVIew setFrame:CGRectMake(5, 5, 55, 55)];
        [userImageVIew setImage:[UIImage imageNamed:@"person_bg"]];
        [userImageVIew setHighlightedImage:[UIImage imageNamed:@"person_bg"]];
        userImageVIew.layer.masksToBounds=YES;
        userImageVIew.layer.cornerRadius=5;
        [self.whiteImageView addSubview:userImageVIew];
        _userImageView=userImageVIew;
        
        UIImageView *typeImageView = [[UIImageView alloc]init];
        [typeImageView setFrame:CGRectZero];
        [typeImageView setImage:[UIImage imageNamed:@"notice_system"]];
        [self addSubview:typeImageView];
        _typeImageView=typeImageView;
        
        UIImageView *timeImageView = [[UIImageView alloc]init];
        [timeImageView setFrame:CGRectZero];
        [timeImageView setImage:[UIImage imageNamed:@"activity_time"]];
        [self addSubview:timeImageView];
        _timeImageView=timeImageView;
        
        UIImageView *arrowImageView = [[UIImageView alloc]init];
        [arrowImageView setFrame:CGRectZero];
        [arrowImageView setImage:[UIImage imageNamed:@"jiantou_right"]];
        [arrowImageView setHighlightedImage:[UIImage imageNamed:@"jiantou_right"]];
        [self addSubview:arrowImageView];
        _arrowImageView=arrowImageView;
        
        UILabel *nameLabel = [[UILabel alloc]init];
        [nameLabel setTextColor:COLOR_333333];
        [nameLabel setFont:FONT_14];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:[NSString stringWithFormat:@"某某某"]];
        [nameLabel setFrame:CGRectZero];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:nameLabel];
        _nameLabel=nameLabel;
        
        UILabel *timeLabel = [[UILabel alloc]init];
        [timeLabel setTextColor:COLOR_999999];
        [timeLabel setFont:FONT_12];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFrame:CGRectZero];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:timeLabel];
        _timeLabel=timeLabel;
        
        UILabel *descLabel = [[UILabel alloc]init];
        [descLabel setTextColor:COLOR_333333];
        [descLabel setFont:FONT_14];
        [descLabel setBackgroundColor:[UIColor clearColor]];
        [descLabel setFrame:CGRectZero];
        [descLabel setTextAlignment:NSTextAlignmentLeft];
        [descLabel setUserInteractionEnabled:NO];
        [descLabel setNumberOfLines:2];
        [self addSubview:descLabel];
        _descLabel=descLabel;
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
    
    [_whiteImageView setFrame:CGRectMake(10, 10, 60, 60)];
    [_userImageView setFrame:CGRectMake(2, 2, _whiteImageView.frame.size.width-4, _whiteImageView.frame.size.height-4)];
    
    [_timeLabel sizeToFit];
    [_timeLabel setFrame:CGRectMake(SCREEN_WIDTH-_timeLabel.frame.size.width-15,_whiteImageView.frame.origin.y, _timeLabel.frame.size.width, _timeLabel.frame.size.height)];
    [_timeImageView setFrame:CGRectMake(_timeLabel.frame.origin.x-14, _timeLabel.frame.origin.y+2, 11, 11)];
    
    [_nameLabel setFrame:CGRectMake(_whiteImageView.frame.origin.x+_whiteImageView.frame.size.width+10,
                                    _timeLabel.frame.origin.y+_timeLabel.frame.origin.y+5,
                                    SCREEN_WIDTH-70,
                                    20)];
    [_nameLabel sizeToFit];
    
    [_descLabel setFrame:CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y+_nameLabel.frame.size.height+5, SCREEN_WIDTH-_whiteImageView.frame.size.width-_whiteImageView.frame.origin.x-35, 60)];
    [_descLabel sizeToFit];
    
    [_arrowImageView setFrame:CGRectMake(SCREEN_WIDTH-25, _descLabel.frame.origin.y+2, 11, 11)];
    
    [_typeImageView setFrame:CGRectMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width, _nameLabel.frame.origin.y, 11, 11)];
}

-(void)setData:(NSDictionary*)data
{
    self.timeLabel.text=@"";
    if ([data objectForKey:@"createdDate"]!=nil) {
        self.timeLabel.text=[NSString stringWithFormat:@"%@",[data objectForKey:@"createdDate"]];
    }
    if ([data objectForKey:@"createDate"]!=nil) {
        self.timeLabel.text=[NSString stringWithFormat:@"%@",[data objectForKey:@"createDate"]];
    }
    
    @try {
        NSString *strURL  = [[data objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strURL];
        [self.userImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    @catch (NSException *exception) {
        
    }
    
    @try {
        self.nameLabel.text=[data objectForKey:@"sender"];
    }
    @catch (NSException *exception) {
        
    }
    
    
    self.descLabel.text=[data objectForKey:@"content"];
    
    int type=[[data objectForKey:@"type"]intValue];
    if (type==1) {
        [_typeImageView setImage:[UIImage imageNamed:@"notice_trade.png"]];
    }
    else if (type==2){
       [_typeImageView setImage:[UIImage imageNamed:@"notice_system.png"]];
    }
    else{
       [_typeImageView setImage:nil];
    }
}

@end
