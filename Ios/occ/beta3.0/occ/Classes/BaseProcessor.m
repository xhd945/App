//
//  BaseProcessor.m
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "BaseProcessor.h"
#import "OCCDefine.h"

@implementation BaseProcessor

- (id)init
{
    self = [super init];
    if (self)
    {
        _jsonParser = [[SBJsonParser alloc] init];
        _jsonWriter = [[SBJsonWriter alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Common Methods
- (ReturnCodeModel *)getReturnCodeFromRequest:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSInteger resultCode = 0;
    NSString  *codeDesc = nil;
    if (error)
    {
        //HTTP返回Error 可以继续细分
        switch (error.code)
        {
            case ASIRequestTimedOutErrorType:
            {
                resultCode = kReturnErrorTimedOut;
                codeDesc = @"请求超时!";
                break;
            }
            default:
            {
                resultCode = kReturnErrorUnKnow;
                codeDesc = [[error userInfo] objectForKey:[error domain]];
                break;
            }
        }
        ZSLog(@"Failed %@ with code %d and with userInfo %@",
              [error domain],
              [error code],
              [error userInfo]);
    }
    else
    {
        NSDictionary *root = [_jsonParser objectWithString:[request responseString]];
        NSInteger returnCode = 0;
        if (root == nil || [[root allKeys] count] == 0)
        {
            codeDesc = [request responseString];
            if (codeDesc == nil || [codeDesc length] == 0)
            {
                returnCode = kReturnErrorUnKnow;
                codeDesc = @"未知错误:未返回任何内容";
            }
            else
            {
                returnCode = kReturnErrorParserFailed;
                codeDesc = @"数据解析失败";
                ZSLog(@"%@:%@",codeDesc,[request responseString]);
            }
        }
        else
        {
            //返回错误码解析
            returnCode = [[root valueForKey:@"code"] integerValue];
            codeDesc = [root valueForKey:@"msg"];
            if ((codeDesc == nil || [codeDesc length] == 0) && returnCode != 0)
            {
                //错误描述必须有
                codeDesc = @"没有返回错误描述信息";
            }
            switch (returnCode)
            {
                case 0:
                {
                    //成功
                    resultCode = kReturnSuccess;
                    break;
                }
                case -1:
                {
                    //缺少参数
                    resultCode = kReturnErrorParameter;
                    break;
                }
                case 1:
                {
                    //用户不存在
                    resultCode = kReturnErrorUserNoExist;
                    break;
                }
                default:
                {
                    resultCode = kReturnErrorUnKnow;
                    break;
                }
            }
        }
        ZSLog(@"%d:%@",returnCode,codeDesc);
    }
    ReturnCodeModel *returnCodeModel = [[ReturnCodeModel alloc] initWithCode:resultCode andDesc:codeDesc];
    return returnCodeModel;
}

@end
