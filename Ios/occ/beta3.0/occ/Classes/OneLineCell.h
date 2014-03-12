//
//  WhiteCell.h
//  occ
//
//  Created by RS on 13-8-27.
//  Copyright (c) 2013年 RS. All rights reserved.
//

typedef NS_ENUM(NSInteger, OneLineCellStyle) {
    OneLineCellStyleDefault,
    OneLineCellStyleValue,
    OneLineCellStyleSubtitle
};

typedef NS_ENUM(NSInteger, OneLineCellLineType)
{
    OneLineCellLineTypeNone,
    OneLineCellLineTypeLineDot,
    OneLineCellLineTypeLine1,
};

typedef NS_ENUM(NSInteger, OneLineCellRightStyle) {
    OneLineCellRightNone,
    OneLineCellRightCheck,
    OneLineCellRightGou
};

#import <UIKit/UIKit.h>

@interface OneLineCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *lineImageView;
@property (strong, nonatomic)  UIImageView *rightImageView;
@property (strong, nonatomic)  UILabel *leftTextLabel;
@property (strong, nonatomic)  UILabel *leftValueLabel;

@property(assign,nonatomic) OneLineCellLineType lineStyle;
@property(assign,nonatomic) OneLineCellRightStyle rightStyle;
@property(assign,nonatomic) OneLineCellStyle cellStyle;
@property(assign,nonatomic) CGFloat adjustY;  //微调Label的Y坐标 如果不需要居中则可以设置

- (void)setData:(NSDictionary*)data;

@end
