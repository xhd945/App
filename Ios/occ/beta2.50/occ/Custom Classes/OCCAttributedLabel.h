//
//  OOCAttributedLabel.h
//  occ
//
//  Created by zhangss on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface OCCAttributedLabel : UILabel
{
    NSMutableAttributedString *_attributeString;
    CATextLayer               *_textLayer;
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;
- (void)setColor:(UIColor *)color withText:(NSString *)str;

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

@end
