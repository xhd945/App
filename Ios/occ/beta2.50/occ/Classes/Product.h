//
//  Product.h
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *tradeNO;
@property (nonatomic, retain) NSString *partner;
@property (nonatomic, retain) NSString *seller;
@property (nonatomic, retain) NSString *notifyURL;

@property (nonatomic, retain) NSString *pck;
@property (nonatomic, retain) NSString *pvk;

@end
