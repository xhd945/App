//
//  CartFootCell.h
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface CartFootCell : UITableViewCell
@property (strong, nonatomic)  MarqueeLabel *activityLabel;
@property (strong, nonatomic)  UILabel *priceLabel;
@property (strong, nonatomic)  UILabel *numLabel;
@property (strong, nonatomic)  UILabel *totlePriceLabel;
@property (strong, nonatomic)  UILabel *totleNumberLabel;

@property (strong, nonatomic) NSMutableDictionary *data;
@property (nonatomic,assign) NSTimer *timer;

-(void)setData:(NSMutableDictionary*)data;
@end
