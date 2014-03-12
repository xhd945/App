//
//  GrouponShopCell.h
//  occ
//
//  Created by RS on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponShopCell : UITableViewCell
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *lineLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *scoreButton;
@property (strong, nonatomic) UIButton *upDownButton;
@property (strong, nonatomic) UIImageView *upDownImageView;

@property(nonatomic,assign) int expand;
@property(nonatomic,strong) NSMutableDictionary* data;

-(void)setData:(NSDictionary*)data;

-(float)getCellHeight;

@end
