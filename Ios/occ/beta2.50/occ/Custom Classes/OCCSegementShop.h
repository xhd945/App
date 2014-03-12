//
//  OCCSegementShop.h
//  occ
//
//  Created by RS on 13-11-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OCCSegementShopDelegate <NSObject>

- (void)selectedSegementToSort:(NSInteger)index;

@end

@interface OCCSegementShop : UIView
{
    NSInteger  _selectedTag;
    UIColor   *_normalTitleColor;
    UIColor   *_selectedTitleColor;
    UIColor   *_normalBgColor;
    UIColor   *_selectedBgColor;
    NSArray   *_titleArray;
    UIImage   *_leftImage;
    UIImage   *_leftSelectedImage;
    UIImage   *_middleImage;
    UIImage   *_middleSelectedImage;
    UIImage   *_rightImage;
    UIImage   *_rightSelectedImage;
    
    UIImage    *_sortUpImage;        
    UIImage    *_sortDownImage;
    NSInteger   _priceTag;
    SortType _priceSortType;
}

@property(nonatomic,assign)id<OCCSegementShopDelegate>delegate;

- (void)changeSegementTitleWithIndex:(NSInteger)index andCount:(NSInteger)count;

- (void)selectItem:(int)index;

@end
