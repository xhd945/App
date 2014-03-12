//
//  GoodsGredCell.m
//  occ
//
//  Created by zhangss on 13-9-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsGredCell.h"

#define kImageWidth 125.0
#define kCellHeight 200.0

@implementation GoodsGredCell

#pragma mark -
#pragma mark Init / Dealloc
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _isFavorite = NO;
        _isFavoriteTwo = NO;
        _isInCart = NO;
        _isInCartTwo = NO;
        _favoriteImage = [UIImage imageNamed:@"btn_favorite_press"];
        _unFavoriteImage = [UIImage imageNamed:@"btn_favorite_nor"];
        _cartImage = [UIImage imageNamed:@"btn_shopcar_press"];
        _unCartImage = [UIImage imageNamed:@"btn_shopcar_nor"];
        
        _bgView = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width/2 - 10 - 10/2, kCellHeight-10)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5.0;
        _bgView.layer.borderWidth = 1.0;
        _bgView.layer.borderColor = COLOR_CBCBCB.CGColor;
        _bgView.hidden = YES;
        [_bgView addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_bgView];
        
        _bgViewTwo = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 10/2, 0, self.frame.size.width/2 - 10 - 10/2, kCellHeight-10)];
        _bgViewTwo.backgroundColor = [UIColor whiteColor];
        _bgViewTwo.layer.cornerRadius = 5.0;
        _bgViewTwo.layer.borderWidth = 1.0;
        _bgViewTwo.layer.borderColor = COLOR_CBCBCB.CGColor;
        _bgViewTwo.hidden = YES;
        [_bgViewTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_bgViewTwo];
        
        //View One
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kImageWidth, kImageWidth)];
        _goodImageView.backgroundColor = [UIColor clearColor];
        _goodImageView.layer.cornerRadius = 5.0;
        _goodImageView.layer.masksToBounds = YES;
        _goodImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bgView addSubview:_goodImageView];
        
        UIImage *typeImage = [UIImage imageNamed:@"groupon_bg"];
        _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgView.frame.size.width - typeImage.size.width, 0, typeImage.size.width, typeImage.size.height)];
        _typeImageView.backgroundColor = [UIColor clearColor];
        _typeImageView.image = typeImage;
        _typeImageView.hidden = YES;
        [_bgView addSubview:_typeImageView];
    
        UIImage *priceBG = [UIImage imageNamed:@"price_tag"];
        _priceBGView = [[UIImageView alloc] initWithFrame:CGRectMake(7, _goodImageView.frame.size.height + _goodImageView.frame.origin.y - priceBG.size.height, priceBG.size.width, priceBG.size.height)];
        _priceBGView.backgroundColor = [UIColor clearColor];
        _priceBGView.image = [priceBG stretchableImageWithLeftCapWidth:priceBG.size.width / 2 topCapHeight:priceBG.size.height / 2];
        [_bgView addSubview:_priceBGView];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 7, _priceBGView.frame.size.width - 14, _priceBGView.frame.size.height - 8)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = FONT_14;
        _priceLabel.textColor = COLOR_D91F1E;
        [_priceBGView addSubview:_priceLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_goodImageView.frame.origin.y + _goodImageView.frame.size.height + 5, kImageWidth, 35)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT_14;
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.textColor = COLOR_333333;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_bgView addSubview:_titleLabel];
        
        _favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,_titleLabel.frame.origin.y + _titleLabel.frame.size.height -10, 60, 35)];
        [_favoriteBtn setImage:_unFavoriteImage forState:UIControlStateNormal];
        [_favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        _favoriteBtn.titleLabel.font = FONT_10;
        [_favoriteBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_favoriteBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_favoriteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        //[_bgView addSubview:_favoriteBtn];
        
        _addCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(_bgView.frame.size.width - 10 - 60,_favoriteBtn.frame.origin.y, 60, 35)];
        [_addCartBtn setImage:_unCartImage forState:UIControlStateNormal];
        [_addCartBtn setTitle:@"购物车" forState:UIControlStateNormal];
        _addCartBtn.titleLabel.font = FONT_10;
        [_addCartBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_addCartBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_addCartBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        //[_bgView addSubview:_addCartBtn];
        
        //View Two
        _goodImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kImageWidth, kImageWidth)];
        _goodImageViewTwo.backgroundColor = [UIColor clearColor];
        _goodImageViewTwo.layer.cornerRadius = 5.0;
        _goodImageViewTwo.layer.masksToBounds = YES;
        _goodImageViewTwo.contentMode = UIViewContentModeScaleAspectFit;
        [_bgViewTwo addSubview:_goodImageViewTwo];
        
        _typeImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(_bgViewTwo.frame.size.width - typeImage.size.width, 0, typeImage.size.width, typeImage.size.height)];
        _typeImageViewTwo.backgroundColor = [UIColor clearColor];
        _typeImageViewTwo.image = typeImage;
        _typeImageViewTwo.hidden = YES;
        [_bgViewTwo addSubview:_typeImageViewTwo];
        
        _priceBGViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(7, _goodImageView.frame.origin.y + _goodImageView.frame.size.height - priceBG.size.height, priceBG.size.width, priceBG.size.height)];
        _priceBGViewTwo.backgroundColor = [UIColor clearColor];
        _priceBGViewTwo.image = [priceBG stretchableImageWithLeftCapWidth:priceBG.size.width / 2 topCapHeight:priceBG.size.height / 2];
        [_bgViewTwo addSubview:_priceBGViewTwo];
        
        _priceLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(13, 7, _priceBGViewTwo.frame.size.width - 15, _priceBGViewTwo.frame.size.height - 7)];
        _priceLabelTwo.backgroundColor = [UIColor clearColor];
        _priceLabelTwo.font = FONT_14;
        _priceLabelTwo.textColor = COLOR_D91F1E;
        [_priceBGViewTwo addSubview:_priceLabelTwo];
        
        _titleLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(10,_goodImageViewTwo.frame.origin.y + _goodImageViewTwo.frame.size.height + 5, kImageWidth, 35)];
        _titleLabelTwo.backgroundColor = [UIColor clearColor];
        _titleLabelTwo.font = FONT_14;
        _titleLabelTwo.textColor = COLOR_333333;
        _titleLabelTwo.numberOfLines = 2;
        _titleLabelTwo.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabelTwo.textAlignment = NSTextAlignmentLeft;
        [_bgViewTwo addSubview:_titleLabelTwo];
        
        _favoriteBtnTwo = [[UIButton alloc] initWithFrame:CGRectMake(10,_titleLabelTwo.frame.origin.y + _titleLabelTwo.frame.size.height -10, 60, 35)];
        [_favoriteBtnTwo setImage:_unFavoriteImage forState:UIControlStateNormal];
        [_favoriteBtnTwo setTitle:@"收藏" forState:UIControlStateNormal];
        _favoriteBtnTwo.titleLabel.font = FONT_10;
        [_favoriteBtnTwo setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_favoriteBtnTwo setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_favoriteBtnTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[_bgViewTwo addSubview:_favoriteBtnTwo];
        
        _addCartBtnTwo = [[UIButton alloc] initWithFrame:CGRectMake(_bgViewTwo.frame.size.width - 10 - 60,_favoriteBtnTwo.frame.origin.y, 60, 35)];
        [_addCartBtnTwo setImage:_unCartImage forState:UIControlStateNormal];
        [_addCartBtnTwo setTitle:@"购物车" forState:UIControlStateNormal];
        _addCartBtnTwo.titleLabel.font = FONT_10;
        [_addCartBtnTwo setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_addCartBtnTwo setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_addCartBtnTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[_bgViewTwo addSubview:_addCartBtnTwo];
    }
    return self;
}

- (void)dealloc
{
   
}

- (void)setGoodsDataOne:(Goods *)data
{
    _cellData = data;
    _bgView.hidden = NO;
    _bgViewTwo.hidden = YES;
    _typeImageView.hidden = YES;

    if (data.goodsImage && [data.goodsImage length] > 0)
    {
        NSString *strURL  = [data.goodsImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strURL];
        [_goodImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    else
    {
        [_goodImageView setImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    
    NSString *tempStr = data.goodsName;
    [_titleLabel setText:tempStr];
    [_titleLabel sizeToFit];
        
    tempStr = [NSString stringWithFormat:@"￥%@",data.goodsPLPrice];
    [_priceLabel setText:tempStr];
    [_priceLabel sizeToFit];
            
    NSInteger goodsType = [data.goodsType integerValue];
    if (goodsType == 0)
    {
        //商品
        _typeImageView.hidden = YES;
    }
    else if (goodsType == 1)
    {
        //团购
        _typeImageView.hidden = NO;
    }
    
    if (data.goodsIsFavour && [data.goodsIsFavour integerValue] == 1)
    {
        [_favoriteBtn setImage:_favoriteImage forState:UIControlStateNormal];
        _isFavorite = YES;
    }
    else
    {
        [_favoriteBtn setImage:_unFavoriteImage forState:UIControlStateNormal];
    }
    
    if (data.goodsIsCart && [data.goodsIsCart integerValue] == 1)
    {
        [_addCartBtn setImage:_cartImage forState:UIControlStateNormal];
        _isInCart = YES;
    }
    else
    {
        [_addCartBtn setImage:_unCartImage forState:UIControlStateNormal];
    }
    
    CGRect selfRect = _titleLabel.frame;
    selfRect.size.width = kImageWidth;
    _titleLabel.frame = selfRect;
    
    selfRect = _priceBGView.frame;
    selfRect.size.width = _priceLabel.frame.size.width + 20;
    _priceBGView.frame = selfRect;

}

- (void)setGoodsDataTwo:(Goods *)data
{
    _cellDataTwo = data;
    _bgViewTwo.hidden = NO;
    _typeImageViewTwo.hidden = YES;
    
    if (data.goodsImage && [data.goodsImage length] > 0)
    {
        NSString *strURL  = [data.goodsImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strURL];
        [_goodImageViewTwo setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    else
    {
        [_goodImageViewTwo setImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    
    NSString *tempStr = data.goodsName;
    [_titleLabelTwo setText:tempStr];
    [_titleLabelTwo sizeToFit];
    
    tempStr = [NSString stringWithFormat:@"￥%@",data.goodsPLPrice];
    [_priceLabelTwo setText:tempStr];
    [_priceLabelTwo sizeToFit];
    
    NSInteger goodsType = [data.goodsType integerValue];
    if (goodsType == 0)
    {
        //商品
        _typeImageViewTwo.hidden = YES;
    }
    else if (goodsType == 1)
    {
        //团购
        _typeImageViewTwo.hidden = NO;
    }
    
    if (data.goodsIsFavour && [data.goodsIsFavour integerValue] == 1)
    {
        [_favoriteBtnTwo setImage:_favoriteImage forState:UIControlStateNormal];
        _isFavoriteTwo = YES;
    }
    else
    {
        [_favoriteBtnTwo setImage:_unFavoriteImage forState:UIControlStateNormal];
    }
    
    if (data.goodsIsCart && [data.goodsIsCart integerValue] == 1)
    {
        [_addCartBtnTwo setImage:_cartImage forState:UIControlStateNormal];
        _isInCartTwo = YES;
    }
    else
    {
        [_addCartBtnTwo setImage:_unCartImage forState:UIControlStateNormal];
    }
    
    CGRect selfRect = _titleLabelTwo.frame;
    selfRect.size.width = kImageWidth;
    _titleLabelTwo.frame = selfRect;
    
    selfRect = _priceBGViewTwo.frame;
    selfRect.size.width = _priceLabelTwo.frame.size.width + 20;
    _priceBGViewTwo.frame = selfRect;
}

- (void)buttonClicked:(id)sender
{
    UIButton *tapButton = (UIButton *)sender;
    if (tapButton == _bgView)
    {
        if ([_delegate respondsToSelector:@selector(didSelectedIndexWithData:)])
        {
            [_delegate didSelectedIndexWithData:_cellData];
        }
        return;
    }
    else if (tapButton == _bgViewTwo)
    {
        if ([_delegate respondsToSelector:@selector(didSelectedIndexWithData:)])
        {
            [_delegate didSelectedIndexWithData:_cellDataTwo];
        }
        return;
    }
}

- (void)changeFavoriteUI:(BOOL)isFavorite andGoodsId:(NSNumber *)goodsId
{
    if ([goodsId intValue] == [_cellData.goodsID intValue])
    {
        if (isFavorite)
        {
            [_favoriteBtn setImage:_favoriteImage forState:UIControlStateNormal];
            _cellData.goodsIsFavour = [NSNumber numberWithInteger:1];
        }
        else
        {
            [_favoriteBtn setImage:_unFavoriteImage forState:UIControlStateNormal];
        }
        _isFavorite = isFavorite;
    }
    else if ([goodsId intValue] == [_cellDataTwo.goodsID intValue])
    {
        if (isFavorite)
        {
            [_favoriteBtnTwo setImage:_favoriteImage forState:UIControlStateNormal];
            _cellDataTwo.goodsIsFavour = [NSNumber numberWithInteger:1];
        }
        else
        {
            [_favoriteBtnTwo setImage:_unFavoriteImage forState:UIControlStateNormal];
        }
        _isFavoriteTwo = isFavorite;
    }
}

- (void)changeCartUI:(BOOL)isInCart andData:(NSNumber *)goodsID
{
    if ([goodsID isEqualToNumber:_cellData.goodsID])
    {
        if (isInCart)
        {
            [_addCartBtn setImage:_cartImage forState:UIControlStateNormal];
            _cellData.goodsIsCart = [NSNumber numberWithInteger:1];
        }
        else
        {
            [_addCartBtn setImage:_unCartImage forState:UIControlStateNormal];
        }
        _isInCart = isInCart;
    }
    else
    {
        if (isInCart)
        {
            [_addCartBtnTwo setImage:_cartImage forState:UIControlStateNormal];
            _cellDataTwo.goodsIsCart = [NSNumber numberWithInteger:1];
        }
        else
        {
            [_addCartBtnTwo setImage:_unCartImage forState:UIControlStateNormal];
        }
        _isInCartTwo = isInCart;
    }
}

@end
