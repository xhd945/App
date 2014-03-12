//
//  OCCDefine.h
//  occ
//
//  Created by zhangss on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 
#pragma mark APP

//APP版本同意修改宝龙名称
#define kBaoLongTitle @"宝龙广场"
#define kBaoLongCityTitle @"福州站"

#pragma mark -
#pragma mark OCC Cache FolderName
//缓存文件夹名称
#define OCC_DATA_CACHE_FOLDER @"OCCDataCache"
#define OCC_IMAGE_CACHE_FOLDER @"OCCImageCache"


#pragma mark -
#pragma mark NetWork
//网络接口参数、KEY及默认值
#define PLOCC_MALLKEY        @"mall"
#define PLOCC_DEFAULT_MALLID @"1"   //默认的mallID为1 @"福州地区"

//IP及各个模块接口区分
#define PLOCC_PORT           OCC_IP@"/"
#define PLOCC_MOBILE         @"shopWeb/mobile/"
#define PLOCC_MOBILECENTER   @"userWeb/userMobileCenter/"
#define PLOCC_ADVERTISEMENT  @"adminWeb/advertisement/"
#define PLOCC_GROUPON        @"grouponWeb/mobile/"

//版本缓存更新
#define NAVI_CHECKVERSION    @"findAllinterfaceVersion.htm"
#define VersionInfoFileName  @"versionInfo.plist"

#define KEY_VERSIONLIST      @"versionList"
#define KEY_CODE             @"code"
#define KEY_VERSION          @"version"
#define KEY_FLOOR            @"floor"
#define KEY_CATEGORY         @"category"
#define KEY_EAT              @"eat"
#define KEY_PLAY             @"play"
#define KEY_BUY              @"buy"
#define KEY_FRONTPAGE        @"frontpage"
#define KEY_SOFTWARE         @"software"

//首页广告缓存 及 KEY
#define NAVI_FRONTPAGE       @"queryAdvertisement.htm"

#define KEY_CHANNELCODE      @"channelCode"
#define KEY_PLATFORM         @"platform"
#define KEY_SEATLIST         @"seatList"
#define KEY_ADTYPE           @"adType"
#define KEY_ADDIS            @"adDis"
#define KEY_ADLINK           @"adLink"
#define KEY_ADVERTISEMENTLIST @"advertisementList"
#define KEY_ADIMAGE          @"adImage"
#define KEY_ADWIDTH          @"adWidth"
#define KEY_ADHEIGHT         @"adHeight"

//导航缓存 及KEY 楼层、美食、娱乐、购物
#define NAVI_FINDNAVIGATION @"findNavigation.htm"

//品牌列表缓存
#define NAVI_BRANDLIST @"brandList.htm"
#define BrandListFileName @"navi_brandList.plist"

#define KEY_SHOPLIST @"shopList"

//活动相关缓存
#define NAVI_ACTIVITYLIST @"acitivityList.htm"
#define ActivityListFileName @"navi_activityList.plist"
#define ACTIVITY_INFO @"loadActivity.htm"

#define KEY_ACTIVITYLIST @"activityList"

//搜索默认分类及搜索历史记录 缓存
#define SEARCH_BASECATEGORY @"getAppItemCategorys.htm"
#define SearchBaseCategoryFileName @"search_baseCategory.plist"
#define SearchHistoryFileName @"search_history.plist"

//团购列表
#define NAVI_GROUPONLIST @"grouponList.htm"

//搜索店铺及商品
#define FIND_SHOPLIST @"findShopListNav.htm"
#define FIND_ITEMLIST @"findItemListNav.htm"

//店铺详情
#define SHOP_INFO @"loadShop.htm"

//搜索建议
#define SEARCH_SUGGEST @"mobileSearch.htm"

//用户收藏列表 店铺和商品
#define USER_FAVORITLIST_GOODS @"itemFavourList.htm"
#define USER_FAVORITLIST_SHOP @"storeListMobile.htm"

//删除用户收藏 店铺和商品
#define USER_DELETEFAVORITE_GOODS @"mobileRemoveItemFavour.htm"
#define USER_DELETEFAVORITE_SHOP @"mobileRemoveStoreFavour.htm"

//添加用户收藏 店铺和商品
#define USER_ADDFAVORITE_GOODS @"mobileAddItemFavour.htm"
#define USER_ADDFAVORITE_SHOP @"favourShop.htm"

//加入购物车 商品
#define USER_ADDGOODSTOCART @"addItemsCart.htm"

#define KEY_PAGE @"page"
#define KEY_NAME @"name"

#define KEY_CATEGORYID @"categoryId"
#define KEY_CATEGORYNAME @"categoryName"
#define KEY_METHOD @"method"
#define KEY_ACTIVITYID @"activityId"
#define KEY_SHOPID @"shopId"
#define KEY_SHOPNAME @"shopName"
#define KEY_ORDERTYPE @"orderType"
#define KEY_ORDERBY @"orderBy"
#define KEY_KEYWORD @"keyword"
#define KEY_CLASSIFICATION @"classification"
#define KEY_NAVID @"navId"
#define KEY_NAVIGATIONLIST @"navigationList"
#define KEY_LEVEL @"level"
#define KEY_ISPARENT @"isParent"
#define KEY_PARENTID @"parentId"
#define KEY_TYPE @"type"
#define KEY_GROUPONID @"grouponId"
#define KEY_GROUPONLIST @"grouponList"
#define KEY_BUYNUM   @"buyNum"
#define KEY_INFO @"info"

#define KEY_TITLE @"title"
#define KEY_PRICEFROM @"priceFrom"
#define KEY_PRICETO @"priceTo"

#define KEY_TGC @"TGC"
#define KEY_MALL @"mall"
#define KEY_FAVOURLIST @"favourList"
#define KEY_FAVOURID @"favourId"
#define KEY_ITEMLIST @"itemList"
#define KEY_ITEMID @"itemId"
#define KEY_ITEMNAME @"itemName"
#define KEY_ID @"id"
#define KEY_FROMTYPE @"fromType"
#define KEY_CARTID @"cartId"


#define kReturnCodeKey @"returnCode"
#define kReturnDataKey @"returnData"
#define kRequestDataKey @"requestData"
#define kRequestObjectKey @"requestObject"
#define kRequestTypeKey @"requestType"
#define kRequestHomePage @"requestHomePage"
#define kRequestNextPage @"requestNextPage"
#define kRequestPrePage @"requestPrePage"
#define kHomePageIndex 1

#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]

#pragma mark -
#pragma mark NotificationName
//缓存版本更新
#define OCC_NOTIFI_CHECKVERSION_RETURN @"OCC_NOTIFI_CHECKVERSION_RETURN"

//Home首页
#define OCC_NOTIFI_FRONTPAGE_RETURN @"OCC_NOTIFI_FRONTPAGE_RETURN"

//导航部分
#define OCC_NOTIFI_NAVI_DATA_RETURN @"OCC_NOTIFI_NAVI_DATA_RETURN"

//品牌列表
#define OCC_NOTIFI_NAVI_BRANDLIST_RETURN @"OCC_NOTIFI_NAVI_BRANDLIST_RETURN"

//活动列表
#define OCC_NOTIFI_NAVI_ACTIVITYLIST_RETURN @"OCC_NOTIFI_NAVI_ACTIVITYLIST_RETURN"

//团购列表
#define OCC_NOTIFI_NAVI_GROUPONLIST_RETURN @"OCC_NOTIFI_NAVI_GROUPONLIST_RETURN"

//店铺列表
#define OCC_NOTIFI_SHOPLIST_RETURN @"OCC_NOTIFI_SHOPLIST_RETURN"

//商品列表
#define OCC_NOTIFI_ITEMLIST_RETURN @"OCC_NOTIFI_ITEMLIST_RETURN"

//活动详情
#define OCC_NOTIFI_ACTIVITYINFO_RETURN @"OCC_NOTIFI_ACTIVITYINFO_RETURN"

//店铺详情
#define OCC_NOTIFI_SHOPINFO_RETURN @"OCC_NOTIFI_SHOPINFO_RETURN"

//搜索默认分类
#define OCC_NOTIFI_SEARCH_CATEGORY_RETURN @"OCC_NOTIFI_SEARCH_CATEGORY_RETURN"

//搜索建议
#define OCC_NOTIFI_SEARCH_SUGGEST_RETURN @"OCC_NOTIFI_SEARCH_SUGGEST_RETURN"

//搜索店铺结果返回
#define OCC_NOTIFI_SEARCH_SHOPS_RETURN @"OCC_NOTIFI_SEARCH_SHOPS_RETURN"

//搜索商品结果返回
#define OCC_NOTIFI_SEARCH_GOODS_RETURN @"OCC_NOTIFI_SEARCH_GOODS_RETURN"

//获取收藏列表 商品+店铺
#define OCC_NOTIFI_USER_FAVORITELIST_RETURN @"OCC_NOTIFI_USER_FAVORITELIST_RETURN"

//删除收藏数据 商品+店铺
#define OCC_NOTIFI_USER_DELETEFAVORITE_RETURN @"OCC_NOTIFI_USER_DELETEFAVORITE_RETURN"

//增加收藏数据 商品+店铺
#define OCC_NOTIFI_USER_ADDFAVORITE_RETURN @"OCC_NOTIFI_USER_ADDFAVORITE_RETURN"

//移动收藏到购物车 商品
#define OCC_NOTIFI_USER_ADDGOODSTOCART_RETURN @"OCC_NOTIFI_USER_ADDGOODSTOCART_RETURN"


#pragma mark -
#pragma mark Return Code
//返回成功
#define kReturnSuccess 20000
//请求超时
#define kReturnErrorTimedOut 20001
//未知错误
#define kReturnErrorUnKnow 20002
//缺少参数
#define kReturnErrorParameter 20003
//解析失败
#define kReturnErrorParserFailed 20004
//用户不存在
#define kReturnErrorUserNoExist 20005

