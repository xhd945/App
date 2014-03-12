//
//  YouhuiCell.h
//  occ
//
//  Created by RS on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *leftImageView;
@property (strong, nonatomic)  UILabel *leftRangeLabel;
@property (strong, nonatomic)  UILabel *leftTimeLabel;
@property (strong, nonatomic)  UILabel *leftNameLabel;
@property (strong, nonatomic)  UILabel *leftPriceLabel;
@property (strong, nonatomic)  UILabel *leftDescLabel;
@property (strong, nonatomic)  UIButton *leftButton;

@property (strong, nonatomic)  UIImageView *rightImageView;
@property (strong, nonatomic)  UILabel *rightRangeLabel;
@property (strong, nonatomic)  UILabel *rightTimeLabel;
@property (strong, nonatomic)  UILabel *rightNameLabel;
@property (strong, nonatomic)  UILabel *rightPriceLabel;
@property (strong, nonatomic)  UILabel *rightDescLabel;
@property (strong, nonatomic)  UIButton *rightButton;

-(void)setData1:(NSDictionary*)data;
-(void)setData2:(NSDictionary*)data;
@end
