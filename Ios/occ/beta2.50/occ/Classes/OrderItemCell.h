//
//  OrderItemCell.h
//  occ
//
//  Created by RS on 13-9-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemCell : UITableViewCell
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *typeImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UILabel *sizeLabel;
@property (strong, nonatomic) UILabel *bargainLabel;
@property (strong, nonatomic) UIButton *tuiButton;

@property (strong, nonatomic) NSDictionary *data;

-(void)setData:(NSDictionary*)data;

@end
