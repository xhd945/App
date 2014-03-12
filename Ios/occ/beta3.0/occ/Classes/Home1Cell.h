//
//  Home1Cell.h
//  occ
//
//  Created by RS on 13-8-20.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Advertisement.h"
#import "AdvertisementSeat.h"

@protocol Home1CellDelegate <NSObject>
//广告点击回调
- (void)singleAdverTaped:(Advertisement *)adver;

@end

@interface Home1Cell : UITableViewCell

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *fullImageView;
@property (assign, nonatomic) id <Home1CellDelegate>delegate;
@property (strong, nonatomic) AdvertisementSeat *adSeat;

-(void)setData:(AdvertisementSeat *)adSeat;

@end
