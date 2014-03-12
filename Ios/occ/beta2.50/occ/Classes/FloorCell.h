//
//  FloorCell.h
//  occ
//
//  Created by RS on 13-8-19.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviData.h"

@interface FloorCell : UITableViewCell

@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *descLabel;
@property (strong, nonatomic)  UIImageView *floorImage;

-(void)setData:(NaviData *)data;

@end
