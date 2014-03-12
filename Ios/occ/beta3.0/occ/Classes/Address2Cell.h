//
//  AddressModifyCell.h
//  occ
//
//  Created by RS on 13-8-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Address2Cell : UITableViewCell
@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic)  UIButton *confirmButton;
@property (strong, nonatomic)  UIImageView *lineImageView;
@property (strong, nonatomic)  UIImageView *checkImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *phoneLabel;
@property (strong, nonatomic)  UILabel *addressLabel;
@property (strong, nonatomic)  UILabel *detailLabel;
@property (strong, nonatomic)  UIButton *editButton;

- (void)doEdit:(id)sender;

-(void)setData:(NSDictionary*)data;

@end
