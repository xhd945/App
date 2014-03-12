//
//  CartManager.h
//  occ
//
//  Created by zhangss on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManager.h"
#import "CartProcessor.h"

@interface CartManager : BaseManager <CartProcessorDelegate>
{
    CartProcessor *_cartProcessor;
}

@end
