//
//  GrouponCell.h
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponCell : UITableViewCell
@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UIImageView *goodsImageView;
@property (strong, nonatomic) UIImageView *sellOutImageView;
@property (strong, nonatomic) UIImageView *juanImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) OCCStrikeThroughLabel *listPriceLabel;
@property (strong, nonatomic) UILabel *plPriceLabel;
@property (strong, nonatomic) UILabel *discountLabel;
@property (strong, nonatomic) UILabel *buyNumLabel;

-(void)setData:(NSDictionary*)data;

@end
