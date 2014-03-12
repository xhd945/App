//
//  PayItemCell.h
//  occ
//
//  Created by RS on 13-8-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayItemCell : UITableViewCell
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *typeImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UILabel *sizeLabel;
@property (strong, nonatomic) UILabel *bargainLabel;

-(void)setData:(NSDictionary*)data;

@end
