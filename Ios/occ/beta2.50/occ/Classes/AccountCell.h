//
//  MyAccountCell.h
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UILabel *leftLabel;

-(void)setData:(NSDictionary*)data;

@end
