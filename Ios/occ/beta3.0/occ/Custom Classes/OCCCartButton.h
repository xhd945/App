//
//  OCCCartButton.h
//  occ
//
//  Created by plocc on 13-12-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCCCartButton : UIButton
@property(nonatomic,strong) UILabel *badgeLabel;
@property(nonatomic,strong) UIImageView *bgImageView;

- (void)setCount:(NSInteger)count;

@end
