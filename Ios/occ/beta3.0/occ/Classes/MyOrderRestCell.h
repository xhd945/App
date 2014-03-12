//
//  OrderNext2Cell.h
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderRestCell : UITableViewCell
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UILabel *nameLabel;

-(void)setData:(NSDictionary*)data;

@end
