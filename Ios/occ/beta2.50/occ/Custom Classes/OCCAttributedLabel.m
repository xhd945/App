//
//  OOCAttributedLabel.m
//  occ
//
//  Created by zhangss on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCAttributedLabel.h"

@implementation OCCAttributedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_textLayer == nil)
    {
        _textLayer = [CATextLayer layer];
        _textLayer.contentsScale = 2.0;
        [self.layer addSublayer:_textLayer];
    }
    _textLayer.string = _attributeString;
    _textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (text == nil)
    {
        _attributeString = nil;
    }
    else
    {
        _attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length
{
    if (location < 0 ||
        location > self.text.length - 1 ||
        length + location > self.text.length)
    {
        return;
    }
    
    [_attributeString addAttribute:(NSString *)kCTForegroundColorAttributeName
                            value:(id)color.CGColor
                            range:NSMakeRange(location, length)];
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color withText:(NSString *)str
{
    NSRange textRage = [self.text rangeOfString:str];
    if (textRage.location > self.text.length - 1 ||
        textRage.length + textRage.location > self.text.length)
    {
        return;
    }
    
    [_attributeString addAttribute:(NSString *)kCTForegroundColorAttributeName
                             value:(id)color.CGColor
                             range:textRage];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length
{
    if (location < 0 ||
        location > self.text.length - 1 ||
        length + location > self.text.length)
    {
        return;
    }
    
    [_attributeString addAttribute:(NSString *)kCTFontAttributeName
                            value:(__bridge id)CTFontCreateWithName((__bridge CFStringRef)font.fontName,
                                                           font.pointSize,
                                                           NULL)
                            range:NSMakeRange(location, length)];
}


@end
