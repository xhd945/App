//
//  MsgCell.h
//  occ
//
//  Created by RS on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMsgCell : UITableViewCell
@property (strong, nonatomic)  UIView *whiteImageView;
@property (strong, nonatomic)  UIImageView *userImageView;
@property (strong, nonatomic)  UIImageView *typeImageView;
@property (strong, nonatomic)  UIImageView *timeImageView;
@property (strong, nonatomic)  UIImageView *arrowImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *descLabel;

-(void)setData:(NSDictionary*)data;

@end
