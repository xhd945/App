//
//  SearchCategoryCell.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "SearchCategoryCell.h"
#import "CommonMethods.h"

@implementation SearchCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _leftImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:_leftImageView];
        
        _titleLabel=[[UILabel alloc]init];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:COLOR_333333];
        [_titleLabel setHighlightedTextColor:COLOR_333333];
        [_titleLabel setFont:FONT_16];
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel=[[UILabel alloc]init];
        [_detailLabel setBackgroundColor:[UIColor clearColor]];
        [_detailLabel setTextColor:COLOR_333333];
        [_detailLabel setHighlightedTextColor:COLOR_333333];
        [_detailLabel setFont:FONT_12];
        [self.contentView addSubview:_detailLabel];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundView:backgroundView];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        self.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassOne];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_leftImageView setFrame:CGRectMake(0, 0, 60, 60)];
    [_titleLabel setFrame:CGRectMake(60, 12, SCREEN_WIDTH, 0)];
    [_titleLabel sizeToFit];
    [_detailLabel setFrame:CGRectMake(60, 32, SCREEN_WIDTH, 0)];
    [_detailLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
    NSURL *imageURL = [NSURL URLWithString:[data objectForKey:@"image"]];
    [_leftImageView setImageWithURL:imageURL placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypePortrait]];
    
    [_titleLabel setTextColor:COLOR_000000];
    [_titleLabel setHighlightedTextColor:COLOR_000000];
    NSString *title=[data objectForKey:@"title"];
    [_titleLabel setText:title];
    
    [_detailLabel setTextColor:COLOR_999999];
    [_detailLabel setHighlightedTextColor:COLOR_999999];
    NSString *detail=[data objectForKey:@"detail"];
    [_detailLabel setText:detail];
}

@end
