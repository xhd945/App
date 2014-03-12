//
//  YouhuiCell.m
//  occ
//
//  Created by RS on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyCouponCell.h"

@implementation MyCouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *leftImageView = [[UIImageView alloc]init];
        [leftImageView setFrame:CGRectZero];
        [leftImageView setImage:[UIImage imageNamed:@"coupon_bg1"]];
        [leftImageView setHighlightedImage:[UIImage imageNamed:@"coupon_bg1"]];
        leftImageView.clipsToBounds=YES;
        leftImageView.userInteractionEnabled=YES;
        [self addSubview:leftImageView];
        _leftImageView=leftImageView;
        
        UILabel *leftRangeLabel = [[UILabel alloc]init];
        [leftRangeLabel setTextColor:COLOR_333333];
        [leftRangeLabel setFont:FONT_18];
        [leftRangeLabel setBackgroundColor:[UIColor clearColor]];
        [leftRangeLabel setText:@""];
        [leftRangeLabel setNumberOfLines:2];
        [leftRangeLabel setFrame:CGRectZero];
        [leftRangeLabel setTextAlignment:NSTextAlignmentCenter];
        [leftImageView addSubview:leftRangeLabel];
        _leftRangeLabel=leftRangeLabel;
        
        UILabel *leftTimeLabel = [[UILabel alloc]init];
        [leftTimeLabel setTextColor:COLOR_333333];
        [leftTimeLabel setFont:FONT_14];
        [leftTimeLabel setBackgroundColor:[UIColor clearColor]];
        [leftTimeLabel setText:@""];
        [leftTimeLabel setNumberOfLines:2];
        [leftTimeLabel setFrame:CGRectZero];
        [leftTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [leftImageView addSubview:leftTimeLabel];
        _leftTimeLabel=leftTimeLabel;
        
        UILabel *leftNameLabel = [[UILabel alloc]init];
        [leftNameLabel setTextColor:COLOR_FFFFFF];
        [leftNameLabel setFont:FONT_18];
        [leftNameLabel setBackgroundColor:[UIColor clearColor]];
        [leftNameLabel setText:@""];
        [leftNameLabel setNumberOfLines:2];
        [leftNameLabel setFrame:CGRectZero];
        [leftNameLabel setTextAlignment:NSTextAlignmentCenter];
        [leftImageView addSubview:leftNameLabel];
        _leftNameLabel=leftNameLabel;
        
        UILabel *leftPriceLabel = [[UILabel alloc]init];
        [leftPriceLabel setTextColor:COLOR_FFFFFF];
        [leftPriceLabel setFont:FONT_30];
        [leftPriceLabel setBackgroundColor:[UIColor clearColor]];
        [leftPriceLabel setText:@""];
        [leftPriceLabel setFrame:CGRectZero];
        [leftPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [leftImageView addSubview:leftPriceLabel];
        _leftPriceLabel=leftPriceLabel;
        
        UILabel *leftDescLabel = [[UILabel alloc]init];
        [leftDescLabel setTextColor:COLOR_FFFFFF];
        [leftDescLabel setFont:FONT_14];
        [leftDescLabel setBackgroundColor:[UIColor clearColor]];
        [leftDescLabel setText:@""];
        [leftDescLabel setNumberOfLines:2];
        [leftDescLabel setFrame:CGRectZero];
        [leftDescLabel setTextAlignment:NSTextAlignmentCenter];
        [leftImageView addSubview:leftDescLabel];
        _leftDescLabel=leftDescLabel;
        
        UIButton *leftButton = [[UIButton alloc]init];
        [leftButton setFrame:CGRectZero];
        [leftButton setBackgroundImage:[[UIImage imageNamed:@"btn_orange.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(doUse:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.titleLabel.font = FONT_14;
        [leftButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        [leftButton setTitle:@"立即使用" forState:UIControlStateNormal];
        [leftImageView addSubview:leftButton];
        leftButton.enabled = NO;
        _leftButton=leftButton;
        
        //=======================================================
        UIImageView *rightImageView = [[UIImageView alloc]init];
        [rightImageView setFrame:CGRectZero];
        [rightImageView setImage:[UIImage imageNamed:@"coupon_bg2"]];
        [rightImageView setHighlightedImage:[UIImage imageNamed:@"coupon_bg2"]];
        rightImageView.clipsToBounds=YES;
        rightImageView.userInteractionEnabled=YES;
        [self addSubview:rightImageView];
        _rightImageView=rightImageView;
        
        UILabel *rightRangeLabel = [[UILabel alloc]init];
        [rightRangeLabel setTextColor:COLOR_333333];
        [rightRangeLabel setFont:FONT_18];
        [rightRangeLabel setBackgroundColor:[UIColor clearColor]];
        [rightRangeLabel setText:@""];
        [rightRangeLabel setNumberOfLines:2];
        [rightRangeLabel setFrame:CGRectZero];
        [rightRangeLabel setTextAlignment:NSTextAlignmentCenter];
        [rightImageView addSubview:rightRangeLabel];
        _rightRangeLabel=rightRangeLabel;
        
        UILabel *rightTimeLabel = [[UILabel alloc]init];
        [rightTimeLabel setTextColor:COLOR_333333];
        [rightTimeLabel setFont:FONT_14];
        [rightTimeLabel setBackgroundColor:[UIColor clearColor]];
        [rightTimeLabel setText:@""];
        [rightTimeLabel setNumberOfLines:2];
        [rightTimeLabel setFrame:CGRectZero];
        [rightTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [rightImageView addSubview:rightTimeLabel];
        _rightTimeLabel=rightTimeLabel;
        
        UILabel *rightNameLabel = [[UILabel alloc]init];
        [rightNameLabel setTextColor:COLOR_FFFFFF];
        [rightNameLabel setFont:FONT_18];
        [rightNameLabel setBackgroundColor:[UIColor clearColor]];
        [rightNameLabel setText:@""];
        [rightNameLabel setNumberOfLines:2];
        [rightNameLabel setFrame:CGRectZero];
        [rightNameLabel setTextAlignment:NSTextAlignmentCenter];
        [rightImageView addSubview:rightNameLabel];
        _rightNameLabel=rightNameLabel;
        
        UILabel *rightPriceLabel = [[UILabel alloc]init];
        [rightPriceLabel setTextColor:COLOR_FFFFFF];
        [rightPriceLabel setFont:FONT_30];
        [rightPriceLabel setBackgroundColor:[UIColor clearColor]];
        [rightPriceLabel setText:@""];
        [rightPriceLabel setFrame:CGRectZero];
        [rightPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [rightImageView addSubview:rightPriceLabel];
        _rightPriceLabel=rightPriceLabel;
        
        UILabel *rightDescLabel = [[UILabel alloc]init];
        [rightDescLabel setTextColor:COLOR_FFFFFF];
        [rightDescLabel setFont:FONT_14];
        [rightDescLabel setBackgroundColor:[UIColor clearColor]];
        [rightDescLabel setText:@""];
        [rightDescLabel setNumberOfLines:2];
        [rightDescLabel setFrame:CGRectZero];
        [rightDescLabel setTextAlignment:NSTextAlignmentCenter];
        [rightImageView addSubview:rightDescLabel];
        _rightDescLabel=rightDescLabel;
        
        UIButton *rightButton = [[UIButton alloc]init];
        [rightButton setFrame:CGRectZero];
        [rightButton setBackgroundImage:[[UIImage imageNamed:@"btn_orange.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(doUse:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.titleLabel.font = FONT_14;
        [rightButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        [rightButton setTitle:@"立即使用" forState:UIControlStateNormal];
        [rightImageView addSubview:rightButton];
        rightButton.enabled = NO;
        _rightButton=rightButton;
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
    [_leftImageView setFrame:CGRectMake(10,10, 145, 213)];
    [_leftRangeLabel setFrame:CGRectMake(0,10, _leftImageView.frame.size.width, 20)];
    [_leftNameLabel setFrame:CGRectMake(0,30, _leftImageView.frame.size.width, 20)];
    [_leftPriceLabel setFrame:CGRectMake(0,50, _leftImageView.frame.size.width, 44)];
    [_leftDescLabel setFrame:CGRectMake(0,90, _leftImageView.frame.size.width, 44)];
    [_leftTimeLabel setFrame:CGRectMake(0,135, _leftImageView.frame.size.width, 44)];
    [_leftButton setFrame:CGRectMake(0,0, 80, 44)];
    [_leftButton setCenter:CGPointMake(_leftImageView.frame.size.width/2, 190)];
    
    [_rightImageView setFrame:CGRectOffset(_leftImageView.frame, 155, 0)];
    [_rightRangeLabel setFrame:_leftRangeLabel.frame];
    [_rightNameLabel setFrame:_leftNameLabel.frame];
    [_rightPriceLabel setFrame:_leftPriceLabel.frame];
    [_rightDescLabel setFrame:_leftDescLabel.frame];
    [_rightTimeLabel setFrame:_leftTimeLabel.frame];
    [_rightButton setFrame:_leftButton.frame];
}

-(void)setData1:(NSDictionary*)data
{
    if (data==nil) {
        _leftImageView.hidden=YES;
    }else{
        _leftImageView.hidden=NO;
        [_leftRangeLabel setText:[data objectForKey:@"range"]];
        //[_leftNameLabel setText:[data objectForKey:@"shopName"]];
        [_leftPriceLabel setText:[NSString stringWithFormat:@"￥%d",[[data objectForKey:@"price"]intValue]]];
        [_leftTimeLabel setText:[data objectForKey:@"limitTime"]];
        [_leftDescLabel setText:[data objectForKey:@"prop"]];
        int type=[[data objectForKey:@"stat"]intValue];
        if (type==1) {
            [_leftButton setTitle:@"已用" forState:UIControlStateNormal];
        }
        else if (type==2) {
           [_leftButton setTitle:@"可用" forState:UIControlStateNormal]; 
        }
        else if (type==3) {
            [_leftButton setTitle:@"已过期" forState:UIControlStateNormal];
        }
    }
}

-(void)setData2:(NSDictionary*)data
{
    if (data==nil) {
        _rightImageView.hidden=YES;
    }else{
        _rightImageView.hidden=NO;
        [_rightRangeLabel setText:[data objectForKey:@"range"]];
        //[_rightNameLabel setText:[data objectForKey:@"shopName"]];
        [_rightPriceLabel setText:[NSString stringWithFormat:@"￥%d",[[data objectForKey:@"price"]intValue]]];
        [_rightTimeLabel setText:[data objectForKey:@"limitTime"]];
        [_rightDescLabel setText:[data objectForKey:@"prop"]];
        int type=[[data objectForKey:@"stat"]intValue];
        if (type==1) {
            [_rightButton setTitle:@"已用" forState:UIControlStateNormal];
        }
        else if (type==2) {
            [_rightButton setTitle:@"可用" forState:UIControlStateNormal];
        }
        else if (type==3) {
            [_rightButton setTitle:@"已过期" forState:UIControlStateNormal];
        }
    }
}

- (void)doUse:(id)sender
{
    
}

@end
