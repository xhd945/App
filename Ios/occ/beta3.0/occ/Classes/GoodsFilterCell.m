//
//  SearchFilterCell.m
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsFilterCell.h"

@implementation GoodsFilterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [titleLabel setTextColor:COLOR_333333];
        [titleLabel setHighlightedTextColor:COLOR_333333];
        [titleLabel setFont:FONT_16];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setNumberOfLines:1];
        [titleLabel setFrame:CGRectZero];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:titleLabel];
        _titleLabel=titleLabel;
        
        UILabel *rightLabel = [[UILabel alloc]init];
        [rightLabel setTextColor:COLOR_333333];
        [rightLabel setHighlightedTextColor:COLOR_333333];
        [rightLabel setFont:FONT_16];
        [rightLabel setBackgroundColor:[UIColor clearColor]];
        [rightLabel setNumberOfLines:1];
        [rightLabel setFrame:CGRectZero];
        [rightLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:rightLabel];
        _rightLabel=rightLabel;
        
        UIImageView *rightImageView = [[UIImageView alloc]init];
        [rightImageView setFrame:CGRectZero];
        [rightImageView setImage:[UIImage imageNamed:@"next_nor.png"]];
        [rightImageView setHighlightedImage:[UIImage imageNamed:@"next_nor.png"]];
        rightImageView.clipsToBounds=YES;
        [self.contentView addSubview:rightImageView];
        _rightImageView=rightImageView;
        
        self.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassTwo];
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
    [super layoutSubviews];
    _titleLabel.frame=CGRectMake(15, 0, SCREEN_WIDTH, self.bounds.size.height);
    _rightLabel.frame=CGRectMake(90, 0, SCREEN_WIDTH, self.bounds.size.height);
    _rightImageView.frame=CGRectMake(230, 18, 11, 11);
}

-(void)setData:(NSDictionary*)data
{
    BOOL isSelected = [[data objectForKey:@"check"] boolValue];
    if (isSelected)
    {
        _rightImageView.image = [UIImage imageNamed:@"jiantou_down"];
        [_titleLabel setTextColor:COLOR_D1BEB0];
        [_titleLabel setHighlightedTextColor:COLOR_FBB714];
        [_rightLabel setTextColor:COLOR_FFFFFF];
    }
    else
    {
        _rightImageView.image = [UIImage imageNamed:@"jiantou_right"];
        [_titleLabel setTextColor:COLOR_D1BEB0];
        [_titleLabel setHighlightedTextColor:COLOR_FBB714];
        [_rightLabel setTextColor:COLOR_FFFFFF];
    }
    
    if ([data objectForKey:@"name"]!=nil)
    {
        NSString *title=[data objectForKey:@"name"];
        [_titleLabel setText:title];
    }
    else if ([data objectForKey:@"title"]!=nil)
    {
        NSString *title=[data objectForKey:@"title"];
        [_titleLabel setText:title];
    }
    
    NSString *text=[data objectForKey:@"text"];
    [_rightLabel setText:text];
}

@end
