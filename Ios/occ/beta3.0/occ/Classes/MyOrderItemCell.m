//
//  OrderItemCell.m
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyOrderItemCell.h"

#define kImageHeight 70
#define kNameLabelWidth 150

@implementation MyOrderItemCell

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
        
        _leftImageView= [[UIImageView alloc]init];
        [_leftImageView setFrame:CGRectZero];
        _leftImageView.layer.cornerRadius = 5.0;
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_leftImageView];
        
        UIImage *typeImage = [UIImage imageNamed:@"groupon_bg_list"];
        _typeImageView=[[UIImageView alloc]init];
        _typeImageView.image=typeImage;
        _typeImageView.frame=CGRectMake(kImageHeight - typeImage.size.width, 0, typeImage.size.width, typeImage.size.height);
        _typeImageView.backgroundColor = [UIColor clearColor];
        [_leftImageView addSubview:_typeImageView];
        
        _priceLabel = [[UILabel alloc]init];
        [_priceLabel setFrame:CGRectZero];
        [_priceLabel setFont:FONT_12];
        [_priceLabel setTextColor:COLOR_453D3A];
        [_priceLabel setHighlightedTextColor:COLOR_453D3A];
        [_priceLabel setTextAlignment:NSTextAlignmentRight];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_priceLabel];
        
        _numLabel = [[UILabel alloc]init];
        [_numLabel setFrame:CGRectZero];
        [_numLabel setFont:FONT_12];
        [_numLabel setTextColor:COLOR_453D3A];
        [_numLabel setHighlightedTextColor:COLOR_453D3A];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_numLabel];
        
        _sizeLabel = [[UILabel alloc]init];
        [_sizeLabel setFrame:CGRectZero];
        [_sizeLabel setFont:FONT_12];
        [_sizeLabel setTextColor:COLOR_999999];
        [_sizeLabel setHighlightedTextColor:COLOR_999999];
        [_sizeLabel setBackgroundColor:[UIColor clearColor]];
        _sizeLabel.hidden=YES;
        [self.contentView addSubview:_sizeLabel];
        
        _bargainLabel = [[UILabel alloc]init];
        [_bargainLabel setTextAlignment:NSTextAlignmentLeft];
        [_bargainLabel setTextColor:COLOR_999999];
        [_bargainLabel setBackgroundColor:[UIColor clearColor]];
        [_bargainLabel setNumberOfLines:0];
        [_bargainLabel setFont:FONT_12];
        [self.contentView addSubview:_bargainLabel];
        
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFrame:CGRectZero];
        [_nameLabel setFont:FONT_14];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setHighlightedTextColor:COLOR_333333];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setNumberOfLines:2];
        [_nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
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
    self.leftImageView.frame = CGRectMake(10, 10, kImageHeight, kImageHeight);
    self.priceLabel.frame = CGRectMake(210, 10, 80, 20);
    self.numLabel.frame = CGRectMake(210, 30, 80, 20);
    
    float height=[CommonMethods heightForString:_nameLabel.text andFont:_nameLabel.font andWidth:kNameLabelWidth];
    self.nameLabel.frame = CGRectMake(90, 12, kNameLabelWidth, 0);
    [self.nameLabel sizeToFit];
    
    height=[CommonMethods heightForString:_bargainLabel.text andFont:_bargainLabel.font andWidth:kBargainLabelWidth];
    [_bargainLabel setFrame:CGRectMake(20,80, kBargainLabelWidth, height)];
}

-(void)setData:(NSDictionary*)data
{
    NSString *strURL  = [[data objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.leftImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    if ([[data objectForKey:@"type"]intValue]==1)
    {
        self.typeImageView.hidden=NO;
    }
    else
    {
        self.typeImageView.hidden=YES;
    }
    
    NSString *title=[data objectForKey:@"itemName"];
    [_nameLabel setText:title];
    
    NSString *price=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"plPrice"]];
    [_priceLabel setText:price];
    
    NSString *num=[NSString stringWithFormat:@"×%@",[data objectForKey:@"buyNum"]];
    [_numLabel setText:num];
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSMutableArray *itemBargainList=[data objectForKey:@"itemBargainList"];
    for (int i=0; i<[itemBargainList count]; i++) {
        NSDictionary *item=[itemBargainList objectAtIndex:i];
        if ([[item objectForKey:@"name"] isKindOfClass:[NSString class]]){
            [arr addObject:[item objectForKey:@"name"]];
        }
    }
    [_bargainLabel setText:[arr componentsJoinedByString:@"\n"]];
}

@end
