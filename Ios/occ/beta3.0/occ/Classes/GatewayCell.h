//
//  GatewayCell.h
//  occ
//
//  Created by RS on 13-11-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GatewayCell : UITableViewCell
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UILabel *leftLabel;

-(void)setData:(NSDictionary*)data;

@end
