//
//  ViewController.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ViewController.h"
#import "NavViewController.h"
#import "MMDrawerController.h"
#import "CenterViewController.h"
#import "BusinessManager.h"
#import "NaviManager.h"
#import "SearchManager.h"
#import "Reachability.h"
#import "AHReach.h"

@interface ViewController ()
@property(nonatomic, strong) Reachability  *hostReach;
@property(nonatomic, strong) NSArray *reaches;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    AHReach *defaultHostReach = [AHReach reachForDefaultHost];
	[defaultHostReach startUpdatingWithBlock:^(AHReach *reach)
    {
		[self updateAvailabilityReach:reach];
	}];
    self.reaches=[NSArray arrayWithObjects:defaultHostReach,nil];

    [self performSelector:@selector(initUIView)
               withObject:nil
               afterDelay:0.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{

}

- (void)initUIView
{
    NavViewController* leftController = [[NavViewController alloc] init];
    CenterViewController *centerController=[[CenterViewController alloc]init];
    self.leftController=[[UINavigationController alloc]initWithRootViewController:leftController];
    self.centerController=centerController;
    self.rightController=nil;
    self.leftSize = 54;
    self.rightSize = 54;
    self.openSlideAnimationDuration = 0.3f;
    self.closeSlideAnimationDuration = 0.3f;
    self.bounceOpenSideDurationFactor = 0.3f;
}

- (void)updateAvailabilityReach:(AHReach *)reach
{
	if([reach isReachableViaWiFi])
    {
        NSLog(@"wifi.");
        [CommonMethods checkWifi];
    }
    else if([reach isReachableViaWWAN])
    {
        NSLog(@"wwan.");
    }
    else
    {
        NSLog(@"no net.");
    }
}

@end
