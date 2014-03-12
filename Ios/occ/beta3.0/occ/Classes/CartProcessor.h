//
//  CartProcessor.h
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseProcessor.h"

@protocol CartProcessorDelegate <NSObject>

@end


@interface CartProcessor : BaseProcessor

@property(nonatomic,strong)id <CartProcessorDelegate> delegate;


@end
