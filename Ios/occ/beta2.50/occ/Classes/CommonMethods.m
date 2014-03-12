//
//  CommonMethods.m
//  occ
//
//  Created by zhangss on 13-8-29.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCWaitingView.h"
#import "GoodsFilterViewController.h"
#import "GoodsFilterLeftViewController.h"
#import "LoginViewController.h"
#import "ShopViewController.h"
#import "AppDelegate.h"
#import "OCCAlertView.h"
#import <sys/utsname.h>
#import "Reachability.h"

@implementation CommonMethods

#pragma mark -
#pragma mark Navi Buttons
+ (UIView *)leftNavigationButtonWithHomeTarget:(id)target andSelector:(SEL)backSel andHomeSelector:(SEL)homeSel andBackTitle:(NSString *)titleStr
{
    UIView *leftNaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    
    UIButton *backButton = [[UIButton alloc]init];
    UIImage *leftImage = [UIImage imageNamed:@"btn_bg_returnleft.png"];
    UIImage *streachImage = [leftImage stretchableImageWithLeftCapWidth:44.0 topCapHeight:44.0];
    [backButton setBackgroundImage:streachImage forState:UIControlStateNormal];
    [backButton addTarget:target action:backSel forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font = FONT_14;
    [backButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [backButton setTitle:titleStr forState:UIControlStateNormal];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,12,0,0)];
    CGSize textSize = [titleStr sizeWithFont:backButton.titleLabel.font];
    [backButton setFrame:CGRectMake(10, 0, textSize.width + 25, HEADER_HEIGHT)];
    
    [leftNaviView addSubview:backButton];
    
    UIButton *homeButton = [[UIButton alloc]init];
    [homeButton setFrame:CGRectMake(backButton.frame.origin.x+backButton.frame.size.width, 0, HEADER_HEIGHT, HEADER_HEIGHT)];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_home.png"] forState:UIControlStateNormal];
    [homeButton setImage:[UIImage imageNamed:@"btn_home.png"] forState:UIControlStateNormal];
    [homeButton addTarget:target action:homeSel forControlEvents:UIControlEventTouchUpInside];
    homeButton.titleLabel.font = FONT_14;
    [homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [homeButton setImageEdgeInsets:UIEdgeInsetsMake(0,-15,0,0)];
    [leftNaviView addSubview:homeButton];
    leftNaviView.frame = CGRectMake(0, 0, homeButton.frame.origin.x + homeButton.frame.size.width, HEADER_HEIGHT);
    return leftNaviView;
}

+ (UIView *)navigationViewWithType:(OCCNavigationType)navigationType
{
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.userInteractionEnabled = YES;
    topImageView.backgroundColor = [UIColor blackColor];
    [topImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    if (navigationType == OCCNavigationTypeClassOne)
    {
        [topImageView setImage:[UIImage imageNamed:@"navi_bg_classOne"]];
    }
    else if (navigationType == OCCNavigationTypeClassOne)
    {
        [topImageView setImage:[UIImage imageNamed:@"navi_bg_classTwo"]];
    }
    else if (navigationType == OCCNavigationTypeClassThree)
    {
        [topImageView setImage:[UIImage imageNamed:@"navi_bg_classTwo"]];
    }
    
    return topImageView;
}

+ (UIView *)backNavigationButtonWithTarget:(id)target andSelector:(SEL)selector
{
    return [CommonMethods backNavigationButtonWithTarget:target andSelector:selector withNavigationType:OCCNavigationTypeClassOne];
}

+ (UIView *)backNavigationButtonWithTarget:(id)target andSelector:(SEL)selector withNavigationType:(OCCNavigationType)type;
{
    UIButton *backButton = [[UIButton alloc]init];
    UIImage *bgImage = nil;
    if (type == OCCNavigationTypeClassOne)
    {
        bgImage = [UIImage imageNamed:@"navi_btn_bg"];
    }
    else 
    {
        bgImage = [UIImage imageNamed:@"navi_btn_bg_two"];
    }
    [backButton setFrame:CGRectMake(0, (HEADER_HEIGHT - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height)];
    [backButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

+ (UIView *)navigationButtonWithTarget:(id)target andSelector:(SEL)selector andButtonType:(OCCNavigationButtonType)buttonType andLeft:(BOOL)left
{
    NSString *imageName = nil;
    switch (buttonType)
    {
        case OCCNavigationButtonTypeAdd:
            imageName = @"navi_icon_add";
            break;
        case OCCNavigationButtonTypeCart:
            imageName = @"navi_icon_cart";
            break;
        case OCCNavigationButtonTypeCheck:
            imageName = @"navi_icon_check";
            break;
        case OCCNavigationButtonTypeEdit:
            imageName = @"navi_icon_edit";
            break;
        case OCCNavigationButtonTypeFavorite:
            imageName = @"navi_icon_favorite";
            break;
        case OCCNavigationButtonTypeFilter:
            imageName = @"navi_icon_filter";
            break;
        case OCCNavigationButtonTypeMore:
            imageName = @"navi_icon_more";
            break;
        case OCCNavigationButtonTypeShowLeft:
            imageName = @"navi_icon_showLeft";
            break;
        case OCCNavigationButtonTypeFilterLeft:
            imageName = @"navi_icon_filter_left";
            break;
        case OCCNavigationButtonTypeTwoCode:
            imageName = @"navi_icon_twocode";
            break;
        case OCCNavigationButtonTypeLocate:
            imageName = @"navi_icon_locate";
            break;
        case OCCNavigationButtonTypeMessage:
            imageName = @"icon_message_white";
            break;
        default:
            break;
    }
    
    UIButton *backButton = [[UIButton alloc]init];
    UIImage *bgImage = [UIImage imageNamed:@"navi_btn_bg"];
    if (left)
    {
        [backButton setFrame:CGRectMake(0, (HEADER_HEIGHT - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height)];
    }
    else
    {
        [backButton setFrame:CGRectMake(SCREEN_WIDTH - bgImage.size.width, (HEADER_HEIGHT - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height)];
    }
    [backButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

+ (UIView *)navigationButtonWithTitle:(NSString *)title WithTarget:(id)target andSelector:(SEL)selector andLeft:(BOOL)left
{    
    UIButton *naviBtn = [[UIButton alloc]init];

    UIImage *bgImage = [UIImage imageNamed:@"navi_btn_bg"];
    [naviBtn setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2] forState:UIControlStateNormal];
    [naviBtn setTitle:title forState:UIControlStateNormal];
    [naviBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [naviBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    naviBtn.titleLabel.font = FONT_14;
    [naviBtn setTitleColor:COLOR_333333 forState:UIControlStateHighlighted];
    
    CGSize titleSize = [naviBtn.titleLabel.text sizeWithFont:naviBtn.titleLabel.font];
    if (left)
    {
        [naviBtn setFrame:CGRectMake(0, 0, titleSize.width + 20+20, HEADER_HEIGHT)];
    }
    else
    {
        [naviBtn setFrame:CGRectMake(SCREEN_WIDTH - titleSize.width - 20-20, 0, titleSize.width + 20+20, HEADER_HEIGHT)];
    }
    return naviBtn;
}

+ (UIView *)toolBarButtonWithTarget:(id)target andSelector:(SEL)selector andButtonType:(OCCToolBarButtonType)type andLeft:(BOOL)left
{
    NSString *imageName = nil;
    switch (type)
    {
        case OCCToolBarButtonTypeAdd:
            imageName = @"tool_icon_add";
            break;
        case OCCToolBarButtonTypeBack:
            imageName = @"navi_icon_back";
            break;
        case OCCToolBarButtonTypeEmoji:
            imageName = @"tool_icon_emoji";
            break;
        case OCCToolBarButtonTypeGird:
            imageName = @"tool_icon_gird";
            break;
        case OCCToolBarButtonTypeKeyboard:
            imageName = @"tool_icon_keyboard";
            break;
        case OCCToolBarButtonTypeList:
            imageName = @"tool_icon_list";
            break;
        case OCCToolBarButtonTypeCart:
            imageName = @"navi_icon_cart";
            break;
        case OCCToolBarButtonTypeCheck:
            imageName = @"navi_icon_check";
            break;
        case OCCToolBarButtonTypeShare:
            imageName = @"navi_icon_share";
            break;
        default:
            break;
    }
    
    UIButton *backButton = [[UIButton alloc]init];
    UIImage *bgImage = [UIImage imageNamed:@"navi_btn_bg"];
    if (left)
    {
        [backButton setFrame:CGRectMake(0, (HEADER_HEIGHT - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height)];
    }
    else
    {
        [backButton setFrame:CGRectMake(SCREEN_WIDTH - bgImage.size.width, (HEADER_HEIGHT - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height)];
    }

    [backButton setBackgroundImage:[UIImage imageNamed:@"tool_btn_bg"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

+ (UIView *)toolBarButtonWithTitle:(NSString *)title WithTarget:(id)target andSelector:(SEL)selector andLeft:(BOOL)left
{
    UIButton *naviBtn = [[UIButton alloc]init];
    
    UIImage *bgImage = [UIImage imageNamed:@"tool_btn_bg"];
    [naviBtn setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2] forState:UIControlStateNormal];
    [naviBtn setTitle:title forState:UIControlStateNormal];
    //[naviBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateHighlighted];
    [naviBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [naviBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [naviBtn setTitleColor:COLOR_999999 forState:UIControlStateDisabled];
    naviBtn.titleLabel.font = FONT_14;
    
    CGSize titleSize = [naviBtn.titleLabel.text sizeWithFont:naviBtn.titleLabel.font];
    if (left)
    {
        [naviBtn setFrame:CGRectMake(5, 0, titleSize.width + 30, HEADER_HEIGHT)];
    }
    else
    {
        [naviBtn setFrame:CGRectMake(SCREEN_WIDTH - titleSize.width - 30 - 5, 0, titleSize.width + 30, HEADER_HEIGHT)];
    }
    return naviBtn;
}

//按钮
+ (UIView *)buttonWithTitle:(NSString *)title withTarget:(id)target andSelector:(SEL)selector andFrame:(CGRect)rect andButtonType:(OCCButtonType)type
{
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    
    NSString *imageName = nil;
    UIColor *color=nil;
    switch (type)
    {
        case OCCButtonTypeGreen:
            imageName = @"btn_bg_green";
            color=COLOR_FFFFFF;
            break;
        case OCCButtonTypeYellow:
            imageName = @"btn_bg_yellow";
            color=COLOR_FFFFFF;
            break;
        case OCCButtonTypeWhite:
            imageName = @"btn_bg_white";
            color=COLOR_FFFFFF;
            break;
        case OCCButtonTypeLightGray:
            imageName = @"btn_bg_light_gray";
            color=COLOR_000000;
            break;
        case OCCButtonTypeGray:
            imageName = @"btn_bg_gray";
            color=COLOR_000000;
            break;
        case OCCButtonTypeRed:
            imageName = @"btn_bg_red";
            color=COLOR_FFFFFF;
            break;
        default:
            color=COLOR_FFFFFF;
            break;
    }
    
    UIImage *bgImage = [UIImage imageNamed:imageName];
    [btn setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    btn.titleLabel.font = FONT_14;
    return btn;
}

+ (UIView *)buttonWithImage:(NSString *)image withTarget:(id)target andSelector:(SEL)selector andFrame:(CGRect)rect andButtonType:(OCCButtonType)type
{
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    
    NSString *imageName = nil;
    UIColor *color=nil;
    switch (type)
    {
        case OCCButtonTypeGreen:
            imageName = @"btn_bg_green";
            color=COLOR_FFFFFF;
            break;
        case OCCButtonTypeYellow:
            imageName = @"btn_bg_yellow";
            color=COLOR_FFFFFF;
            break;
        case OCCButtonTypeWhite:
            imageName = @"btn_bg_white";
            color=COLOR_FFFFFF;
            break;
        case OCCButtonTypeLightGray:
            imageName = @"btn_bg_light_gray";
            color=COLOR_000000;
            break;
        case OCCButtonTypeGray:
            imageName = @"btn_bg_gray";
            color=COLOR_000000;
            break;
        case OCCButtonTypeRed:
            imageName = @"btn_bg_red";
            color=COLOR_FFFFFF;
            break;
        default:
            color=COLOR_FFFFFF;
            break;
    }
    
    UIImage *bgImage = [UIImage imageNamed:imageName];
    [btn setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    btn.titleLabel.font = FONT_14;
    return btn;
}

+ (UIView *)nodataViewWithTip:(NSString*)text
{
    UIView *nodataView=[[UIView alloc]init];
    [nodataView setFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UILabel *nodataLable = [[UILabel alloc]init];
    [nodataLable setTextColor:[UIColor lightGrayColor]];
    [nodataLable setBackgroundColor:[UIColor clearColor]];
    [nodataLable setText:text];
    [nodataLable setFont:FONT_20];
    [nodataLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
    [nodataLable setTextAlignment:NSTextAlignmentCenter];
    [nodataView addSubview:nodataLable];
    
    return nodataView;
}

+ (UIActivityIndicatorView *)loadingViewWithCenter:(CGPoint)point
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    [activityIndicatorView setFrame:CGRectMake(0, 20.0f, 32.0f, 32.0f)];
    [activityIndicatorView setCenter:point];
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView setHidesWhenStopped:YES];
    [activityIndicatorView setColor:[UIColor blackColor]];
    return activityIndicatorView;
}

#pragma mark -
#pragma mark TableView Cell BG
+ (UIView *)selectedCellBGViewWithType:(OCCCellSelectedBGType)cellType
{
    UIImageView *selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    if (cellType == OCCCellSelectedBGTypeClassOne)
    {
        selectedImageView.backgroundColor = COLOR_CCB6A3;
    }
    else if (cellType == OCCCellSelectedBGTypeClassTwo)
    {
        selectedImageView.image = nil;
        selectedImageView.backgroundColor = COLOR_26221F;
    }
    else if (cellType == OCCCellSelectedBGTypeClassThree)
    {
        selectedImageView.backgroundColor = COLOR_CCB6A3;
    }
    else if (cellType == OCCCellSelectedBGTypeClassFour)
    {
        selectedImageView.backgroundColor = COLOR_594F47;
    }
    return selectedImageView;
}

+ (UIView *)cellNormalLineWithSuperFrame:(CGRect)frame
{
    UIImage *lineImage = [UIImage imageNamed:@"line_normal"];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - lineImage.size.width)/2, frame.size.height - 2, lineImage.size.width, 2)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:lineImage];
    return lineView;
}

+ (UIView *)cellNaviLineWithSuperFrame:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line_navi"]];
    return lineView;
}

+ (UIImageView *)lineWithWithType:(OCCLineType)lineType
{
    UIImageView *lineImageView=[[UIImageView alloc]init];
    switch (lineType) {
        case OCCLineType1:
        {
            [lineImageView setImage:[UIImage imageNamed:@"line1"]];
            [lineImageView setHighlightedImage:[UIImage imageNamed:@"line1"]];
        }
            break;
        case OCCLineType2:
        {
            [lineImageView setImage:[UIImage imageNamed:@"line2"]];
            [lineImageView setHighlightedImage:[UIImage imageNamed:@"line2"]];
        }
            break;
        case OCCLineType3:
        {
            [lineImageView setImage:[UIImage imageNamed:@"line3"]];
            [lineImageView setHighlightedImage:[UIImage imageNamed:@"line3"]];
        }
            break;
        default:
            break;
    }
    
    return lineImageView;
}

#pragma mark -
#pragma mark 文件操作
/******************************************************************************
 函数名称 : getFilePathWithFileName:
 函数描述 : 根据文件名称获取文件document路径,如果多级需要传递上级文件夹名称
 输入参数 : fileName:文件名称.
 输出参数 : String 文件完整路径
 返回值 : String 文件完整路径
 备注 :
 添加人 : zhangss
 ******************************************************************************/
+ (NSString *)getFilePathWithFileName:(NSString *)fileName
{
    return [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:fileName];
}

/******************************************************************************
 函数名称 : addFolderToPath: withFolderName:
 函数描述 : 在目标路径下创建文件夹 目标路径为空时为默认Document路径
 输入参数 : folderPath:目标路径(传空时为document路径 否则传递Document的下一级文件路径) folderName:文件夹名称
 输出参数 : 无
 返回值 : BOOL 是否创建成功
 备注 : 1.folderPath为空 则在document下创建文件夹
       2.folderPath不为空 则在paht下创建文件夹 例如传递 document/file则表示在file下
 添加人 : zhangss
 ******************************************************************************/
+ (BOOL)addFolderToPath:(NSString *)folderPath withFolderName:(NSString *)folderName
{
    BOOL isSuccess = NO;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    NSString *newPath = nil;
    if (folderPath == nil)
    {
        //没有目标路径 创建document路径下的文件夹
        newPath = [CommonMethods getFilePathWithFileName:folderName];
    }
    else
    {
        //在doc下创建多级文件夹
        newPath = [folderPath stringByAppendingPathComponent:folderName];
    }

    if(![fileManager fileExistsAtPath:newPath isDirectory:&isDirectory])
    {
        NSError* error = nil;
        isSuccess = [fileManager createDirectoryAtPath:newPath  withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            NSLog(@"%@",error);
        }
    }
    return isSuccess;
}

/******************************************************************************
 函数名称 : getImageFilePathFromURL:
 函数描述 : 根据图片的URL地址 过滤掉特殊字符 获取图片文件名及路径
 输入参数 : urlString 图片的地址URL
 输出参数 : NSString 文件路径
 返回值 : 文件路径
 备注 : 
 添加人 : zhangss
 ******************************************************************************/
+ (NSString *)getImageFilePathFromURL:(NSString *)urlString
{
    if (urlString == nil || [urlString length] == 0)
    {
        //非法URL判断
        return nil;
    }
    NSString *imageName = [NSString stringWithFormat:@"%@",urlString];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"?" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"proxy" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@":" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
    
    NSString *imagePath = [[CommonMethods getFilePathWithFileName:OCC_IMAGE_CACHE_FOLDER] stringByAppendingPathComponent:imageName];    
    return imagePath;
}

/******************************************************************************
 函数名称 : getDataCachePathWithFileName:
 函数描述 : 根据图片的URL地址 过滤掉特殊字符 获取图片文件名及路径
 输入参数 : urlString 图片的地址URL
 输出参数 : NSString 文件路径
 返回值 : 文件路径
 备注 :
 添加人 : zhangss
 ******************************************************************************/
+ (NSString *)getDataCachePathWithFileName:(NSString *)fileName
{    
    NSString *imagePath = [[CommonMethods getFilePathWithFileName:OCC_DATA_CACHE_FOLDER] stringByAppendingPathComponent:fileName];
    return imagePath;
}

#pragma mark -
#pragma makr Default Image
//获取默认图片
+ (UIImage *)defaultImageWithType:(OCCDefaultImageType)type
{
    NSString *defaultImage = nil;
    switch (type)
    {
        case OCCDefaultImageTypeImage:
        {
            defaultImage = @"default_image_246";
            break;
        }
        case OCCDefaultImageTypePortrait:
        {
            defaultImage = @"default_head_96";
            break;
        }
        default:
        {
            defaultImage = @"default_image_246";
            break;
        }
    }
    return [UIImage imageNamed:defaultImage];
}

#pragma mark -
#pragma mark 操作等待及提示框
static OCCWaitingView *waitingView = nil;
+ (void)showWaitView:(NSString *)showStr
{
    if (waitingView == nil)
    {
        waitingView = [[OCCWaitingView alloc] init];
    }
    [waitingView showWaitView:showStr];
}

+ (void)hideWaitView
{
    if (waitingView)
    {
        [waitingView hideWaitView];
    }
}

+ (void)showAutoDismissView:(NSString *)showStr inView:(UIView *)view
{
#ifdef NeedFailDialog
    if (waitingView == nil)
    {
        waitingView = [[OCCWaitingView alloc] init];
    }
    [waitingView showAutoDismissView:showStr inView:view];
#endif
}

+ (void)showErrorDialog:(NSString*)msg inView:(UIView*)view
{
#ifdef NeedFailDialog
    MBProgressHUD *HUD;
    if (view){
        HUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:HUD];
    }else{
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    }
    
    //HUD.labelText=@"提示";
    HUD.detailsLabelText = msg;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset=-80;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
#endif
}

+ (void)showSuccessDialog:(NSString*)msg inView:(UIView*)view
{
    MBProgressHUD *HUD;
    if (view){
        HUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:HUD];
    }else{
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    }
    
    //HUD.labelText=@"提示";
    HUD.detailsLabelText = msg;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset=-80;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

+ (void)showFailDialog:(NSString*)msg inView:(UIView*)view
{
    MBProgressHUD *HUD;
    if (view){
        HUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:HUD];
    }else{
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    }
    
    //HUD.labelText=@"提示";
    HUD.detailsLabelText = msg;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset=-80;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

+ (void)showTextDialog:(NSString*)msg inView:(UIView*)view
{
    MBProgressHUD *HUD;
    if (view){
        HUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:HUD];
    }else{
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    }
    
    //HUD.labelText=@"提示";
    HUD.detailsLabelText = msg;
    HUD.mode = MBProgressHUDModeText;
    HUD.yOffset=-80;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark 公共控制器
+ (void)pushShopViewControllerWithData:(NSDictionary *)data
{
    GoodsFilterLeftViewController *leftController=[[GoodsFilterLeftViewController alloc]init];
    GoodsFilterViewController *rightController=[[GoodsFilterViewController alloc]init];
    ShopViewController *centerController=[[ShopViewController alloc]init];
    [centerController setData:data];
    IIViewDeckController *deckController=[[IIViewDeckController alloc]init];
    deckController.leftController=leftController;
    deckController.centerController=centerController;
    deckController.rightController=rightController;
    deckController.leftSize = 54;
    deckController.rightSize = 54;
    deckController.openSlideAnimationDuration = 0.3f;
    deckController.closeSlideAnimationDuration = 0.3f;
    deckController.bounceOpenSideDurationFactor = 0.3f;
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:deckController animated:YES];
}

#pragma mark -
#pragma mark 字符串转换为JSON
+ (NSDictionary *)getJsonValueFromString:(NSString *)dataString
{
    NSRange dataStrRange = [dataString rangeOfString:@"data="];
    NSString *jsonStr = nil;
    if (dataStrRange.length > 0)
    {
        //解析linkURL的Data部分
        jsonStr = [dataString substringFromIndex:dataStrRange.location + dataStrRange.length];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    else
    {
        jsonStr = dataString;
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonDic = [parser objectWithString:jsonStr];
    return jsonDic;
}


+ (float) heightForString:(NSString *)text andFont:(UIFont*)font andWidth:(float)width
{
    CGSize sizeToFit = [text sizeWithFont:font
                         constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return sizeToFit.height;
}

+ (NSString *)getOrderStatusbyId:(int)id
{
    switch(id){
        case 0:
            return @"等待买家付款";
            break;
        case 10:
            return @"等待商家发货";
            break;
        case 20:
            return @"已拣货";
            break;
        case 25:
            return @"缺货";
            break;
        case 30:
            return @"等待买家确认收货";
            break;
        case 40:
            return @"买家已收到货，申请退货";
            break;
        case 50:
            return @"买家未收到货,申请退款";
            break;
        case 60:
            return @"商家拒绝退款、退货";
            break;
        case 70:
            return @"商家同意退货";
            break;
        case 80:
            return @"已退货";
            break;
        case 90:
            return @"退款成功";
            break;
        case 100:
            return @"交易完成";
            break;
        case 110:
            return @"交易关闭";
            break;
        case 120:
            return @"已评论";
            break;
        case 130:
            return @"交易关闭";
            break;
        case 140:
            return @"交易关闭";
            break;
        case 150:
            return @"交易关闭";
            break;
        default:
            return @"";
            break;
    }
    
    return @"";
}

+(BOOL)checkIsLogin
{
    if ([[Singleton sharedInstance]TGC]==nil||[[[Singleton sharedInstance]TGC]length]==0)
    {
        LoginViewController *viewController=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:viewController];
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate.navigationController presentModalViewController:nav animated:YES];
        return NO;
    }
    else
    {
        return YES;
    }
}

+(BOOL)onlycheckIsLogin
{
    if ([[Singleton sharedInstance]TGC]==nil||[[[Singleton sharedInstance]TGC]length]==0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//检测版本更新入口
+(void)checkVersionWithTarget:(id)target andSlience:(BOOL)slience
{
    if (!slience)
    {
        [CommonMethods showWaitView:@"正在检测版本,请稍候..."];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
                       NetworkStatus status= [r currentReachabilityStatus];
                       if (status==NotReachable)
                       {
                           if (!slience)
                           {
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  [CommonMethods hideWaitView];
                                                  [CommonMethods showTextDialog:@"网络故障,请检查您的网络是否正常" inView:nil];
                                              });
                           }
                       }
                       else
                       {
                           BOOL needUpdate=NO;
                           NSDictionary *data;
                           NSString *URL = APP_DOWNLOAD_URL;
                           NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
                           [request setURL:[NSURL URLWithString:URL]];
                           [request setHTTPMethod:@"POST"];
                           NSHTTPURLResponse *urlResponse = nil;
                           NSError *error = nil;
                           NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
                           
                           NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
                           NSDictionary *dic = [results JSONValue];
                           NSArray *infoArray = [dic objectForKey:@"results"];
                           if ([infoArray count])
                           {
                               float currentVersion=[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]floatValue];
                               NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                               float lastVersion = [[releaseInfo objectForKey:@"version"]floatValue];
                               if (lastVersion>currentVersion)
                               {
                                   data=releaseInfo;
                                   NSString *trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
                                   [[Singleton sharedInstance]setTrackViewURL:trackViewURL];
                                   needUpdate=YES;
                               }
                           }
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods hideWaitView];
                                              if (needUpdate)
                                              {
                                                  //NSString *lastVersion = [data objectForKey:@"version"];
                                                  //NSString *releaseNotes=[data objectForKey:@"releaseNotes"];
                                                  UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                       message:@"检测到有新版本,请及时更新"
                                                                                                      delegate:[[UIApplication sharedApplication]delegate]
                                                                                             cancelButtonTitle:@"立即更新"
                                                                                             otherButtonTitles:nil];
                                                  [alertView setTag:AlertTagNewVersion];
                                                  [alertView show];
                                              }
                                              else if (!slience)
                                              {
                                                  [CommonMethods showTextDialog:@"当前已经是最新版本" inView:nil];
                                              }
                                          });
                       }
                   });
}

+(void)alipay:(Product*)product
{
	/*
	 *商户的唯一的parnter和seller。
	 */
    NSString *partner=product.partner;
    NSString *seller=product.seller;
    NSString *tradeNO=product.tradeNO;
    NSString *notifyURL=product.notifyURL;
    NSString *pvk=product.pvk;
	
	//partner和seller获取失败,提示
	if ([partner length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner"
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
    
    if ([seller length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少seller"
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
    
    if ([tradeNO length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少tradeNO"
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
    
    if ([notifyURL length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少notifyURL"
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
    
    if ([pvk length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少pvk"
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于快捷支付成功后重新唤起商户应用
	NSString *appScheme = @"plocc";
	
	//将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
    order.tradeNO=tradeNO; //订单ID
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = product.amount; //商品价格
	order.notifyURL =  notifyURL; //回调URL
	
	//将商品信息拼接成字符串
	NSString *orderInfo = [order description];
	NSLog(@"orderInfo = %@",orderInfo);
	
	//获取私钥并将商户信息签名
    id<DataSigner> signer= CreateRSADataSigner(pvk);
    NSString *signedString = [signer signString:orderInfo];
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo,
                             signedString,
                             @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:[[UIApplication sharedApplication]delegate]];
}

+ (void) showTip:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:msg
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    
    [alert show];
}

+ (ASIFormDataRequest*) asiHttpRequestWithURL:(NSString*)str andData:(NSString*)reqdata  andDelegate:(id)delegate
{
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"requesturl=%@?data=%@",url,reqdata);
    ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:TIME_OUT_TIME_INTERVAL];
    [request setShouldAttemptPersistentConnection:NO];
    [request setPersistentConnectionTimeoutSeconds:KEEP_ALIVE_TIME_INTERVAL];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    [request setSecondsToCache:CACHE_TIMEOUT_INTERVAL];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"type" value:@"app"];
    [request addRequestHeader:@"tgc" value:[[Singleton sharedInstance]TGC]];
    [request addRequestHeader:@"mac" value:[OCCUtiil getWifiMac]];
    [request addRequestHeader:@"uid" value:[NSString stringWithFormat:@"%d",[[Singleton sharedInstance]userId]]];
    [request addRequestHeader:@"client" value:@"ios"];
    [request addRequestHeader:@"version" value:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
    [request addRequestHeader:@"device" value:[OpenUDID value]];
    [request setPostValue:reqdata forKey:@"data"];
    [request setDelegate:delegate];
    [request startSynchronous];
    NSLog(@"server response:%@",[request responseString]);
    return request;
}

+ (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  username,@"loginname",
                                                  password,@"loginpwd",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:login_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                      });
                       
                       NSError *error = [request error];
                       if (error)
                       {
                           NSLog(@"Failed %@ with code %d and with userInfo %@",
                                 [error domain],
                                 [error code],
                                 [error userInfo]);
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"网络异常,请检查您的网络设置!" inView:nil];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:nil];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              NSLog(@"login%@",data);
                                              [[Singleton sharedInstance] setUserNickname:[data objectForKey:@"nickname"]];
                                              [[Singleton sharedInstance] setUserName:[data objectForKey:@"username"]];
                                              [[Singleton sharedInstance] setUserEmail:[data objectForKey:@"email"]];
                                              [[Singleton sharedInstance] setUserMobile:[data objectForKey:@"mobile"]];
                                              [[Singleton sharedInstance] setTGC:[data objectForKey:@"TGC"]];
                                              [[Singleton sharedInstance] setUserId:[[data objectForKey:@"id"]intValue]];
                                              
                                              // ==================NSUserDefaults========================
                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                              [defaults setObject:username forKey:OCC_USER_NAME];
                                              [defaults setObject:password forKey:OCC_USER_PASSWORD];
                                              [defaults synchronize];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessNotification" object:nil];
                                              
                                              [CommonMethods checkWifi];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

+ (void)login
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       NSString *username = (NSString *)[defaults objectForKey:OCC_USER_NAME];
                       NSString *userpassword = (NSString *)[defaults objectForKey:OCC_USER_PASSWORD];
                       if(username==nil || userpassword==nil){
                           return;
                       }
                       
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  username,@"loginname",
                                                  userpassword,@"loginpwd",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:login_URL andData:reqdata andDelegate:nil];
                       
                       NSError *error = [request error];
                       if (error)
                       {
                           NSLog(@"Failed %@ with code %d and with userInfo %@",
                                 [error domain],
                                 [error code],
                                 [error userInfo]);
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              NSLog(@"login%@",data);
                                              [[Singleton sharedInstance] setUserNickname:[data objectForKey:@"nickname"]];
                                              [[Singleton sharedInstance] setUserName:[data objectForKey:@"username"]];
                                              [[Singleton sharedInstance] setUserEmail:[data objectForKey:@"email"]];
                                              [[Singleton sharedInstance] setUserMobile:[data objectForKey:@"mobile"]];
                                              [[Singleton sharedInstance] setTGC:[data objectForKey:@"TGC"]];
                                              [[Singleton sharedInstance] setUserId:[[data objectForKey:@"id"]intValue]];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessNotification"
                                                                                                  object:nil];
                                              
                                              [CommonMethods checkWifi];
                                          });
                       }else{
                           
                       }
                   });
}

+ (void)checkWifi
{
    NSString *ssid=[OCCUtiil getWifiSSID];
    if ([ssid isEqualToString:POWERLONG_WIFI_SSID])
    {
        BOOL isLogin=[CommonMethods onlycheckIsLogin];
        if (isLogin==YES)
        {
            [CommonMethods conntWifi];
        }
    }
}

+ (void)conntWifi
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       NSString *username = (NSString *)[defaults objectForKey:OCC_USER_NAME];
                       NSString *userpassword = (NSString *)[defaults objectForKey:OCC_USER_PASSWORD];
                       if(username==nil || userpassword==nil)
                       {
                           return;
                       }
                       
                       NSString *mac=[OCCUtiil getWifiMac];
                       if(mac==nil || [mac length]==0)
                       {
                           return;
                       }
                       
                       NSDictionary *obj =[NSDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]],@"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  username,@"loginname",
                                                  userpassword,@"password",
                                                  [OCCUtiil getWifiIp],@"ip",
                                                  mac,@"mac",
                                                  [OCCUtiil getWifiSSID],@"ssid",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       NSString *wifiURL=[OCCUtiil getWifiFromMallData];
                       if (wifiURL!=nil&&[wifiURL length]>0)
                       {
                           ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:wifiURL andData:reqdata andDelegate:nil];
                       }
                   });
}

+ (NSString*)parseText:(NSString*)text fromHtmlString:(NSString*)str
{
    NSArray *arr=[str componentsSeparatedByString:@"&"];
    for (NSString *str in arr)
    {
        NSArray *list=[str componentsSeparatedByString:@"="];
        NSString *str0=[list objectAtIndex:0];
        NSString *str1=[list objectAtIndex:1];
        if ([str0 isEqualToString:text])
        {
            return str1;
        }
    }
    
    return @"";
}

+ (NSString*)encodeURL:(NSString *)string
{
    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
    NSString *encodedValue = [formDataRequest encodeURL:string];
    return encodedValue;
}

@end
