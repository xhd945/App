//
//  UILabel+Extra.m
//  occ
//
//  Created by zhangss on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "UILabel+Extra.h"

@implementation UILabel (Extra)

- (void)labelWithType:(OCCLabelType)type
{
    self.backgroundColor = [UIColor clearColor];
    switch (type) {
        case OCCLabelTypeNavigationTitle:
        {
            self.font = FONT_BOLD_20;
            self.textColor = COLOR_FFFFFF;
            self.textAlignment = UITextAlignmentCenter;
            break;
        }
        case OCCLabelTypeLeftNavigationTitle:
        {
            self.font = FONT_20;
            self.textColor = COLOR_FFFFFF;
            self.textAlignment = UITextAlignmentCenter;
            break;
        }
        case OCCLabelTypeRightNavigationTitle:
        {
            self.font = FONT_20;
            self.textColor = COLOR_FFFFFF;
            self.textAlignment = UITextAlignmentLeft;
            break;
        }
        default:
            break;
    }
}

@end
