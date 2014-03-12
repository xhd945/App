//
//  MyOOrderStatusCell.h
//  occ
//
//  Created by RS on 13-11-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOOrderStatusCell : UITableViewCell
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIButton *statustButton;
@property (strong, nonatomic) UILabel *statustLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) NSDictionary *data;

-(void)setData:(NSDictionary*)data;
@end
