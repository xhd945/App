//
//  CartFootCell.m
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "CartFootCell.h"

#define kActivityContentLength 170

@implementation CartFootCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _totlePriceLabel=[[UILabel alloc]init];
        [_totlePriceLabel setTextColor:COLOR_333333];
        [_totlePriceLabel setHighlightedTextColor:COLOR_333333];
        [_totlePriceLabel setBackgroundColor:[UIColor clearColor]];
        [_totlePriceLabel setFont:FONT_14];
        [_totlePriceLabel setText:@"合计:"];
        [_totlePriceLabel setTextAlignment:NSTextAlignmentLeft];
        [_totlePriceLabel setFrame:CGRectMake(210, 5, 80, 20)];
        [self.contentView addSubview:_totlePriceLabel];
        
        _priceLabel=[[UILabel alloc]init];
        [_priceLabel setTextColor:COLOR_D91F1E];
        [_priceLabel setHighlightedTextColor:COLOR_D91F1E];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setFont:FONT_14];
        [_priceLabel setTextAlignment:NSTextAlignmentRight];
        [_priceLabel setFrame:CGRectMake(210, 5, 80, 20)];
        [self.contentView addSubview:_priceLabel];
        
        _totleNumberLabel=[[UILabel alloc]init];
        [_totleNumberLabel setTextColor:COLOR_333333];
        [_totleNumberLabel setBackgroundColor:[UIColor clearColor]];
        [_totleNumberLabel setHighlightedTextColor:COLOR_333333];
        [_totleNumberLabel setFont:FONT_14];
        [_totleNumberLabel setText:@"数量:"];
        [_totleNumberLabel setTextAlignment:NSTextAlignmentLeft];
        [_totleNumberLabel setFrame:CGRectMake(210, 25, 80, 20)];
        [self.contentView addSubview:_totleNumberLabel];
        
        _numLabel=[[UILabel alloc]init];
        [_numLabel setTextColor:COLOR_D91F1E];
        [_numLabel setHighlightedTextColor:COLOR_D91F1E];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setFont:FONT_14];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setFrame:CGRectMake(210, 25, 80, 20)];
        [self.contentView addSubview:_numLabel];
        
        UIImage *image=[UIImage imageNamed:@"list_bgwhite3_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height-10];
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [self setBackgroundView:backgroundView];
        [backgroundView setImage:image];
        
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

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
}

-(void)setData:(NSMutableDictionary*)data
{
    _data =data;
    NSArray *list=[data objectForKey:@"bargainList"];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (NSDictionary *item in list) {
        [arr addObject:[item objectForKey:@"name"]];
    }
        
    if (_activityLabel!=nil)
    {
        [_activityLabel removeFromSuperview];
        _activityLabel=nil;
    }
    
    _activityLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10, 0, 180, 50) rate:50.0f andFadeLength:10.0f];
    _activityLabel.numberOfLines = 1;
    _activityLabel.opaque = NO;
    _activityLabel.enabled = YES;
    _activityLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    _activityLabel.textAlignment = UITextAlignmentLeft;
    _activityLabel.textColor = COLOR_333333;
    _activityLabel.backgroundColor = [UIColor clearColor];
    _activityLabel.font = FONT_14;
    [self.contentView addSubview:_activityLabel];
    
    if ([arr count]>0) {
        [_activityLabel setText:[arr componentsJoinedByString:@"  "]];
    }else{
        [_activityLabel setText:@""];
    }
    
    NSString *price=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"price"]];
    [_priceLabel setText:price];

    NSString *num=[NSString stringWithFormat:@"%@",[data objectForKey:@"num"]];
    [_numLabel setText:num];
}

-(void)animationOfScroll
{
    
}

@end
