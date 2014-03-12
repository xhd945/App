//
//  ShowBigImageViewController.m
//  occ
//
//  Created by plocc on 13-12-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ShowBigImageViewController.h"

#define kImageViewTag 100
#define kScrollViewTag 1000
#define kCacheImageCount 3

@interface ShowBigImageViewController ()

@end

@implementation ShowBigImageViewController

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
}

- (void)initWithImageList:(NSArray *)list andSelectedIndex:(NSInteger)index
{
    _imageList = [NSArray arrayWithArray:list];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * [list count], SCREEN_HEIGHT);
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 40)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = [list count];
    _pageControl.currentPage = index;
    [self.view addSubview:_pageControl];
    
    [self creatImageView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatImageView
{
    for (int i = 0; i < [_imageList count]; i++)
    {
        UIScrollView *photoScrollView = nil;
        photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        photoScrollView.minimumZoomScale = 1.0;
        photoScrollView.maximumZoomScale = 2.0;
        photoScrollView.zoomScale = 1.0;
        photoScrollView.delegate = self;
        photoScrollView.tag = kScrollViewTag + i;
        photoScrollView.backgroundColor = [UIColor blackColor];
        //photoScrollView.alpha = 0.9;
        photoScrollView.contentMode = UIViewContentModeCenter;
        
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:_scrollView.frame];
        photoImageView.tag = kImageViewTag + i;
        photoImageView.backgroundColor = [UIColor clearColor];
        photoImageView.userInteractionEnabled = YES;
        photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tapDoubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
        tapDoubleGesture.numberOfTapsRequired = 2;
        tapDoubleGesture.delegate = self;
        [photoImageView addGestureRecognizer:tapDoubleGesture];
        
        UITapGestureRecognizer *tapSingleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        tapSingleGesture.numberOfTapsRequired = 1;
        tapSingleGesture.delegate = self;
        //[tapSingleGesture requireGestureRecognizerToFail:tapDoubleGesture];
        [photoScrollView addGestureRecognizer:tapSingleGesture];
        
        [photoScrollView addSubview:photoImageView];
        [_scrollView addSubview:photoScrollView];
        [self loadBigImage:i andPhotoImageView:photoImageView];
    }
}

- (void)doubleTapGesture:(UIGestureRecognizer *)gesture
{
    
}

- (void)loadBigImage:(int)index andPhotoImageView:(UIImageView*)photoImageView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSString *urlString = [_imageList objectAtIndex:index];
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  urlString,@"picPath",
                                                  [NSString stringWithFormat:@"%0.f",photoImageView.frame.size.height],@"panelHeight",
                                                  [NSString stringWithFormat:@"%0.f",photoImageView.frame.size.width],@"panelWidth",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                                              
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:pictureHandle_URL andData:reqdata andDelegate:nil];
                       
                       NSError *error = [request error];
                       if (error)
                       {
                           NSLog(@"Failed %@ with code %d and with userInfo %@",
                                 [error domain],
                                 [error code],
                                 [error userInfo]);
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"网络异常,请检查您的网络设置!" inView:self.view];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              NSLog(@"%@",data);
                                              sleep(0.5);
                                              NSURL *url = [NSURL URLWithString:[[data objectForKey:@"picPath"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                              [photoImageView setImageWithURL:url usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)singleTap
{
    [UIView animateWithDuration:.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                     } completion:^(BOOL finished){
                         [self.navigationController popViewControllerAnimated:NO];
                     }];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat pageWidth = aScrollView.frame.size.width;
    NSInteger curPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [_pageControl setCurrentPage:curPage];
}

@end
