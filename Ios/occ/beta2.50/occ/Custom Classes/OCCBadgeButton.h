//
//  OCCOrderButton.h
//  occ
//
//  Created by plocc on 13-12-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCCBadgeButton : UIButton
@property (nonatomic,strong) UILabel *badgeLabel;

- (void)setCount:(NSInteger)count;
@end
