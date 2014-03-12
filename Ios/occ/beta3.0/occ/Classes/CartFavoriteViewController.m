//
//  ShoppingCartViewController.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "CartFavoriteViewController.h"
#import "CartViewController.h"
#import "FavoriteViewController.h"

@interface CartFavoriteViewController ()

@end

@implementation CartFavoriteViewController

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
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    //tab===========================================================
    OCCSegement *segement = [[OCCSegement alloc]initWithFrame:CGRectMake(10, 10, 300, 30)
                                                         type:OCCSegementTypeDefaultThree
                                                andTitleArray:[NSArray arrayWithObjects:@"购物车",@"收藏商品",nil]];
    segement.delegate = self;
    [self.view addSubview:segement];
    _segement=segement;
    
    [self performSelector:@selector(doLayoutViews) withObject:nil afterDelay:0.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark OCCSegementDelegate
- (void)selectedSegementIndex:(NSInteger)index
{
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.75f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    NSUInteger green = [[self.view subviews] indexOfObject:self.cartViewController.view];
    NSUInteger blue = [[self.view subviews] indexOfObject:self.favoriteViewController.view];
    [self.view exchangeSubviewAtIndex:green withSubviewAtIndex:blue];
    [UIView commitAnimations];
    
    if (index==1)
    {
        [self.cartViewController.tableView reloadData];
    }
}

- (void)doLayoutViews
{
    CartViewController *cartViewController=[[CartViewController alloc]init];
    [self.view addSubview:cartViewController.view];
    [cartViewController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-FOOTER_HEIGHT)];
    [self.view sendSubviewToBack:cartViewController.view];
    cartViewController.segement=self.segement;
    _cartViewController=cartViewController;
    
    FavoriteViewController *favoriteViewController=[[FavoriteViewController alloc]init];
    [self.view addSubview:favoriteViewController.view];
    [favoriteViewController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-FOOTER_HEIGHT)];
    [self.view sendSubviewToBack:favoriteViewController.view];
    favoriteViewController.segement=self.segement;
    _favoriteViewController=favoriteViewController;
}

@end
