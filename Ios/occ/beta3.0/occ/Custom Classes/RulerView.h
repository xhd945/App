//
//  RulerView.h
//  occ
//
//  Created by zhangss on 13-9-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulerView : UIView

@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)UIFont  *textFont;
@property (nonatomic,strong)UIColor *textColor;

- (id)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArr;

@end
