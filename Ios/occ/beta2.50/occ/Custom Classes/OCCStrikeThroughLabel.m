//
//  OCCStrikeThroughLabel.m
//  occ
//
//  Created by zhangss on 13-9-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCStrikeThroughLabel.h"

@implementation OCCStrikeThroughLabel

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    
    CGSize textSize = [[self text] sizeWithFont:[self font]];
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    
    if ([self textAlignment] == UITextAlignmentRight)
    {
        lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2, strikeWidth, 1);
    }
    else if ([self textAlignment] == UITextAlignmentCenter)
    {
        lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, 1);
    }
    else
    {
        lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, 1);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, lineRect);
}


@end
