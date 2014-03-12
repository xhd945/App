//
//  UILabel+Extra.h
//  occ
//
//  Created by zhangss on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extra)

typedef NS_ENUM(NSInteger, OCCLabelType)
{
    OCCLabelTypeNavigationTitle,
    OCCLabelTypeLeftNavigationTitle,
    OCCLabelTypeRightNavigationTitle,
    OCCLabelTypeOther
};

- (void)labelWithType:(OCCLabelType)type;

@end
