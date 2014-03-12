//
//  PayTotalCell.m
//  occ
//
//  Created by RS on 13-8-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "PayShopCell.h"

#define kNameLabelWidth 140

@implementation PayShopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView=[CommonMethods lineWithWithType:OCCLineType3];
        [self.contentView addSubview:_lineImageView];
        
        _shopImageView = [[UIImageView alloc]init];
        [_shopImageView setFrame:CGRectZero];
        [_shopImageView setImage:[UIImage imageNamed:@"bg_shop.png"]];
        [_shopImageView setHighlightedImage:[UIImage imageNamed:@"bg_shop.png"]];
        [self.contentView addSubview:_shopImageView];
        
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setText:@"商家:原始时尚风烤肉"];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setHighlightedTextColor:COLOR_333333];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:FONT_12];
        [_nameLabel setNumberOfLines:2];
        _nameLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        [self.contentView addSubview:_nameLabel];
        
        _totalPriceLabel = [[UILabel alloc]init];
        [_totalPriceLabel setFrame:CGRectZero];
        [_totalPriceLabel setFont:FONT_12];
        [_totalPriceLabel setTextColor:COLOR_333333];
        [_totalPriceLabel setHighlightedTextColor:COLOR_333333];
        [_totalPriceLabel setTextAlignment:NSTextAlignmentLeft];
        [_totalPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_totalPriceLabel setText:@"合计:"];
        [self.contentView addSubview:_totalPriceLabel];
        
        _priceLabel = [[UILabel alloc]init];
        [_priceLabel setFrame:CGRectZero];
        [_priceLabel setFont:FONT_12];
        [_priceLabel setTextColor:COLOR_DA6432];
        [_priceLabel setHighlightedTextColor:COLOR_DA6432];
        [_priceLabel setTextAlignment:NSTextAlignmentRight];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_priceLabel];
        
        _totalNumLabel = [[UILabel alloc]init];
        [_totalNumLabel setFrame:CGRectZero];
        [_totalNumLabel setFont:FONT_12];
        [_totalNumLabel setTextColor:COLOR_333333];
        [_totalNumLabel setHighlightedTextColor:COLOR_333333];
        [_totalNumLabel setTextAlignment:NSTextAlignmentLeft];
        [_totalNumLabel setBackgroundColor:[UIColor clearColor]];
        [_totalNumLabel setText:@"数量:"];
        [self.contentView addSubview:_totalNumLabel];
        
        _numLabel = [[UILabel alloc]init];
        [_numLabel setFrame:CGRectZero];
        [_numLabel setFont:FONT_12];
        [_numLabel setTextColor:COLOR_DA6432];
        [_numLabel setHighlightedTextColor:COLOR_DA6432];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_numLabel];

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
    
    [_lineImageView setFrame:CGRectMake(10, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-20, 1)];
    
    _shopImageView.frame=CGRectMake(5, 0, 22, 22);
    _shopImageView.center=CGPointMake(_shopImageView.center.x, self.frame.size.height/2);
    
    [_nameLabel sizeToFit];
    _nameLabel.frame=CGRectMake(_shopImageView.frame.origin.x+_shopImageView.frame.size.width, 0, _nameLabel.frame.size.width, self.frame.size.height);
    
    self.priceLabel.frame = CGRectMake(210, 5, 80, 20);
    self.totalPriceLabel.frame = self.priceLabel.frame;
    self.numLabel.frame = CGRectOffset(self.priceLabel.frame, 0, 20);
    self.totalNumLabel.frame = self.numLabel.frame;
}

-(void)setData:(NSDictionary*)data
{
    NSString *name=[NSString stringWithFormat:@"商家:%@",[data objectForKey:@"name"]];
    [_nameLabel setText:name];

    NSString *price=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"buyPriceSum"]];
    [_priceLabel setText:price];
    
    NSString *num=[NSString stringWithFormat:@"%@",[data objectForKey:@"buyNumSum"]];
    [_numLabel setText:num];
}

@end
