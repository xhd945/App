//
//  TwoLineCell.h
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TwoLineCellRightStyle) {
    TwoLineCellRightNone,
    TwoLineCellRightCheck,
    TwoLineCellRightGou
};

@interface TwoLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (assign,nonatomic) TwoLineCellRightStyle rightStyle;

-(void)setData:(NSDictionary*)data;

@end
