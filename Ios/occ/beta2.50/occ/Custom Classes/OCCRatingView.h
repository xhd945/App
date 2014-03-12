//
//  OCCRatingView.h
//  occ
//
//  Created by zhangss on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCCRatingView : UIView
{
    UIImage *_unselectedImage;
    UIImage *_halfSelectedImage;
    UIImage *_fullySelectedImage;
    
    UIImageView *_imageViewOne;
    UIImageView *_imageViewTwo;
    UIImageView *_imageViewThree;
    UIImageView *_imageViewFour;
    UIImageView *_imageViewFive;
    
    CGFloat      _lastRating;
    CGFloat      _newRating;
}

//设置星级
- (void)setRating:(NSNumber *)ratingNumber;

//获取星级
- (NSNumber *)getRating;

@end
