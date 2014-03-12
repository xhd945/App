//
//  GoodsFootCell.h
//  occ
//
//  Created by RS on 13-11-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsFootCellDelegate <NSObject>
- (void)goodsAddToCart;
- (void)goodsAddToFavorite;
@end

@interface GoodsFootCell : UITableViewCell
@property(nonatomic,strong) UIButton *cartButton;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UIButton *logoButton;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *typeLabel;
@property(nonatomic,strong) UIButton *favoriteShopButton;
@property(nonatomic,strong) OCCAttributedLabel *favoriteShopLabel;
@property(nonatomic,strong) UIButton *chatButton;
@property(nonatomic,strong) UIButton *favoriteItemButton;
@property(nonatomic,strong) UIButton *toshopButton;

@property(nonatomic,strong) UIImage *redImage;
@property(nonatomic,strong) UIImage *grayImage;
@property(nonatomic,strong) NSDictionary *shopData;
@property(nonatomic,assign) id<GoodsFootCellDelegate>delegate;

-(void)setData:(NSDictionary*)data;

-(float)getCellHeight;
@end
