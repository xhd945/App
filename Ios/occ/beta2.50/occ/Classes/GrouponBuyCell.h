//
//  GrouponBuyCell.h
//  occ
//
//  Created by plocc on 13-12-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrouponBuyCellDelegate <NSObject>
- (void)grouponBuyItem;
@end

@interface GrouponBuyCell : UITableViewCell
@property(nonatomic,strong) UIButton *cartButton;

@property(nonatomic,strong) UIImage *redImage;
@property(nonatomic,strong) UIImage *grayImage;
@property(nonatomic,assign) id<GrouponBuyCellDelegate>delegate;

-(void)setData:(NSDictionary*)data;
-(float)getCellHeight;
@end
