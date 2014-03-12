//
//  Singleton.h
//  RS_CRM
//
//  Created by RS on 12-12-12.
//  Copyright (c) 2012年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Singleton : NSObject<UIAlertViewDelegate>

@property (nonatomic, retain) NSString *deviceToken;

@property (strong, nonatomic) NSMutableArray *addressList;
@property (strong, nonatomic) NSMutableDictionary *cartData;
@property (strong, nonatomic) NSMutableDictionary *payData;
@property (strong, nonatomic) NSMutableDictionary *orderData;
@property (assign, nonatomic) int mall;
@property (assign, nonatomic) int userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userNickname;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userMobile;
@property (strong, nonatomic) NSString *TGC;

@property (strong, nonatomic) NSDictionary *mallData;//缓存获取到的MALL信息

@property (assign, nonatomic) LastOrderType lastOrderType;

@property (strong, nonatomic) NSString *trackViewURL;

+(Singleton *) sharedInstance;

-(NSString*)getPlistFilePath;
@end
