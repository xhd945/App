//
//  GoodsBarginCell.m
//  occ
//
//  Created by RS on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsBarginCell.h"

@implementation GoodsBarginCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _barginLabel = [[UILabel alloc]init];
        _barginLabel.backgroundColor = [UIColor clearColor];
        _barginLabel.font = FONT_12;
        _barginLabel.textColor = COLOR_999999;
        _barginLabel.highlightedTextColor = COLOR_FFFFFF;
        [_barginLabel setNumberOfLines:0];
        [self.contentView addSubview:_barginLabel];
        
        UIImage *redImage = [UIImage imageNamed:@"list_bgwhite_nor.png"];
        redImage=[redImage stretchableImageWithLeftCapWidth:redImage.size.width/2 topCapHeight:redImage.size.height/2];
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:redImage];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        
        [self setBackgroundView:backgroundView];
        [self setSelectedBackgroundView:selectedBackgroundView];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
    
    int height=[CommonMethods heightForString:_barginLabel.text andFont:_barginLabel.font andWidth:kBargainLabelWidth];
    [_barginLabel setFrame:CGRectMake(10,10, kBargainLabelWidth, height)];
}

-(void)setData:(NSDictionary*)data
{
    _shopData=data;
    NSArray* list=[data objectForKey:@"bargainList"];
    NSString *text=[list componentsJoinedByString:@"\n"];
    [_barginLabel setText:text];
}

-(float)getCellHeight
{
    NSArray* list=[_shopData objectForKey:@"bargainList"];
    if ([list count]==0)
    {
        return 0;
    }
    
    NSString *text=[list componentsJoinedByString:@"\n"];
    int height=[CommonMethods heightForString:text andFont:FONT_12 andWidth:kBargainLabelWidth];
    return height+20;
}

@end
