//
//  CartHeadCell.h
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCellDelegate.h"

@interface CartHeadCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *lineImageView;
@property (strong, nonatomic)  UIButton *checkButton;
@property (strong, nonatomic)  UIButton *editButton;
@property (strong, nonatomic)  UILabel *nameLabel;

@property (assign, nonatomic) id<CartCellDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *data;

-(void)setData:(NSMutableDictionary*)data;

- (void)doCkeck:(id)sender;
- (void)doEdit:(id)sender;

@end
