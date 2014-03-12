//
//  Address1Cell.h
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Address1Cell : UITableViewCell
@property (strong, nonatomic)  UIImageView *lineImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *phoneLabel;
@property (strong, nonatomic)  UIImageView *phoneImageView;
@property (strong, nonatomic)  UILabel *addressLabel;

-(void)setData:(NSDictionary*)data;

@end
