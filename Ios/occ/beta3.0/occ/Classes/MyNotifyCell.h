//
//  MyNotifyCell.h
//  occ
//
//  Created by RS on 13-10-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNotifyCell : UITableViewCell
@property (strong, nonatomic)  UIView *whiteImageView;
@property (strong, nonatomic)  UIImageView *userImageView;
@property (strong, nonatomic)  UIImageView *typeImageView;
@property (strong, nonatomic)  UIImageView *timeImageView;
@property (strong, nonatomic)  UIImageView *arrowImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *descLabel;

-(void)setData:(NSDictionary*)data;

+(float)getCellHeight:(NSDictionary*)data;

@end
