//
//  CouponCell.h
//  occ
//
//  Created by RS on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGrouponCell : UITableViewCell
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *codeLabel;
@property (strong, nonatomic)  UILabel *timeLabel;

-(void)setData:(NSDictionary*)data;

@end
