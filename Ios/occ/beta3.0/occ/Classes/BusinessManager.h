//
//  BusinessManager.h
//  occ
//
//  Created by zhangss on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NaviManager;
@class SearchManager;
@class CartManager;
@class UserManager;
@class AddressManager;

@interface BusinessManager : NSObject

@property(readonly,strong)NaviManager *naviManager;
@property(readonly,strong)SearchManager *searchManager;
@property(readonly,strong)CartManager *cartManager;
@property(readonly,strong)UserManager *userManager;
@property(readonly,strong)AddressManager *addressrManager;

+ (BusinessManager *)sharedManager;

@end
