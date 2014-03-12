//
//  NavItemCell.h
//  occ
//
//  Created by RS on 13-8-19.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviData.h"

@interface NavItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

-(void)setData:(NaviData *)data;

@end
