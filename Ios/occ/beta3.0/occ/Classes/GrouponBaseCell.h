//
//  GrouponBaseCell.h
//  occ
//
//  Created by RS on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponBaseCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *leftImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UIButton *btn1;
@property (strong, nonatomic)  UIButton *btn2;
@property (strong, nonatomic)  UIButton *btn3;

@property (strong, nonatomic) NSDictionary *data;

-(void)setData:(NSDictionary*)data;
-(float)getCellHeight;
@end
