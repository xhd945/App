//
//  OrderNoCell.h
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderNoCell : UITableViewCell

@property (strong, nonatomic) UILabel *orderNoLabel;
@property (strong, nonatomic) UILabel *alipayNoLabel;
@property (strong, nonatomic) UILabel *timeLabel;

-(void)setData:(NSDictionary*)data;

@end
