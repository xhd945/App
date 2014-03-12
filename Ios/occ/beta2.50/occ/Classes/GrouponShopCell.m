//
//  GrouponShopCell.m
//  occ
//
//  Created by RS on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponShopCell.h"

@implementation GrouponShopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setTextColor:COLOR_333333];
        [_titleLabel setFont:FONT_14];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setText:[NSString stringWithFormat:@"适用商家"]];
        [_titleLabel setFrame:CGRectMake(20, 0, self.bounds.size.width, 44)];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_titleLabel];
        
        _upDownButton =[[UIButton alloc]init];
        [_upDownButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_upDownButton addTarget:self action:@selector(doUpDown:) forControlEvents:UIControlEventTouchUpInside];
        _upDownButton.titleLabel.font = FONT_12;
        [_upDownButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [self.contentView addSubview:_upDownButton];
        
        _upDownImageView = [[UIImageView alloc]init];
        [_upDownImageView setFrame:CGRectMake(275, 18, 11, 11)];
        [_upDownImageView setImage:[UIImage imageNamed:@"arrow_down"]];
        _upDownImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_upDownImageView];
        
        _lineLabel = [[UILabel alloc]init];
        [_lineLabel setFrame:CGRectMake(0,HEADER_HEIGHT, 300, 0.5)];
        [_lineLabel setTextColor:COLOR_999999];
        [_lineLabel setBackgroundColor:COLOR_999999];
        [self.contentView addSubview:_lineLabel];
        
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setFont:FONT_14];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setText:[NSString stringWithFormat:@"周大福"]];
        [_nameLabel setFrame:CGRectMake(20, HEADER_HEIGHT, self.bounds.size.width, 44)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
        
        _scoreButton = [[UIButton alloc]init];
        [_scoreButton setFrame:CGRectMake(250, HEADER_HEIGHT+5, 30, 30)];
        [_scoreButton setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [_scoreButton setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateHighlighted];
        [_scoreButton.titleLabel setFont:FONT_12];
        [_scoreButton setTitleEdgeInsets:UIEdgeInsetsMake(1,0,0,0)];
        [_scoreButton setUserInteractionEnabled:NO];
        [self.contentView addSubview:_scoreButton];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bgwhite_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
        [self setBackgroundView:backgroundView];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_EAEAEA];
        [self setSelectedBackgroundView:selectedBackgroundView];
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
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
}

-(void)setData:(NSDictionary*)data
{
    NSDictionary *shopData=[[data objectForKey:@"shopList"]objectAtIndex:0];
    [_nameLabel setText:[shopData objectForKey:@"name"]];
    float evaluation=[[shopData objectForKey:@"evaluation"]floatValue];
    [_scoreButton setTitle:[NSString stringWithFormat:@"%.1f",evaluation] forState:UIControlStateNormal];
}

- (void)doUpDown:(id)sender
{
    if (self.expand==0)
    {
        self.expand=1;
    }
    else
    {
        self.expand=0;
    }
    
    UITableView *tableView = (UITableView *)self.superview;
    if (![tableView isKindOfClass:[UITableView class]]) tableView = (UITableView *)tableView.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    [tableView reloadData];
}

-(float)getCellHeight
{
    if(self.expand==0)
    {
        return 1*HEADER_HEIGHT;
    }
    else
    {
        return 2*HEADER_HEIGHT;
    }
}

@end
