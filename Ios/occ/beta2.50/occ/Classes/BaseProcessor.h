//
//  BaseProcessor.h
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "ReturnCodeModel.h"

@interface BaseProcessor : NSObject
{
    SBJsonParser *_jsonParser;
    SBJsonWriter *_jsonWriter;
}

- (ReturnCodeModel *)getReturnCodeFromRequest:(ASIHTTPRequest *)request;

@end
