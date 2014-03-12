//
//  GoodsGredCell.h
//  occ
//
//  Created by zhangss on 13-9-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"

@protocol GoodsGredCellDelegate <NSObject>

- (void)didSelectedIndexWithData:(Goods *)data;

@end

@interface GoodsGredCell : UITableViewCell
{
    UIButton    *_bgView;
    UIImageView *_goodImageView;
    UIImageView *_priceBGView;
    UIImageView *_typeImageView;
    UILabel     *_priceLabel;
    UILabel     *_titleLabel;
    UIButton    *_favoriteBtn;
    UIButton    *_addCartBtn;
    
    BOOL        _isFavorite;
    BOOL        _isInCart;
    UIImage     *_favoriteImage;
    UIImage     *_unFavoriteImage;
    UIImage     *_cartImage;
    UIImage     *_unCartImage;
    
    UIButton    *_bgViewTwo;
    UIImageView *_goodImageViewTwo;
    UIImageView *_priceBGViewTwo;
    UIImageView *_typeImageViewTwo;
    UILabel     *_priceLabelTwo;
    UILabel     *_titleLabelTwo;
    UIButton    *_favoriteBtnTwo;
    UIButton    *_addCartBtnTwo;
    
    BOOL        _isFavoriteTwo;
    BOOL        _isInCartTwo;
}
@property (nonatomic,strong) Goods *cellData;
@property (nonatomic,strong) Goods *cellDataTwo;
@property (nonatomic,assign) id <GoodsGredCellDelegate>delegate;

- (void)setGoodsDataOne:(Goods *)data;
- (void)setGoodsDataTwo:(Goods *)data;

@end
