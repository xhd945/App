//
//  CenterViewController.m
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "CenterViewController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "NearbyViewController.h"
#import "CartFavoriteViewController.h"
#import "SearchResultViewController.h"
#import "AccountViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#define kTabbarItemCount 5
//#define kTabbarImageHeight

typedef enum {
    TabViewTypeHome,
    TabViewTypeSearch,
    TabViewTypeNearby,
    TabViewTypeCartFavorite,
    TabViewTypeAccount,
}TabViewType;


@interface CenterViewController ()

@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessNotification:)
                                                 name:@"loginSuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toCartNotification:)
                                                 name:@"toCartNotification"
                                               object:nil];
    
    //增加标识，用于判断是否是第一次启动应用...
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:SECOND_LAUNCH])
    {
        [defaults setBool:YES forKey:SECOND_LAUNCH];
        [defaults synchronize];
    }
    
    self.delegate =self;
    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_selected"]];
    [self.tabBar setHidden:NO];
    self.tabBar.clipsToBounds = YES;
    self.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT - 51, 320, 51);
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tab_bg"];
    
    HomeViewController *homeViewController = [[HomeViewController alloc]init];
    homeViewController.delegate=self;
    homeViewController.tabBarItem=[[UITabBarItem alloc]initWithTitle:nil image:nil tag:TabViewTypeHome];

    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    searchViewController.tabBarItem=[[UITabBarItem alloc]initWithTitle:nil image:nil tag:TabViewTypeSearch];
//    [searchViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"menu_search_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"menu_search_nor"]];
//    [searchViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_999999,UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//    [searchViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_DA6432,UITextAttributeTextColor,nil]
//                                                 forState:UIControlStateSelected];
    
    NearbyViewController *nearbyViewController = [[NearbyViewController alloc]init];
    nearbyViewController.delegate=self;
    nearbyViewController.tabBarItem=[[UITabBarItem alloc]initWithTitle:nil image:nil tag:TabViewTypeNearby];
//    [nearbyViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"menu_near_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"menu_near_nor"]];
//    [nearbyViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_999999,UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//    [nearbyViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_DA6432,UITextAttributeTextColor,nil]
//                                                 forState:UIControlStateSelected];
    
    CartFavoriteViewController *shoppingCartViewController = [[CartFavoriteViewController alloc]init];
    shoppingCartViewController.tabBarItem=[[UITabBarItem alloc]initWithTitle:nil image:nil tag:TabViewTypeCartFavorite];
//    [shoppingCartViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"menu_cart_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"menu_cart_nor"]];
//    [shoppingCartViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_999999,UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//    [shoppingCartViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_DA6432,UITextAttributeTextColor,nil]
//                                                         forState:UIControlStateSelected];
    
    AccountViewController *accountViewController = [[AccountViewController alloc]init];
    accountViewController.delegate=self;
    accountViewController.tabBarItem=[[UITabBarItem alloc]initWithTitle:nil image:nil tag:TabViewTypeAccount];
//    [accountViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_home"]];
//    [accountViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_999999,UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//    [accountViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_DA6432,UITextAttributeTextColor,nil]
//                                                 forState:UIControlStateSelected];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            homeViewController,
                            [[UINavigationController alloc]initWithRootViewController:searchViewController],
                            nearbyViewController,
                            shoppingCartViewController,
                            accountViewController,
                            nil];
    
    [self addCustomTabbarImage];
    
    self.selectedIndex=TabViewTypeCartFavorite;
    self.selectedIndex=TabViewTypeAccount;
    self.selectedIndex=TabViewTypeHome;
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [CommonMethods login];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) loginSuccessNotification:(NSNotification*)notification
{
    self.selectedIndex=self.needSelect;
    [self tabbarUIChangeWithCurrentSelectedIndex:self.selectedIndex];
}

- (void) toCartNotification:(NSNotification*)notification
{
    [self.viewDeckController closeLeftViewAnimated:YES
                                        completion:^(IIViewDeckController *controller, BOOL success) {
                                            self.selectedIndex=3;
                                            [self tabbarUIChangeWithCurrentSelectedIndex:self.selectedIndex];
                                            
                                            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                            [myDelegate.navigationController popToRootViewControllerAnimated:YES];
                                            
                                            UIViewController *viewController = [self.viewControllers objectAtIndex:self.selectedIndex];
                                            if ([viewController isKindOfClass:[CartFavoriteViewController class]])
                                            {
                                                [((CartFavoriteViewController*)viewController).segement selectItem:0];
                                            }
                                        }];
}

#pragma mark -
#pragma mark HomeViewDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL isLogin=YES;
    NSInteger curIndex = [self.viewControllers indexOfObject:viewController];
    if ([viewController isKindOfClass:[CartFavoriteViewController class]]) {
        self.needSelect=3;
        isLogin=[CommonMethods checkIsLogin];
    }
    else if ([viewController isKindOfClass:[AccountViewController class]])
    {
        self.needSelect=4;
        isLogin=[CommonMethods checkIsLogin];
    }

    if (isLogin)
    {
        [self tabbarUIChangeWithCurrentSelectedIndex:curIndex];
    }

    self.needSelect=curIndex;
    return isLogin;
}

#pragma mark -
#pragma mark Tabbar Custom UI
- (void)addCustomTabbarImage
{
    _tabbarItemOne = [[OCCBarItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 5, self.tabBar.frame.size.height)];
    _tabbarItemOne.normalImage = [UIImage imageNamed:@"tabbar_home"];
    _tabbarItemOne.selectedImage = [UIImage imageNamed:@"tabbar_home_selected"];
    _tabbarItemOne.title = @"首页";
    [self.tabBar addSubview:_tabbarItemOne];
    [_tabbarItemOne setSelected:YES];
    
    _tabbarItemTwo = [[OCCBarItem alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5, 0, SCREEN_WIDTH / 5, self.tabBar.frame.size.height)];
    _tabbarItemTwo.normalImage = [UIImage imageNamed:@"tabbar_search"];
    _tabbarItemTwo.selectedImage = [UIImage imageNamed:@"tabbar_search_selected"];
    _tabbarItemTwo.title = @"搜索";
    [_tabbarItemTwo setSelected:NO];
    [self.tabBar addSubview:_tabbarItemTwo];
    
    _tabbarItemThree = [[OCCBarItem alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 2, 0, SCREEN_WIDTH / 5, self.tabBar.frame.size.height)];
    _tabbarItemThree.normalImage = [UIImage imageNamed:@"tabbar_nearby"];
    _tabbarItemThree.selectedImage = [UIImage imageNamed:@"tabbar_nearby_selected"];
    _tabbarItemThree.title = @"附近";
    [_tabbarItemThree setSelected:NO];
    [self.tabBar addSubview:_tabbarItemThree];
    
    _tabbarItemFour = [[OCCBarItem alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 3, 0, SCREEN_WIDTH / 5, self.tabBar.frame.size.height)];
    _tabbarItemFour.normalImage = [UIImage imageNamed:@"tabbar_buy"];
    _tabbarItemFour.selectedImage = [UIImage imageNamed:@"tabbar_buy_selected"];
    _tabbarItemFour.title = @"购物车";
    [_tabbarItemFour setSelected:NO];
    [self.tabBar addSubview:_tabbarItemFour];
    
    _tabbarItemFive = [[OCCBarItem alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 4, 0, SCREEN_WIDTH / 5, self.tabBar.frame.size.height)];
    _tabbarItemFive.normalImage = [UIImage imageNamed:@"tabbar_account"];
    _tabbarItemFive.selectedImage = [UIImage imageNamed:@"tabbar_account_selected"];
    _tabbarItemFive.title = @"我的账户";
    [_tabbarItemFive setSelected:NO];
    [self.tabBar addSubview:_tabbarItemFive];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.tabbarItemFour=_tabbarItemFour;
    myDelegate.tabbarItemFive=_tabbarItemFive;
    
    _cartButton = [[OCCCartButton alloc]init];
    _cartButton.center=CGPointMake(285, SCREEN_HEIGHT-40);
    [_cartButton addTarget:self action:@selector(doToCart:) forControlEvents:UIControlEventTouchUpInside];
    
    myDelegate.cartButton=_cartButton;
}

- (void)tabbarUIChangeWithCurrentSelectedIndex:(NSInteger )curIndex
{
    if (curIndex == 2)
    {
        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_selected_middle"]];
    }
    else
    {
        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_selected"]];
    }

    [_tabbarItemOne setSelected:curIndex == 0?YES:NO];
    [_tabbarItemTwo setSelected:curIndex == 1?YES:NO];
    [_tabbarItemThree setSelected:curIndex == 2?YES:NO];
    [_tabbarItemFour setSelected:curIndex == 3?YES:NO];
    [_tabbarItemFive setSelected:curIndex == 4?YES:NO];
}

#pragma mark -
#pragma mark HomeViewDelegate
- (void)toggleLeftView
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)showSearchResultView
{
    
}

- (void)selectFirst
{
    self.selectedIndex=0;
}

- (void)selectSecond
{
    self.selectedIndex=1;
}

- (void)doToCart:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toCartNotification" object:nil];
}

@end
