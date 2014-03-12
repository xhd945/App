//
//  OrderShopCell.h
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShopCell : UITableViewCell
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImageView *shopImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *onlineButton;

@property (strong, nonatomic) NSDictionary *data;

-(void)setData:(NSDictionary*)data;

@end
