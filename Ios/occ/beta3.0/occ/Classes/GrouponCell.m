//
//  GrouponCell.m
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponCell.h"

@implementation GrouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        _whiteView = [[UIView alloc]init];
        [_whiteView setBackgroundColor:COLOR_FFFFFF];
        _whiteView.layer.masksToBounds=YES;
        _whiteView.layer.cornerRadius=5;
        [self.contentView addSubview:_whiteView];
        
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_whiteView addSubview:_goodsImageView];
        
        _sellOutImageView = [[UIImageView alloc]init];
        [_sellOutImageView setImage:[UIImage imageNamed:@"no_sale_left"]];
        //[_whiteView addSubview:_sellOutImageView];
        
        _juanImageView = [[UIImageView alloc]init];
        [_juanImageView setImage:[UIImage imageNamed:@"juan_left"]];
        [_whiteView addSubview:_juanImageView];
        
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.textColor=COLOR_333333;
        _nameLabel.backgroundColor=[UIColor clearColor];
        _nameLabel.textAlignment=UITextAlignmentLeft;
        _nameLabel.font=FONT_14;
        _nameLabel.numberOfLines=2;
        [self.contentView addSubview:_nameLabel];
        
        _plPriceLabel=[[UILabel alloc]init];
        _plPriceLabel.textColor=COLOR_D91F1E;
        _plPriceLabel.backgroundColor=[UIColor clearColor];
        _plPriceLabel.textAlignment=UITextAlignmentLeft;
        _plPriceLabel.font=FONT_14;
        [self.contentView addSubview:_plPriceLabel];
        
        _listPriceLabel=[[OCCStrikeThroughLabel alloc]init];
        _listPriceLabel.textColor=COLOR_453D3A;
        _listPriceLabel.backgroundColor=[UIColor clearColor];
        _listPriceLabel.textAlignment=UITextAlignmentLeft;
        _listPriceLabel.font=FONT_12;
        [self.contentView addSubview:_listPriceLabel];
        
        _discountLabel=[[UILabel alloc]init];
        _discountLabel.textColor=COLOR_27813A;
        _discountLabel.backgroundColor=[UIColor clearColor];
        _discountLabel.textAlignment=UITextAlignmentLeft;
        _discountLabel.font=FONT_12;
        [self.contentView addSubview:_discountLabel];
        
        _buyNumLabel=[[UILabel alloc]init];
        _buyNumLabel.textColor=COLOR_999999;
        _buyNumLabel.highlightedTextColor=COLOR_999999;
        _buyNumLabel.backgroundColor=[UIColor clearColor];
        _buyNumLabel.textAlignment=UITextAlignmentRight;
        _buyNumLabel.font=FONT_14;
        [self.contentView addSubview:_buyNumLabel];
        
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    _whiteView.frame=CGRectMake(10, 10, 120, 80);
    _goodsImageView.frame=CGRectMake(5, 5, _whiteView.frame.size.width-10, _whiteView.frame.size.height-10);
    _sellOutImageView.frame=CGRectMake(5, 5, 36, 36);
    _juanImageView.frame=CGRectMake(5, 5, 36, 36);
    
    _nameLabel.frame=CGRectMake(_whiteView.frame.origin.x+_whiteView.frame.size.width+5, _whiteView.frame.origin.y, SCREEN_WIDTH-_whiteView.frame.origin.x-_whiteView.frame.size.width-15, 30);
    [_nameLabel sizeToFit];
    
    _plPriceLabel.frame=CGRectMake(_nameLabel.frame.origin.x, self.contentView.frame.size.height-HEADER_HEIGHT, SCREEN_WIDTH, 30);
    [_plPriceLabel sizeToFit];
    
    _listPriceLabel.frame=CGRectMake(_plPriceLabel.frame.origin.x+_plPriceLabel.frame.size.width+5, _plPriceLabel.frame.origin.y, SCREEN_WIDTH, 30);
    [_listPriceLabel sizeToFit];
    _listPriceLabel.frame=CGRectMake(_listPriceLabel.frame.origin.x, _listPriceLabel.frame.origin.y, _listPriceLabel.frame.size.width, _plPriceLabel.frame.size.height);
    
    _discountLabel.frame=CGRectMake(_listPriceLabel.frame.origin.x+_listPriceLabel.frame.size.width+5, _listPriceLabel.frame.origin.y, SCREEN_WIDTH, 30);
    [_discountLabel sizeToFit];
    _discountLabel.frame=CGRectMake(_discountLabel.frame.origin.x, _discountLabel.frame.origin.y, _discountLabel.frame.size.width, _plPriceLabel.frame.size.height);
    
    _buyNumLabel.frame=CGRectMake(_nameLabel.frame.origin.x, _plPriceLabel.frame.origin.y+_plPriceLabel.frame.size.height, SCREEN_WIDTH, 30);
    [_buyNumLabel sizeToFit];
}

-(void)setData:(NSDictionary*)data
{
    NSString *strURL  = [[data objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [_goodsImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    [_nameLabel setText:[data objectForKey:@"name"]];
    
    NSString *plPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"plPrice"]];
    [_plPriceLabel setText:plPrice];
    
    NSString *listPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"listPrice"]];
    [_listPriceLabel setText:listPrice];
    
    float discount=[[data objectForKey:@"plPrice"]floatValue]/[[data objectForKey:@"listPrice"]floatValue];
    NSString *discountText=[NSString stringWithFormat:@"%.1f折",discount*10];
    [_discountLabel setText:discountText];
    
    NSString *sellNum=[NSString stringWithFormat:@"%@人已购买",[data objectForKey:@"sellNum"]];
    [_buyNumLabel setText:sellNum];
    
    int type=[[data objectForKey:@"sendType"]intValue];
    if (type==1)
    {
        _juanImageView.hidden=NO;
    }
    else
    {
        _juanImageView.hidden=YES;
    }
}
@end
