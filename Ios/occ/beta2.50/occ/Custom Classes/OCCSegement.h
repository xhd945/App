//
//  OCCSegement.h
//  occ
//
//  Created by zhangss on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OCCSegementType)
{
    OCCSegementTypeDefaultOne,
    OCCSegementTypeDefaultTwo,
    OCCSegementTypeDefaultThree,
    OCCSegementTypeOther
};

@protocol OCCSegementDelegate <NSObject>

- (void)selectedSegementIndex:(NSInteger)index;

@end

@interface OCCSegement : UIView
{
    NSInteger  _selectedTag;
    UIColor   *_normalTitleColor;
    UIColor   *_selectedTitleColor;
    UIColor   *_normalBgColor;
    UIColor   *_selectedBgColor;
    NSArray   *_titleArr;
    UIImage   *_leftImage;
    UIImage   *_leftSelectedImage;
    UIImage   *_middleImage;
    UIImage   *_middleSelectedImage;
    UIImage   *_rightImage;
    UIImage   *_rightSelectedImage;
}

@property(nonatomic,assign)id<OCCSegementDelegate>delegate;

- (id)initWithFrame:(CGRect)frame type:(OCCSegementType)type andTitleArray:(NSArray *)titleArray;

- (void)changeSegementTitleWithIndex:(NSInteger)index andCount:(NSInteger)count;

- (void)selectItem:(int)index;
@end
