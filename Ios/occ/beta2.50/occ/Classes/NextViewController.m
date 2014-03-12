//
//  NextViewController.m
//  occ
//
//  Created by RS on 13-10-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

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
    NSArray *iamgeArray=[[NSArray alloc]initWithObjects:@"H1.jpg",
                         @"H2.jpg",
                         @"H3.jpg",
                         @"H4.jpg",
                         nil];
    CGRect screenSize=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;
    
    //滚动scroolview
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.size.width, screenSize.size.height)];
    self.scrollView.contentSize=CGSizeMake(screenSize.size.width*[iamgeArray count], screenSize.size.height);
    self.scrollView.delegate=self;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.bounces=NO;
    [self.view addSubview:self.scrollView];
    
    for (int i=0; i<[iamgeArray count]; i++)
    {
        UIImageView *imageview=[[UIImageView alloc]init];
        imageview.image=[UIImage imageNamed:[iamgeArray objectAtIndex:i]];
        imageview.frame=CGRectMake(screenSize.size.width*i, 0, screenSize.size.width, screenSize.size.height);
        [imageview setUserInteractionEnabled:YES];
        [self.scrollView addSubview:imageview];
        
        if (i==[iamgeArray count]-1)
        {
            UIImage *bgImage=[UIImage imageNamed:@"btn_white.png"];
            bgImage=[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake((screenSize.size.width-180)/2, screenSize.size.height-150, 180, 80);
            //[button setTitle:@"开始体验吧" forState:UIControlStateNormal];
            //[button setBackgroundImage:bgImage forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [imageview addSubview:button];
        }
    }
    
    //pageControl
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(screenSize.size.width/2-150, screenSize.size.height-50, 100, 36)];
    self.pageControl.numberOfPages=[iamgeArray count];
    self.pageControl.currentPage=0;
    self.pageControl.enabled=NO;
    //[self.view addSubview:self.pageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    //UITouch *touch = [[event allTouches]anyObject];
    //UIView *touchView=touch.view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

-(void)btnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
