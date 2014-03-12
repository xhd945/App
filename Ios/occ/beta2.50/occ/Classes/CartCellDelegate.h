//
//  CartCellDelegate.h
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CartCellDelegate <NSObject>
- (void)cartCellDidChange;
- (void)cartCellPlusMInus:(NSMutableDictionary*)data;
- (void)cartCellDelete:(NSMutableDictionary*)data;
- (void)cartCellFavour:(NSMutableDictionary*)data;
@end
