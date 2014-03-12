//
//  MyOOrderTotalCell.h
//  occ
//
//  Created by RS on 13-11-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOOrderTotalCell : UITableViewCell
@property (strong, nonatomic) UILabel *totlePriceLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *totleNumberLabel;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UIView *confirmButton;

@property (strong, nonatomic) NSMutableDictionary *data;

-(void)setData:(NSMutableDictionary*)data;
@end
