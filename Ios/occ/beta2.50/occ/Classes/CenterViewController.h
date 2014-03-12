//
//  CenterViewController.h
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "OCCBarItem.h"
#import "OCCCartButton.h"

@interface CenterViewController : UITabBarController<UITabBarControllerDelegate,HomeViewDelegate>
{
    //自定义Tabbar贴图
    OCCBarItem *_tabbarItemOne;
    OCCBarItem *_tabbarItemTwo;
    OCCBarItem *_tabbarItemThree;
    OCCBarItem *_tabbarItemFour;
    OCCBarItem *_tabbarItemFive;
    OCCCartButton *_cartButton;
}
@property (assign, nonatomic) int needSelect;

@end
