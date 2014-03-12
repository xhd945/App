//
//  Search12Cell.h
//  occ
//
//  Created by RS on 13-8-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCategory2Cell : UITableViewCell
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UILabel *leftLabel;

-(void)setData:(NSDictionary*)data;

@end
