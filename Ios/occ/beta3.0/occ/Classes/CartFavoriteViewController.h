//
//  ShoppingCartViewController.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartViewController.h"
#import "FavoriteViewController.h"
#import "OCCSegement.h"

@interface CartFavoriteViewController : UIViewController <OCCSegementDelegate>
@property (strong,nonatomic)  CartViewController *cartViewController;
@property (strong,nonatomic)  FavoriteViewController *favoriteViewController;

@property (strong,nonatomic)  UILabel *titleLable;
@property (strong,nonatomic)  UIButton *cartTabButton;
@property (strong,nonatomic)  UIButton *favoriteTabButton;
@property (strong,nonatomic)  OCCSegement *segement;

@end
