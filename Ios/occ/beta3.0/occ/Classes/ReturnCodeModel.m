//
//  ReturnCodeModel.m
//  occ
//
//  Created by zhangss on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ReturnCodeModel.h"

@implementation ReturnCodeModel

- (id)initWithCode:(NSInteger)code andDesc:(NSString *)desc
{
    self = [super init];
    if (self)
    {
        _code = code;
        _codeDesc = desc;
    }
    return self;
}

@end
