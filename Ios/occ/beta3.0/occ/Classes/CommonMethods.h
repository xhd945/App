//
//  CommonMethods.h
//  occ
//
//  Created by zhangss on 13-8-29.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OCCButtonType)
{
    OCCButtonTypeGreen,
    OCCButtonTypeYellow,
    OCCButtonTypeWhite,
    OCCButtonTypeLightGray,
    OCCButtonTypeGray,
    OCCButtonTypeRed,
};

typedef NS_ENUM(NSInteger, OCCNavigationType)
{
    OCCNavigationTypeClassOne,   //navi_bg_classOne
    OCCNavigationTypeClassTwo,   //navi_bg_classTwo
    OCCNavigationTypeClassThree, //纯白
    OCCNavigationTypeOther
};

typedef NS_ENUM(NSInteger, OCCNavigationButtonType)
{
    OCCNavigationButtonTypeFavorite,   //收藏
    OCCNavigationButtonTypeCart,       //购物车
    OCCNavigationButtonTypeAdd,        //添加
    OCCNavigationButtonTypeCheck,      //OK
    OCCNavigationButtonTypeMore,       //更多
    OCCNavigationButtonTypeEdit,       //编辑
    OCCNavigationButtonTypeShowLeft,   //显示左边栏
    OCCNavigationButtonTypeFilter,     //过滤
    OCCNavigationButtonTypeLeftBack,   //返回
    OCCNavigationButtonTypeRightBack,  //返回
    OCCNavigationButtonTypeFilterLeft,  //返回
    OCCNavigationButtonTypeTwoCode,  //返回
    OCCNavigationButtonTypeLocate,  //
    OCCNavigationButtonTypeMessage,  //
    OCCNavigationButtonTypeOther
};

typedef NS_ENUM(NSInteger, OCCToolBarButtonType)
{
    OCCToolBarButtonTypeBack,          //返回
    OCCToolBarButtonTypeKeyboard,      //KeyBorad
    OCCToolBarButtonTypeEmoji,         //表情Emji
    OCCToolBarButtonTypeAdd,           //增加
    OCCToolBarButtonTypeGird,          //格子模式
    OCCToolBarButtonTypeList,          //列表模式
    OCCToolBarButtonTypeCart,          //购物车
    OCCToolBarButtonTypeCheck,          //OK
    OCCToolBarButtonTypeShare,          //OK
    OCCToolBarButtonTypeOther
};

typedef NS_ENUM(NSInteger, OCCCellSelectedBGType)
{
    OCCCellSelectedBGTypeClassOne,     //bg_cell_selected_classOne
    OCCCellSelectedBGTypeClassTwo,     //
    OCCCellSelectedBGTypeClassThree,   //
    OCCCellSelectedBGTypeClassFour,   //
    OCCCellSelectedBGTypeClassOther
};

typedef NS_ENUM(NSInteger, OCCViewBGType)
{
    OCCViewBGTypeClassOne,     //bg_section_gray
    OCCViewBGTypeClassTwo,     //
    OCCViewBGTypeClassThree,   //
    OCCViewBGTypeClassOther
};

typedef NS_ENUM(NSInteger, OCCDefaultImageType)
{
    OCCDefaultImageTypeImage,     //Image 1:1
    OCCDefaultImageTypePortrait,  //头像
    OCCDefaultImageTypeOther
};

typedef NS_ENUM(NSInteger, OCCLineType)
{
    OCCLineType1,     //bg_cell_selected_classOne
    OCCLineType2,     //
    OCCLineType3,   //
};

@interface CommonMethods : NSObject

#pragma mark -
#pragma mark Navi Buttons
//获取左导航栏按钮 带有返回Home页的Button
//不再需要
+ (UIView *)leftNavigationButtonWithHomeTarget:(id)target andSelector:(SEL)backSel andHomeSelector:(SEL)homeSel andBackTitle:(NSString *)titleStr;

//导航栏View
+ (UIView *)navigationViewWithType:(OCCNavigationType)navigationType;

//仅仅是导航栏左边返回按钮 没有文字 默认一级导航匹配的按钮
+ (UIView *)backNavigationButtonWithTarget:(id)target andSelector:(SEL)selector;
//仅仅是导航栏左边返回按钮 没有文字 其他导航类型相匹配的按钮
+ (UIView *)backNavigationButtonWithTarget:(id)target andSelector:(SEL)selector withNavigationType:(OCCNavigationType)type;

//获取各种类型的导航栏按钮 没有文字仅有图标显示的
+ (UIView *)navigationButtonWithTarget:(id)target andSelector:(SEL)selector andButtonType:(OCCNavigationButtonType)type andLeft:(BOOL)left;

//导航栏BTN 仅有文字及背景
+ (UIView *)navigationButtonWithTitle:(NSString *)title WithTarget:(id)target andSelector:(SEL)selector andLeft:(BOOL)left;

//下部工具栏 没有文字仅有图标显示
+ (UIView *)toolBarButtonWithTarget:(id)target andSelector:(SEL)selector andButtonType:(OCCToolBarButtonType)type andLeft:(BOOL)left;

//下部工具栏 仅有文字及背景
+ (UIView *)toolBarButtonWithTitle:(NSString *)title WithTarget:(id)target andSelector:(SEL)selector andLeft:(BOOL)left;

//按钮
+ (UIView *)buttonWithTitle:(NSString *)title withTarget:(id)target andSelector:(SEL)selector andFrame:(CGRect)rect andButtonType:(OCCButtonType)type;
+ (UIView *)buttonWithImage:(NSString *)image withTarget:(id)target andSelector:(SEL)selector andFrame:(CGRect)rect andButtonType:(OCCButtonType)type;

+ (UIView *)nodataViewWithTip:(NSString*)text;
+ (UIActivityIndicatorView *)loadingViewWithCenter:(CGPoint)point;

#pragma mark -
#pragma mark TableView Cell BG
+ (UIView *)selectedCellBGViewWithType:(OCCCellSelectedBGType)cellType;

//灰色分割线
+ (UIView *)cellNormalLineWithSuperFrame:(CGRect)frame;

//导航分割线 2像素 棕色
+ (UIView *)cellNaviLineWithSuperFrame:(CGRect)frame;

+ (UIImageView *)lineWithWithType:(OCCLineType)lineType;

#pragma mark - 
#pragma mark 文件操作
//根据文件名称获取document文件路径
+ (NSString *)getFilePathWithFileName:(NSString *)fileName;

//创建文件夹
+ (BOOL)addFolderToPath:(NSString *)folderPath withFolderName:(NSString *)folderName;

//缓存Image的文件路径
+ (NSString *)getImageFilePathFromURL:(NSString *)urlString;

//缓存data的文件路径
+ (NSString *)getDataCachePathWithFileName:(NSString *)fileName;

#pragma mark -
#pragma makr Default Image
//获取默认图片
+ (UIImage *)defaultImageWithType:(OCCDefaultImageType)type;

#pragma mark -
#pragma mark 操作等待及提示框
//显示锁屏框
+ (void)showWaitView:(NSString *)showStr;

//隐藏锁屏框
+ (void)hideWaitView;

//显示自动消失的提示框 2S View为空则是加载在Window上的
+ (void)showAutoDismissView:(NSString *)showStr inView:(UIView *)view;

+ (void)showErrorDialog:(NSString*)msg inView:(UIView*)view;
+ (void)showSuccessDialog:(NSString*)msg inView:(UIView*)view;
+ (void)showFailDialog:(NSString*)msg inView:(UIView*)view;
+ (void)showTextDialog:(NSString*)msg inView:(UIView*)view;

+ (void)login;
+ (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password;
+ (BOOL) checkIsLogin;
+ (BOOL)onlycheckIsLogin;
+ (ASIFormDataRequest*) asiHttpRequestWithURL:(NSString*)str andData:(NSString*)reqdata  andDelegate:(id)delegate;
+ (void) showTip:(NSString*)msg;
+ (void) conntWifi;
+ (void) checkWifi;

+ (NSString*)encodeURL:(NSString *)string;

+ (NSString*)parseText:(NSString*)text fromHtmlString:(NSString*)str;

#pragma mark -
#pragma mark 公共控制器
+ (void)pushShopViewControllerWithData:(NSDictionary *)data;

#pragma mark -
#pragma mark 字符串转换为JSON
+ (NSDictionary *)getJsonValueFromString:(NSString *)dataString;


+ (float) heightForString:(NSString *)text andFont:(UIFont*)font andWidth:(float)width;
+ (NSString *)getOrderStatusbyId:(int)id;

+(void)checkVersionWithTarget:(id)target andSlience:(BOOL)slience;

+(void)alipay:(Product*)product;

@end
