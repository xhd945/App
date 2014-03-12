//
//  TestViewController.h
//  occ
//
//  Created by plocc on 13-12-8.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTInterface.h"

@interface TestViewController : UIViewController<LTInterfaceDelegate>

- (void) doTest:(id)sender;

@end
