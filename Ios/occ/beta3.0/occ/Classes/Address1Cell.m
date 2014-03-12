//
//  Address1Cell.m
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Address1Cell.h"

@implementation Address1Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView=[CommonMethods lineWithWithType:OCCLineType3];
        [self.contentView addSubview:_lineImageView];
        
        _phoneImageView=[[UIImageView alloc]init];
        [_phoneImageView setImage:[UIImage imageNamed:@"bg_phone.png"]];
        [_phoneImageView setHighlightedImage:[UIImage imageNamed:@"bg_phone.png"]];
        [self.contentView addSubview:_phoneImageView];
        
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setHighlightedTextColor:COLOR_333333];
        [_nameLabel setText:@"收件人:"];
        [_nameLabel setFont:FONT_14];
        [self.contentView addSubview:_nameLabel];
        
        _addressLabel=[[UILabel alloc]init];
        [_addressLabel setBackgroundColor:[UIColor clearColor]];
        [_addressLabel setTextColor:COLOR_999999];
        [_addressLabel setHighlightedTextColor:COLOR_DA6432];
        [_addressLabel setFont:FONT_12];
        [_addressLabel setText:@"收货地址:"];
        _addressLabel.numberOfLines=0;
        [self.contentView addSubview:_addressLabel];
        
        _phoneLabel=[[UILabel alloc]init];
        [_phoneLabel setBackgroundColor:[UIColor clearColor]];
        [_phoneLabel setTextColor:COLOR_333333];
        [_phoneLabel setHighlightedTextColor:COLOR_333333];
        [_phoneLabel setFont:FONT_14];
        [_phoneLabel setText:@"电话号码"];
        [self.contentView addSubview:_phoneLabel];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [self setBackgroundView:backgroundView];
        
        UIImage *image=[UIImage imageNamed:@"list_address"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height-10];
        [backgroundView setImage:image];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:COLOR_EAEAEA];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
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
    
    [_lineImageView setFrame:CGRectMake(10, 55, self.contentView.bounds.size.width-20, 1)];
    [_phoneImageView setFrame:CGRectMake(160, 30, 22, 22)];
    [_nameLabel setFrame:CGRectMake(20, 30, SCREEN_WIDTH-175, 20)];
    [_phoneLabel setFrame:CGRectMake(180, 30, SCREEN_WIDTH-40, 20)];
    [_addressLabel setFrame:CGRectMake(20, 65, SCREEN_WIDTH-40, 20)];
    [_addressLabel sizeToFit];
}

-(void)setData:(NSDictionary*)data
{
    NSString *consignee=[data objectForKey:@"consignee"];
    if (consignee==nil||[consignee length]==0)
    {
        consignee=@"未知";
    }
    [_nameLabel setText:[NSString stringWithFormat:@"收件人:%@",consignee]];
    
    NSString *mobile=[data objectForKey:@"mobile"];
    if (mobile!=nil&&[mobile length]>0)
    {
        [_phoneLabel setText:mobile];
    }
    else
    {
        [_phoneLabel setText:@""];
    }
    
    NSString *address=[data objectForKey:@"address"];
    if (mobile!=nil)
    {
        [_addressLabel setText:[NSString stringWithFormat:@"收货地址:%@",address]];
    }
}

@end
