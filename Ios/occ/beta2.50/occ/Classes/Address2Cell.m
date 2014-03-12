//
//  AddressModifyCell.m
//  occ
//
//  Created by RS on 13-8-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "Address2Cell.h"
#import "AddressModifyViewController.h"
#import "AppDelegate.h"

@implementation Address2Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        //_lineImageView=[CommonMethods lineWithWithType:OCCLineType2];
        //[self.contentView addSubview:_lineImageView];
        
        _checkImageView=[[UIImageView alloc]init];
        [_checkImageView setHighlightedImage:[UIImage imageNamed:@"confirm.png"]];
        [self.contentView addSubview:_checkImageView];
        
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setHighlightedTextColor:COLOR_333333];
        [_nameLabel setText:@"收件人:"];
        [_nameLabel setFont:FONT_14];
        [self.contentView addSubview:_nameLabel];
        
        _phoneLabel=[[UILabel alloc]init];
        [_phoneLabel setBackgroundColor:[UIColor clearColor]];
        [_phoneLabel setTextColor:COLOR_333333];
        [_phoneLabel setHighlightedTextColor:COLOR_333333];
        [_phoneLabel setFont:FONT_14];
        [_phoneLabel setText:@"电话号码"];
        [self.contentView addSubview:_phoneLabel];
        
        _addressLabel=[[UILabel alloc]init];
        [_addressLabel setBackgroundColor:[UIColor clearColor]];
        [_addressLabel setTextColor:COLOR_999999];
        [_addressLabel setHighlightedTextColor:COLOR_DA6432];
        [_addressLabel setFont:FONT_12];
        [_addressLabel setText:@"收货地址:"];
        _addressLabel.numberOfLines=0;
        [self.contentView addSubview:_addressLabel];
        
        _detailLabel=[[UILabel alloc]init];
        [_detailLabel setBackgroundColor:[UIColor clearColor]];
        [_detailLabel setTextColor:COLOR_999999];
        [_detailLabel setHighlightedTextColor:COLOR_DA6432];
        [_detailLabel setFont:FONT_12];
        [_detailLabel setText:@"详细地址:"];
        _detailLabel.numberOfLines=0;
        [self.contentView addSubview:_detailLabel];
        
        _editButton = [[UIButton alloc]init];
        [_editButton setFrame:CGRectZero];
        [_editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [_editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateHighlighted];
        [_editButton addTarget:self action:@selector(doEditAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_editButton];
        
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setFrame:CGRectZero];
        [_confirmButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [_confirmButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateHighlighted];
        [_confirmButton addTarget:self action:@selector(doMsg:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_confirmButton];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundView:backgroundView];
        
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    [_lineImageView setFrame:CGRectMake(0, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width, 2)];
    [_nameLabel setFrame:CGRectMake(20, 10, SCREEN_WIDTH-175, 30)];
    [_nameLabel sizeToFit];
    [_phoneLabel setFrame:CGRectMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width+10, _nameLabel.frame.origin.y, SCREEN_WIDTH, 20)];
    [_phoneLabel sizeToFit];
    [_addressLabel setFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+5, SCREEN_WIDTH, 20)];
    [_addressLabel sizeToFit];
    [_detailLabel setFrame:CGRectMake(_nameLabel.frame.origin.x, _addressLabel.frame.origin.y+_addressLabel.frame.size.height, SCREEN_WIDTH, 20)];
    [_detailLabel sizeToFit];
    
    [_editButton setFrame:CGRectMake(0, 0, 60, self.contentView.bounds.size.height)];
    [_editButton setImageEdgeInsets:UIEdgeInsetsMake(0, -45,0,0)];
    
    [_checkImageView setFrame:CGRectMake(0, 0, 22, 22)];
    [_checkImageView setCenter:CGPointMake(self.contentView.bounds.size.width-10, self.contentView.bounds.size.height/2)];
}

- (void)doEditAddress:(id)sender
{
    AddressModifyViewController *viewController=[[AddressModifyViewController alloc]init];
    [viewController setData:[[NSMutableDictionary alloc]initWithDictionary:self.data]];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

-(void)setData:(NSDictionary*)data
{
    _data=data;
    NSString *consignee=[data objectForKey:@"consignee"];
    if (consignee==nil||[consignee length]==0)
    {
        consignee=@"未知";
    }
    [_nameLabel setText:consignee];
    
    [_phoneLabel setText:[data objectForKey:@"mobile"]];
    [_detailLabel setText:[data objectForKey:@"address"]];
    int isOtherCommunity=[[data objectForKey:@"isOtherCommunity"]intValue];
    if (isOtherCommunity==0)
    {
        NSString *address=[NSString stringWithFormat:@"%@ %@ %@ %@",
                           [data objectForKey:@"provinceName"],
                           [data objectForKey:@"cityName"],
                           [data objectForKey:@"areaName"],
                           [data objectForKey:@"communityName"]];
        [_addressLabel setText:address];
    }
    else
    {
        NSString *address=[NSString stringWithFormat:@"%@ %@ %@",
                           [data objectForKey:@"provinceName"],
                           [data objectForKey:@"cityName"],
                           [data objectForKey:@"areaName"]];
        [_addressLabel setText:address];
    }
}

@end
