//
//  GrouponNoticeCell.h
//  occ
//
//  Created by RS on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponNoticeCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *notifyLabel;

@property(nonatomic,strong) NSMutableDictionary* data;
@property(nonatomic,assign) float height;

-(void)setData:(NSDictionary*)data;

-(float)getCellHeight;

@end
