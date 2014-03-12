//
//  OCCRatingView.m
//  occ
//
//  Created by zhangss on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCRatingView.h"

#define kUnSelectedStarName @"level_dark"
#define kHalfSelectedStarName @""
#define kFullSelectedStarName @"level_light"

#define kStartInterval 3

@implementation OCCRatingView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.userInteractionEnabled = NO;
        _unselectedImage = [UIImage imageNamed:kUnSelectedStarName];
        _halfSelectedImage = [kHalfSelectedStarName length] == 0 ? _unselectedImage : [UIImage imageNamed:kHalfSelectedStarName];
        _fullySelectedImage = [UIImage imageNamed:kFullSelectedStarName];
        _newRating = 0.0;
        _lastRating = 0.0;
        
        CGFloat height = _unselectedImage.size.height;
        CGFloat width = _unselectedImage.size.width;
        
        _imageViewOne = [[UIImageView alloc] initWithImage:_unselectedImage];
        _imageViewTwo = [[UIImageView alloc] initWithImage:_unselectedImage];
        _imageViewThree = [[UIImageView alloc] initWithImage:_unselectedImage];
        _imageViewFour = [[UIImageView alloc] initWithImage:_unselectedImage];
        _imageViewFive = [[UIImageView alloc] initWithImage:_unselectedImage];
        
        [_imageViewOne   setFrame:CGRectMake(0,         0, width, height)];
        [_imageViewTwo   setFrame:CGRectMake(1 * width + kStartInterval * 1, 0, width, height)];
        [_imageViewThree setFrame:CGRectMake(2 * width + kStartInterval * 2, 0, width, height)];
        [_imageViewFour  setFrame:CGRectMake(3 * width + kStartInterval * 3, 0, width, height)];
        [_imageViewFive  setFrame:CGRectMake(4 * width + kStartInterval * 4, 0, width, height)];
        
        [_imageViewOne setUserInteractionEnabled:NO];
        [_imageViewTwo setUserInteractionEnabled:NO];
        [_imageViewThree setUserInteractionEnabled:NO];
        [_imageViewFour setUserInteractionEnabled:NO];
        [_imageViewFive setUserInteractionEnabled:NO];
        
        [self addSubview:_imageViewOne];
        [self addSubview:_imageViewTwo];
        [self addSubview:_imageViewThree];
        [self addSubview:_imageViewFour];
        [self addSubview:_imageViewFive];
        
        CGRect frame = [self frame];
        frame.size.width = width * 5 + kStartInterval * 5;
        frame.size.height = height;
        [self setFrame:frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = NO;
        _unselectedImage = [UIImage imageNamed:kUnSelectedStarName];
        _halfSelectedImage = [kHalfSelectedStarName length] == 0 ? _unselectedImage : [UIImage imageNamed:kHalfSelectedStarName];
        _fullySelectedImage = [UIImage imageNamed:kFullSelectedStarName];
        _newRating = 0.0;
        _lastRating = 0.0;
        
        CGFloat height = _unselectedImage.size.height;
        CGFloat width = _unselectedImage.size.width;
        
        _imageViewOne = [[UIImageView alloc] initWithImage:_unselectedImage];
        _imageViewTwo = [[UIImageView alloc] initWithImage:_unselectedImage];
        _imageViewThree = [[UIImageView alloc] initWithImage:_unselectedImage];
        _imageViewFour = [[UIImageView alloc] initWithImage:_unselectedImage];
        _imageViewFive = [[UIImageView alloc] initWithImage:_unselectedImage];
        
        [_imageViewOne   setFrame:CGRectMake(0,         0, width, height)];
        [_imageViewTwo   setFrame:CGRectMake(1 * width + kStartInterval * 1, 0, width, height)];
        [_imageViewThree setFrame:CGRectMake(2 * width + kStartInterval * 2, 0, width, height)];
        [_imageViewFour  setFrame:CGRectMake(3 * width + kStartInterval * 3, 0, width, height)];
        [_imageViewFive  setFrame:CGRectMake(4 * width + kStartInterval * 4, 0, width, height)];
        
        [_imageViewOne setUserInteractionEnabled:NO];
        [_imageViewTwo setUserInteractionEnabled:NO];
        [_imageViewThree setUserInteractionEnabled:NO];
        [_imageViewFour setUserInteractionEnabled:NO];
        [_imageViewFive setUserInteractionEnabled:NO];
        
        [self addSubview:_imageViewOne];
        [self addSubview:_imageViewTwo];
        [self addSubview:_imageViewThree];
        [self addSubview:_imageViewFour];
        [self addSubview:_imageViewFive];
        
        CGRect frame = [self frame];
        frame.size.width = width * 5 + kStartInterval * 5;
        frame.size.height = height;
        [self setFrame:frame];
    }
    return self;
}

#pragma mark -
#pragma mark TouchMethods
- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
	[self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    //计算星级
	CGPoint pt = [[touches anyObject] locationInView:self];
	NSInteger rating = (NSInteger)(pt.x / (_unselectedImage.size.width + kStartInterval)) + 1;
	if (rating < 1 || rating > 5)
    {
		return;
    }
	if (rating != _lastRating)
    {
		[self setRating:[NSNumber numberWithFloat:rating]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesMoved:touches withEvent:event];
}

#pragma mark -
#pragma mark 外部调用方法 直接赋值星等
- (void)setRating:(NSNumber *)ratingNumber
{
    [_imageViewOne setImage:_unselectedImage];
    [_imageViewTwo setImage:_unselectedImage];
    [_imageViewThree setImage:_unselectedImage];
    [_imageViewFour setImage:_unselectedImage];
    [_imageViewFive setImage:_unselectedImage];
    
    CGFloat rating = [ratingNumber floatValue];
	if (rating >= 0.5) {
		[_imageViewOne setImage:_halfSelectedImage];
	}
	if (rating >= 1) {
		[_imageViewOne setImage:_fullySelectedImage];
	}
	if (rating >= 1.5) {
		[_imageViewTwo setImage:_halfSelectedImage];
	}
	if (rating >= 2) {
		[_imageViewTwo setImage:_fullySelectedImage];
	}
	if (rating >= 2.5) {
		[_imageViewThree setImage:_halfSelectedImage];
	}
	if (rating >= 3) {
		[_imageViewThree setImage:_fullySelectedImage];
	}
	if (rating >= 3.5) {
		[_imageViewFour setImage:_halfSelectedImage];
	}
	if (rating >= 4) {
		[_imageViewFour setImage:_fullySelectedImage];
	}
	if (rating >= 4.5) {
		[_imageViewFive setImage:_halfSelectedImage];
	}
	if (rating >= 5) {
		[_imageViewFive setImage:_fullySelectedImage];
	}
    
    _newRating = rating;
	_lastRating = rating;
}

- (NSNumber *)getRating
{
    return [NSNumber numberWithFloat:_newRating];
}


@end
