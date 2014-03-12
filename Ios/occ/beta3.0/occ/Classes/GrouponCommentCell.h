//
//  GrouponCommentCell.h
//  occ
//
//  Created by mac on 13-9-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCRatingView.h"

@interface GrouponCommentCell : UITableViewCell
@property(strong,nonatomic)UILabel *userNameLabel;
@property(strong,nonatomic)OCCRatingView *ratingView;
@property(strong,nonatomic)UILabel *contentLabel;
@property(strong,nonatomic)UILabel *propLabel;
@property(strong,nonatomic)UILabel *timeLabel;

@property(assign,nonatomic)float height;

- (void)setData:(NSDictionary *)data;

@end
