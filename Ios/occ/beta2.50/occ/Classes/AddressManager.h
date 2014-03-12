//
//  AddressManager.h
//  occ
//
//  Created by RS on 13-11-25.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Address.h"

@interface AddressManager : NSObject

@property (strong, nonatomic) FMDatabase *db;

-(Address *)queryProvinceById:(long)provinceId;
-(Address *)queryCityById:(long)cityId;
-(Address *)queryAreaById:(long)areaId;

-(NSArray*)getProvinceList;
-(NSArray*)getCityListByProvinceId:(long)provinceId;
-(NSArray*)getAreaListByCityId:(long)cityId;

@end
