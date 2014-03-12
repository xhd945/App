//
//  AddressManager.m
//  occ
//
//  Created by RS on 13-11-25.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "AddressManager.h"

@implementation AddressManager

#pragma mark -
#pragma mark Init
- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *filePath=[[NSBundle mainBundle] pathForResource:@"occ.db3" ofType:nil];
        self.db = [FMDatabase databaseWithPath:filePath];
    }
    return self;
}

-(Address *)queryProvinceById:(long)provinceId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=1 and ID=%ld",provinceId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(Address *)queryCityById:(long)cityId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=2 and ID=%ld",cityId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(Address *)queryAreaById:(long)areaId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=3 and ID=%ld",areaId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(NSArray*)getProvinceList
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    if ([self.db open]) {
        FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=1"];
        while ([rs next]){
            Address *address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            [arr addObject:address];
        }
        [rs close];
    }
    
    return arr;
}

-(NSArray*)getCityListByProvinceId:(long)provinceId
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=2 and PARENT_ID=%ld",provinceId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            Address *address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            [arr addObject:address];
        }
        [rs close];
    }
    
    return arr;
}

-(NSArray*)getAreaListByCityId:(long)cityId
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=3 and PARENT_ID=%ld",cityId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            Address *address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            [arr addObject:address];
        }
        [rs close];
    }
    
    return arr;
}

@end
