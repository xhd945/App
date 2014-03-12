//
//  GoodsCell.m
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsCell.h"

#define kSelectViewWidth 40.0
#define kImageWidth 70.0

@implementation GoodsCell

- (id)initWithGoodsCellStyle:(GoodsCellType)type reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        CGFloat pointX = 0.0;
        CGFloat pointY = 10.0;
        self.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassOne];
        _cellType = type;
        
        if (type == GoodsCellTypeSelected)
        {
            [self initSelectedView];
            pointX += kSelectViewWidth;
        }
        else
        {
            pointX += 10.0;
        }
        
        UIImageView *whiteView = [[UIImageView alloc] initWithFrame:CGRectMake(pointX - 3, pointY - 3, kImageWidth + 6, kImageWidth + 6)];
        whiteView.layer.cornerRadius = 5.0;
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.borderWidth = 1.0;
        whiteView.layer.borderColor = COLOR_CBCBCB.CGColor;
        whiteView.backgroundColor = COLOR_FFFFFF;
        [self.contentView addSubview:whiteView];
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pointX, pointY, kImageWidth, kImageWidth)];
        _leftImageView.backgroundColor = [UIColor clearColor];
        _leftImageView.layer.cornerRadius = 5.0;
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_leftImageView];
        
        //团购类型
        UIImage *typeImage = [UIImage imageNamed:@"groupon_bg_list"];
        _goodsTypeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(whiteView.frame.origin.x + whiteView.frame.size.width - typeImage.size.width, whiteView.frame.origin.y, typeImage.size.width, typeImage.size.height)];
        _goodsTypeImageV.backgroundColor = [UIColor clearColor];
        _goodsTypeImageV.image = typeImage;
        [self.contentView addSubview:_goodsTypeImageV];
        pointX += _leftImageView.frame.size.width + 10.0;
        pointY += 2.0;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, self.frame.size.width - pointX - 10, 40)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT_14;
        _titleLabel.textColor = COLOR_333333;
        [_titleLabel setHighlightedTextColor:COLOR_FFFFFF];
        _titleLabel.numberOfLines = 2.0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_titleLabel];
        pointY += _titleLabel.frame.size.height - 4;
        
        _curPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, pointY, 50, 20)];
        _curPriceLabel.backgroundColor = [UIColor clearColor];
        _curPriceLabel.font = FONT_14;
        _curPriceLabel.textColor = COLOR_D91F1E;
        [_curPriceLabel setHighlightedTextColor:COLOR_D91F1E];
        [self.contentView addSubview:_curPriceLabel];
        pointX += _curPriceLabel.frame.size.width + 5;
        
        _oldPriceLabel = [[OCCStrikeThroughLabel alloc] initWithFrame:CGRectMake(pointX, pointY + 2, 50, 20)];
        _oldPriceLabel.backgroundColor = [UIColor clearColor];
        _oldPriceLabel.font = FONT_12;
        _oldPriceLabel.textColor = COLOR_999999;
        [_oldPriceLabel setHighlightedTextColor:COLOR_FFFFFF];
        [self.contentView addSubview:_oldPriceLabel];
        pointY += _curPriceLabel.frame.size.height - 4;
        
        _salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, pointY, self.frame.size.width - _titleLabel.frame.origin.x - 10, 20)];
        _salesLabel.backgroundColor = [UIColor clearColor];
        _salesLabel.font = FONT_12;
        _salesLabel.textColor = COLOR_999999;
        [_salesLabel setHighlightedTextColor:COLOR_FFFFFF];
        [self.contentView addSubview:_salesLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect selfRect = _selectedButton.frame;
    selfRect.size = CGSizeMake(kSelectViewWidth, self.frame.size.height);
    _selectedButton.frame = selfRect;
    
    _titleLabel.frame=CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, self.frame.size.width - _titleLabel.frame.origin.x - 10, 40);
    [_titleLabel sizeToFit];
}

- (void)initSelectedView
{
    //选择View
    UIImage *image = [UIImage imageNamed:@"checkbox_nor"];
    _selectedButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [_selectedButton addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedButton setImage:image forState:UIControlStateNormal];
    [self.contentView addSubview:_selectedButton];
}

- (void)cellSelected:(id)sender
{
    UIImage *selectedImage = [UIImage imageNamed:@"checkbox_press"];
    UIImage *image = [UIImage imageNamed:@"checkbox_nor"];
    _isSelected = !_isSelected;
    if (_isSelected)
    {
        [_selectedButton setImage:selectedImage forState:UIControlStateNormal];
    }
    else
    {
        [_selectedButton setImage:image forState:UIControlStateNormal];
    }
    
    if ([_delegate respondsToSelector:@selector(goodsCellIsSelected:withId:)])
    {
        [_delegate goodsCellIsSelected:_isSelected withId:_selectedId];
    }
}

#pragma mark -
#pragma mark Set Data
-(void)setDataForGoods:(Goods *)data
{
    if (_cellType == GoodsCellTypeSelected)
    {
        _selectedId = [data.goodsFavourID integerValue];
        [_selectedButton setImage:[UIImage imageNamed:@"checkbox_nor"] forState:UIControlStateNormal];
    }

    if (data.goodsImage && [data.goodsImage length] > 0)
    {
        NSString *strURL = [data.goodsImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strURL];
        [self.leftImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    else
    {
        [self.leftImageView setImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    
    NSString *title1 = data.goodsName;
    [_titleLabel setText:title1];
        
    NSString *title4= [NSString stringWithFormat:@"￥%@",data.goodsPLPrice];
    [_curPriceLabel setText:title4];
    [_curPriceLabel sizeToFit];
    
    NSString *title3=[NSString stringWithFormat:@"￥%@",data.goodsListPrice];
    [_oldPriceLabel setText:title3];
    [_oldPriceLabel sizeToFit];
    
    NSString *title5= [NSString stringWithFormat:@"%@%@%@",@"月销量:",data.goodsSellNum,@"件"];
    [_salesLabel setText:title5];
    
    NSString *title6 = nil;
    [_locationLabel setText:title6];
    
    NSInteger goodsType = [data.goodsType integerValue];
    if (goodsType == 0)
    {
        //商品
        _goodsTypeImageV.hidden = YES;
    }
    else if (goodsType == 1)
    {
        //团购
        _goodsTypeImageV.hidden = NO;
    }
    
    CGRect selfRect = _oldPriceLabel.frame;
    selfRect.origin.x = _curPriceLabel.frame.origin.x + _curPriceLabel.frame.size.width + 5;
    _oldPriceLabel.frame = selfRect;
}

//团购解析
-(void)setDataForGroupOn:(NSDictionary*)data
{
    //搜索商品显示的字段
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dic setObject:[data objectForKey:@"image"] forKey:@"image"];
    [dic setObject:[data objectForKey:@"name"] forKey:@"name"];
    [dic setObject:[data objectForKey:@"plPrice"] forKey:@"plPrice"];
    [dic setObject:[data objectForKey:@"listPrice"] forKey:@"listPrice"];
    [dic setObject:[data objectForKey:@"sellNum"] forKey:@"sellNumMonth"];
    if (_cellType == GoodsCellTypeSelected)
    {
        [dic setObject:[data objectForKey:KEY_FAVOURID] forKey:KEY_FAVOURID];
    }
    Goods *goods = [Goods goodsWithDic:dic];
    [self setDataForGoods:goods];
}


@end
