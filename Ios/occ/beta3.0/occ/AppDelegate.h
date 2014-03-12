//
//  AppDelegate.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCBarItem.h"
#import "OCCCartButton.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIImageView *splashImageView;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) OCCBarItem *tabbarItemFive;
@property (strong, nonatomic) OCCBarItem *tabbarItemFour;
@property (strong, nonatomic) OCCCartButton *cartButton;
@property (strong, nonatomic) NSDictionary *versionInfo;

@property (strong, nonatomic) NSString *pck;

@end
