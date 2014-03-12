//
//  OrderNext2Cell.m
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyOrderRestCell.h"

@implementation MyOrderRestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView =[[UIImageView alloc]init];
        [_lineImageView setImage:[UIImage imageNamed:@"line3"]];
        [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line3"]];
        [self.contentView addSubview:_lineImageView];
        
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setText:@"显示剩余2件"];
        [_nameLabel setTextColor:COLOR_999999];
        [_nameLabel setHighlightedTextColor:COLOR_999999];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:FONT_12];
        [self.contentView addSubview:_nameLabel];
        
        UIImage *image=[UIImage imageNamed:@"list_bgwhite2_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height-10];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:image];
        [self setBackgroundView:backgroundView];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    self.lineImageView.frame=CGRectMake(10, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-20, 1);
    self.nameLabel.frame = self.contentView.frame;
}

-(void)setData:(NSDictionary*)data
{
    @try {
        NSArray *itemList=[data objectForKey:KEY_ITEMLIST];
        NSString *num=[NSString stringWithFormat:@"显示剩余%d件",itemList.count -2];
        [_nameLabel setText:num];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
