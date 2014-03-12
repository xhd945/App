//
//  RulerView.m
//  occ
//
//  Created by zhangss on 13-9-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "RulerView.h"

#define kLineHeight 15

@implementation RulerView

- (id)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titleArray = [[NSArray alloc] initWithArray:titleArr];
        _textFont = FONT_12;
        _textColor = COLOR_D1BEB0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, COLOR_BG_CLASSTWO.CGColor);
    CGContextFillRect(context, rect);
    
    CGFloat inteval = rect.size.width / ([_titleArray count] - 1);
    for (int i = 0; i < [_titleArray count]; i++)
    {
        //Draw Line
        if (i != 0 && i != ([_titleArray count] - 1))
        {
            CGContextSetLineWidth(context, 1.0);
            CGContextSetStrokeColorWithColor(context, _textColor.CGColor);
            CGContextMoveToPoint(context, i * inteval, rect.size.height - kLineHeight);
            CGContextAddLineToPoint(context, i * inteval, rect.size.height);
            CGContextStrokePath(context);
        }
        
        //
        NSString *tempStr = [_titleArray objectAtIndex:i];
        CGSize textSize = [tempStr sizeWithFont:_textFont];
        CGFloat pointX = 0;
        if (i == 0)
        {
            pointX = i * inteval;
        }
        else if (i == ([_titleArray count] - 1))
        {
            pointX = i * inteval - textSize.width;
        }
        else
        {
            pointX = i * inteval - textSize.width / 2;
        }
        CGContextSetLineWidth(context, 1.0);
        CGContextSetFillColorWithColor(context, _textColor.CGColor);
        [tempStr drawInRect:CGRectMake(pointX, rect.size.height - kLineHeight - 10/5 - textSize.height, textSize.width, textSize.height) withFont:_textFont];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
