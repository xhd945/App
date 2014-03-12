//
//  NearbyCell.h
//  occ
//
//  Created by RS on 13-9-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCRatingView.h"

@interface NearbyCell : UITableViewCell
@property (strong, nonatomic) UIImageView *shopImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *briefLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *favourLabel;
@property (strong, nonatomic) UILabel *notifyLabel;
@property (strong, nonatomic) OCCRatingView *ratingView;

@property (assign, nonatomic) float height;

-(void)setData:(NSDictionary*)data;

@end
