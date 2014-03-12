//
//  OrderStatusCell.h
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderStatusCell : UITableViewCell
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIButton *statustButton;

@property (strong, nonatomic) NSDictionary *data;

-(void)setData:(NSDictionary*)data;
@end
