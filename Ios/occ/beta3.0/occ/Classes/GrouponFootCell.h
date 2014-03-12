//
//  GrouponFootCell.h
//  occ
//
//  Created by plocc on 13-12-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponFootCell : UITableViewCell
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

@property(nonatomic,strong) NSDictionary *shopData;

-(void)setData:(NSDictionary*)data;

-(float)getCellHeight;
@end
