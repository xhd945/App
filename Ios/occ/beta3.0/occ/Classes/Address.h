//
//  Address.h
//  occ
//
//  Created by RS on 13-10-25.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int parentId;
@property (nonatomic, assign) int level;
@property (nonatomic, retain) NSString *name;

@end