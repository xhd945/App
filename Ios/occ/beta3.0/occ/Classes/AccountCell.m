//
//  MyAccountCell.m
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *leftImageView = [[UIImageView alloc]init];
        [leftImageView setFrame:CGRectZero];
        leftImageView.clipsToBounds=YES;
        [self.contentView addSubview:leftImageView];
        _leftImageView=leftImageView;
        
        UIImageView *rightImageView = [[UIImageView alloc]init];
        [rightImageView setFrame:CGRectZero];
        [rightImageView setImage:[UIImage imageNamed:@"next_nor.png"]];
        [rightImageView setHighlightedImage:[UIImage imageNamed:@"next_nor.png"]];
        rightImageView.clipsToBounds=YES;
        [self.contentView addSubview:rightImageView];
        _rightImageView=rightImageView;
        
        UILabel *leftLabel = [[UILabel alloc]init];
        [leftLabel setTextColor:COLOR_000000];
        [leftLabel setFont:FONT_16];
        [leftLabel setBackgroundColor:[UIColor clearColor]];
        [leftLabel setText:@""];
        [leftLabel setNumberOfLines:1];
        [leftLabel setFrame:CGRectZero];
        [leftLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:leftLabel];
        _leftLabel=leftLabel;
        
        self.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassOne];
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
    [_leftImageView setFrame:CGRectMake(0,0, 30, 30)];
    [_leftImageView setCenter:CGPointMake(30, self.contentView.frame.size.height/2)];
    [_rightImageView setFrame:CGRectMake(0,0, 11, 11)];
    [_rightImageView setCenter:CGPointMake(300, self.contentView.frame.size.height/2)];
    [_leftLabel setFrame:CGRectMake(60,0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
}

-(void)setData:(NSDictionary*)data
{
    NSString *imageName=[data objectForKey:@"image"];
    [_leftImageView setImage:[UIImage imageNamed:imageName]];
    [_leftImageView setHighlightedImage:[UIImage imageNamed:imageName]];
    [_leftLabel setText:[data objectForKey:@"name"]];
}

@end
