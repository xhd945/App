//
//  OrderGrouponCell.h
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderGrouponCell : UITableViewCell
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *grouponImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIView *confirmButton;

-(void)setData:(NSDictionary*)data;

@end
