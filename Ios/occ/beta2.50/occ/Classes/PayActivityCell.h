//
//  PayActivityCell.h
//  occ
//
//  Created by RS on 13-8-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayActivityCell : UITableViewCell
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UILabel *bargainLabel;

-(void)setData:(NSDictionary*)data;

@end
