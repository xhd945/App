//
//  ActivityCell.h
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface ActivityCell : UITableViewCell

@property (strong, nonatomic) UIView *whiteView;
@property(nonatomic,strong)UIImageView *activityImageView;
@property (strong, nonatomic) UILabel *nameLabel;

-(void)setData:(NSDictionary *)data;
@end
