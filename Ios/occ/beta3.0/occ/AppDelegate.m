//
//  AppDelegate.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "AppDelegate.h"
#import "NextViewController.h"
#import "MyOrderListViewController.h"
#import "MyOOrderListViewController.h"
#import <sys/utsname.h>
#import "ViewController.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "SearchManager.h"
#import "MyGrouponListViewController.h"
#import "TestViewController.h"

@implementation AppDelegate

#pragma mark -
#pragma mark APP LyfeCycel
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    [navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController=navigationController;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |
                                                                            UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    self.pck=AlipayPubKey;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersionNotification:) name:OCC_NOTIFI_CHECKVERSION_RETURN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMallNotification:)
                                                 name:@"changeMallNotification"
                                               object:nil];
    
    self.splashImageView=[[UIImageView alloc]init];
    self.splashImageView.frame=CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT);
    self.splashImageView.image=[UIImage imageNamed:@"H0.jpg"];
    self.splashImageView.userInteractionEnabled=YES;
    
    //增加标识，用于判断是否是第一次启动应用...
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:SECOND_LAUNCH])
    {
        NextViewController *nextViewController = [[NextViewController alloc]init];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    else
    {
        [self splashShowHide];
    }
    
    //创建APP缓存文件夹 分类管理缓存数据
    [self addAPPCacheFile];
    
    //检查缓存版本
    [self checkCacheVersion];
    
    //请求Search数据缓存
    [[BusinessManager sharedManager].searchManager requestSearchBaseCategoryData];
    
    [NSTimer scheduledTimerWithTimeInterval:60*60*24.0
                                     target:self
                                   selector:@selector(appVersionCheckFired:)
                                   userInfo:nil
                                    repeats:YES];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"apns->userInfo:%@", userInfo);
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"apns->deviceToken:%@", deviceToken);
    [Singleton sharedInstance].deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]; //去掉"<>"
    //self.deviceToken = [[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉中间空格
    //self.deviceToken = [[self.deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];//去掉"<>"
    //self.deviceToken = [[self.deviceToken description] stringByReplacingOccurrencesOfString:@">" withString:@""];//去掉"<>"
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"apns->error:%@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [CommonMethods checkVersionWithTarget:self andSlience:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	[self parseURL:url application:application];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self parseURL:url application:application];
    return YES;
}

#pragma mark -
#pragma mark Creat APP Cache Data File
- (void)addAPPCacheFile
{
    [CommonMethods addFolderToPath:nil withFolderName:OCC_DATA_CACHE_FOLDER];
    [CommonMethods addFolderToPath:nil withFolderName:OCC_IMAGE_CACHE_FOLDER];
}

#pragma mark -
#pragma mark Check Cache Version
- (NSNumber *)getVersionNumberWithKeyWord:(NSString *)keyWord
{
    NSNumber *returnValue = nil;
    if (_versionInfo && [[_versionInfo allKeys] count] > 0)
    {
        NSArray *versionList = [_versionInfo valueForKey:KEY_VERSIONLIST];
        for (NSDictionary *dic in versionList)
        {
            if ([[dic valueForKey:KEY_CODE] isEqualToString:keyWord])
            {
                returnValue = [dic valueForKey:KEY_VERSION];
                break;
            }
        }
    }
    return returnValue;
}

//网路请求缓存数据版本
- (void)checkCacheVersion
{
    //读取旧数据
    NSString *fileName=[NSString stringWithFormat:@"mall_%d_version.plist",[[Singleton sharedInstance]mall]];
    NSString *filePath = [CommonMethods getDataCachePathWithFileName:fileName];
    _versionInfo = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    //请求新的版本信息
    [[BusinessManager sharedManager].naviManager checkVersionRequest];
}

- (void)changeMallNotification:(NSNotification *)noti
{
    [self checkCacheVersion];
}

- (void)checkVersionNotification:(NSNotification *)noti
{
    //不存在旧的缓存信息 直接请求缓存
    if (_versionInfo && [_versionInfo count] > 0)
    {
        NSDictionary *returnData = [[noti userInfo] valueForKey:kReturnDataKey];
        if (returnData && [[returnData allKeys] count] > 0)
        {
            //循环遍历版本列表 更新需要更新缓存的接口
            NSArray *versionList = [returnData valueForKey:KEY_VERSIONLIST];
            for (NSDictionary *item in versionList)
            {
                NSNumber *itemVersion = nil;
                NSNumber *itemOldVerson = nil;
                if ([[item valueForKey:KEY_CODE] isEqualToString:KEY_FLOOR])
                {
                    itemVersion = [item valueForKey:KEY_VERSION];
                    itemOldVerson = [self getVersionNumberWithKeyWord:KEY_FLOOR];
                    if (itemVersion != itemOldVerson)
                    {
                        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeFloor];
                    }
                }
                else if ([[item valueForKey:KEY_CODE] isEqualToString:KEY_CATEGORY])
                {
                    itemVersion = [item valueForKey:KEY_VERSION];
                    itemOldVerson = [self getVersionNumberWithKeyWord:KEY_CATEGORY];
                    if (itemVersion != itemOldVerson)
                    {
                        [[BusinessManager sharedManager].searchManager requestSearchBaseCategoryData];
                    }
                }
                else if ([[item valueForKey:KEY_CODE] isEqualToString:KEY_EAT])
                {
                    itemVersion = [item valueForKey:KEY_VERSION];
                    itemOldVerson = [self getVersionNumberWithKeyWord:KEY_EAT];
                    if (itemVersion != itemOldVerson)
                    {
                        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeFood];
                    }
                }
                else if ([[item valueForKey:KEY_CODE] isEqualToString:KEY_PLAY])
                {
                    itemVersion = [item valueForKey:KEY_VERSION];
                    itemOldVerson = [self getVersionNumberWithKeyWord:KEY_PLAY];
                    if (itemVersion != itemOldVerson)
                    {
                        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeEntertainment];
                    }
                }
                else if ([[item valueForKey:KEY_CODE] isEqualToString:KEY_BUY])
                {
                    itemVersion = [item valueForKey:KEY_VERSION];
                    itemOldVerson = [self getVersionNumberWithKeyWord:KEY_BUY];
                    if (itemVersion != itemOldVerson)
                    {
                        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeBuy];
                    }
                }
                else if ([[item valueForKey:KEY_CODE] isEqualToString:KEY_FRONTPAGE])
                {
                    itemVersion = [item valueForKey:KEY_VERSION];
                    itemOldVerson = [self getVersionNumberWithKeyWord:KEY_FRONTPAGE];
                    if (itemVersion != itemOldVerson)
                    {
                        [[BusinessManager sharedManager].naviManager requestFrontPage];
                    }
                }
            }
        }
        else
        {
            ZSLog(@"版本更新信息请求失败");
        }
    }
    else
    {
        //请求缓存数据 首页、导航、搜索
        [[BusinessManager sharedManager].naviManager requestFrontPage];
        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeFloor];
        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeFood];
        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeEntertainment];
        [[BusinessManager sharedManager].naviManager loadNaviData:NavTypeBuy];
        [[BusinessManager sharedManager].searchManager requestSearchBaseCategoryData];
    }
}

//app回调函数
- (void)parseURL:(NSURL *)url application:(UIApplication *)application
{
	//结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    [self handleResult:result];
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
    
    [self handleResult:result];
}

-(void)handleResult:(AlixPayResult*)result
{
    if (result)
    {
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = self.pck;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:@"支付成功"
																	delegate:[[UIApplication sharedApplication]delegate]
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
                [alertView setTag:AlertTagpPaySucces];
				[alertView show];
			}
			else
            {
                //验签错误
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:@"签名错误"
																	delegate:[[UIApplication sharedApplication]delegate]
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
                [alertView setTag:AlertTagpPayFail];
				[alertView show];
			}
        }
        else
        {
            //交易失败
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:result.statusMessage
																delegate:[[UIApplication sharedApplication]delegate]
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
            [alertView setTag:AlertTagpPayFail];
			[alertView show];
        }
    }
    else
    {
        //失败
    }
}

- (AlixPayResult *)resultFromURL:(NSURL *)url
{
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url
{
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == AlertTagAlipax)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
        [self.navigationController popToRootViewControllerAnimated:NO];
	}
    else if (alertView.tag == AlertTagpPaySucces)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        if ([[Singleton sharedInstance]lastOrderType]==LastOrderTypeGroupon)
        {
            MyGrouponListViewController *viewController=[[MyGrouponListViewController alloc]init];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            MyOOrderListViewController *viewController=[[MyOOrderListViewController alloc]init];
            [viewController setStat:MyOOrderStatWillSend];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [myDelegate.navigationController pushViewController:viewController animated:YES];
        }
	}
    else if (alertView.tag == AlertTagpPayFail)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        MyOrderListViewController *viewController=[[MyOrderListViewController alloc]init];
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate.navigationController pushViewController:viewController animated:YES];
	}
    else if (alertView.tag == AlertTagNewVersion)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[Singleton sharedInstance]trackViewURL]]];
	}
}

//timer调用函数
-(void)appVersionCheckFired:(NSTimer *)timer
{
    [CommonMethods checkVersionWithTarget:self andSlience:YES];
}

-(void)splashShowHide
{
    [self splashShow];
    [self splashHide];
}

-(void)splashHide
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:1.25f animations:^{
            self.splashImageView.alpha=0;
            CGAffineTransform newTransform = CGAffineTransformMakeScale(1.5, 1.5);
            [self.splashImageView setTransform:newTransform];
        } completion:^(BOOL finished) {
            self.splashImageView.alpha=1;
            CGAffineTransform newTransform = CGAffineTransformMakeScale(1.0, 1.0);
            [self.splashImageView setTransform:newTransform];
            
            [self.splashImageView removeFromSuperview];
            [CommonMethods checkVersionWithTarget:self andSlience:YES];
        }];
    });
}

-(void)splashShow
{
    [self.window addSubview:self.splashImageView];
}
@end
