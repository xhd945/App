//
//  Home2Cell.h
//  occ
//
//  Created by RS on 13-8-20.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisementSeat.h"
#import "Advertisement.h"

@protocol Home2CellDelegate <NSObject>

- (void)doubleAdverTaped:(Advertisement *)tempAdver;

@end

@interface Home2Cell : UITableViewCell
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property (assign, nonatomic) id <Home2CellDelegate>delegate;
@property (strong, nonatomic) AdvertisementSeat *adSeat;

-(void)setData:(AdvertisementSeat *)tempSeat;

@end
