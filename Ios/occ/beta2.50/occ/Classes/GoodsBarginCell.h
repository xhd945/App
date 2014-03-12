//
//  GoodsBarginCell.h
//  occ
//
//  Created by RS on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsBarginCell : UITableViewCell
@property(nonatomic,strong)UILabel *barginLabel;

@property(nonatomic,strong) NSDictionary *shopData;

-(void)setData:(NSDictionary*)data;

-(float)getCellHeight;

@end
