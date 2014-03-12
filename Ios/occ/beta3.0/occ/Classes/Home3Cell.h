//
//  Home3Cell.h
//  occ
//
//  Created by RS on 13-8-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisementSeat.h"
#import "Advertisement.h"

@protocol Home3CellDelegate <NSObject>

- (void)circleAdverTaped:(Advertisement *)adver;

@end


@interface Home3Cell : UITableViewCell<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>

@property (assign, nonatomic) id <Home3CellDelegate>delegate;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) XLCycleScrollView *csView;

-(void)setData:(AdvertisementSeat *)adSeat;
-(void)changeImage;
@end
