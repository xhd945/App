//
//  ShowBigImageViewController.h
//  occ
//
//  Created by plocc on 13-12-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowBigImageViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@property (nonatomic, strong) NSArray *imageList;

- (void)initWithImageList:(NSArray *)list andSelectedIndex:(NSInteger)index;


@end
