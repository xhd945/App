//
//  HomeViewController.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewDelegate.h"
#import "Home1Cell.h"
#import "Home2Cell.h"
#import "Home3Cell.h"

#import "LKPopupMenuController.h"

//广告展示类型
typedef NS_ENUM(NSInteger, AdvertisementType)
{
    AdvertisementTypeSingleImage,   //一张图片
    AdvertisementTypeDoubleImage,   //两张图片
    AdvertisementTypeImages,        //多图循环播放
    AdvertisementTypeText,          //文本链接
    AdvertisementTypeOther,
};

//广告操作类型
typedef NS_ENUM(NSInteger, AdvertisementPageType)
{
    AdvertisementPageTypeLink,      //打开链接
    AdvertisementPageTypeShop,      //打开店铺
    AdvertisementPageTypeGoods,     //打开商品详情
    AdvertisementPageTypeGroupon,   //打开团购
    AdvertisementPageTypeActivity,  //打开活动
    AdvertisementPageTypeGrouponList,  //打开团购列表
    AdvertisementPageTypeBrand,  //打开品牌
    AdvertisementPageTypeOther
};

@interface HomeViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,LKPopupMenuControllerDelegate,
                                Home1CellDelegate,Home2CellDelegate,Home3CellDelegate>

@property (weak, nonatomic) id<HomeViewDelegate> delegate;
@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSArray *dataListMall;
@property (strong, nonatomic) NSTimer *myTimer;

@property (nonatomic, strong) LKPopupMenuController *popupMenu;
@property (nonatomic, strong) NSMutableArray        *popupMenuItems;

@end
