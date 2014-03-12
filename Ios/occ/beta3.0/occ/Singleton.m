//
//  Singleton.m
//  RS_CRM
//
//  Created by RS on 12-12-12.
//  Copyright (c) 2012年 RS. All rights reserved.
//

#import "Singleton.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

static Singleton* instance = nil;

@implementation Singleton

+(Singleton *) sharedInstance{
    @synchronized(self){
        if (instance == nil) {
            instance = [[self alloc] init];
            [instance initData];
            }
    }
    return  instance;
}

+ (id)allocWithZone:(NSZone *)zone{
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

-(void)initData
{
    _deviceToken = [[NSString alloc]init];
    
    _cartData=[[NSMutableDictionary alloc]init];
    _payData=[[NSMutableDictionary alloc]init];
    _orderData=[[NSMutableDictionary alloc]init];
    _addressList=[[NSMutableArray alloc]init];
    _mall=1;
    _TGC=@"";
    _userName=@"";
    _userNickname=@"";
    _userMobile=@"";
    _userEmail=@"";
    
    _mallData=[[NSDictionary alloc]init];
}

-(NSString*)getPlistFilePath
{
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",@""];
    NSString* filePath=[[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:fileName];
    return filePath;
}

@end
