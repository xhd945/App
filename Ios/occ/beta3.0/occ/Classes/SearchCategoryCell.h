//
//  SearchCategoryCell.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCategoryCell : UITableViewCell
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

-(void)setData:(NSDictionary*)data;

@end
