//
//  OrderGrouponCell.m
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyOrderGrouponCell.h"

@implementation MyOrderGrouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _leftImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:_leftImageView];
        
        _grouponImageView=[[UIImageView alloc]init];
        _grouponImageView.frame=CGRectMake(0, 0, 22, 22);
        [_grouponImageView setImage:[UIImage imageNamed:@"bg_groupon"]];
        [_leftImageView addSubview:_grouponImageView];
        
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:FONT_14];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setHighlightedTextColor:COLOR_333333];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setNumberOfLines:2];
        [self.contentView addSubview:_nameLabel];
        
        _priceLabel=[[UILabel alloc]init];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextColor:COLOR_999999];
        [_priceLabel setHighlightedTextColor:COLOR_999999];
        [self.contentView addSubview:_priceLabel];
        
        _confirmButton = [CommonMethods buttonWithTitle:@"确认收货" withTarget:self andSelector:@selector(doConfirm:) andFrame:CGRectMake(230, 10, 80, 44) andButtonType:OCCButtonTypeYellow];
        //[self.contentView addSubview:_confirmButton];
        
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

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    _leftImageView.frame=CGRectMake(10, 10, 70, 70);
    
    _nameLabel.frame=CGRectMake(90, 10, SCREEN_WIDTH, 20);
    [_nameLabel sizeToFit];
    
    _priceLabel.frame=CGRectMake(90, 40, SCREEN_WIDTH, 20);
    
    [_confirmButton setFrame:CGRectMake(230, 40, 80, 44)];
}

-(void)setData:(NSMutableDictionary*)data
{
    NSString *strURL  = [[data objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.leftImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    NSString *title=[data objectForKey:@"itemName"];
    [_nameLabel setText:title];
    
    int orderStat=[[data objectForKey:@"orderStat"]intValue];
    if (orderStat==0)
    {
        [(UIButton*)self.confirmButton setTitle:@"立即付款" forState:UIControlStateNormal];
    }
    else if (orderStat==9)
    {
        UIImage *grayImage=[UIImage imageNamed:@"btn_bg_light_gray"];
        grayImage = [grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
        [(UIButton*)self.confirmButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [(UIButton*)self.confirmButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [(UIButton*)self.confirmButton setUserInteractionEnabled:NO];
        [(UIButton*)self.confirmButton setTitle:@"交易完成" forState:UIControlStateNormal];
    }
    else
    {
        UIImage *grayImage=[UIImage imageNamed:@"btn_bg_yellow"];
        grayImage = [grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
        [(UIButton*)self.confirmButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [(UIButton*)self.confirmButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
        [(UIButton*)self.confirmButton setUserInteractionEnabled:YES];
    }

    NSString *price=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"plPrice"]];
    [_priceLabel setText:price];
}

- (void)doConfirm:(id)sender
{
    
}

@end
