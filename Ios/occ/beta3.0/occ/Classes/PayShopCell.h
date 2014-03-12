//
//  PayTotalCell.h
//  occ
//
//  Created by RS on 13-8-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayShopCell : UITableViewCell

@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImageView *shopImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *totalPriceLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *totalNumLabel;
@property (strong, nonatomic) UILabel *numLabel;

-(void)setData:(NSDictionary*)data;

@end
