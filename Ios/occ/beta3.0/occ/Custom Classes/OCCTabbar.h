//
//  OCCTabbar.h
//  occ
//
//  Created by zhangss on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCCTabbar;
@protocol OCCTabbarDelegate <NSObject>

- (void)tabbar:(OCCTabbar *)tabbar tapIndex:(NSInteger)index andType:(SortType)sortType;

@end

@interface OCCTabbar : UIView
{
    UIImage    *_sortUpImage;         //
    UIImage    *_sortDownImage;       //
    UIImageView *_uparrowImageView;   //选中标示小三角
    NSInteger   _searchTag;           //搜索Item的Tag
    NSInteger   _priceTag;           //价格Item的Tag
    NSInteger   _selectedTag;         //上次选中的ItemTag
    NSMutableDictionary *_sortTypeDic;//记录存储每个按钮的排序选择
    
    NSArray   *_titleArr;
    UIColor   *_normalTitleColor;
    UIColor   *_selectedTitleColor;
    UIImage   *_leftImage;
    UIImage   *_leftSelectedImage;
    UIImage   *_middleImage;
    UIImage   *_middleSelectedImage;
    UIImage   *_rightImage;
    UIImage   *_rightSelectedImage;
}
//UITableView
@property (nonatomic,assign)id<OCCTabbarDelegate> delegate;

//初始化方法 必须给定titleArr
- (id)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr;

@end
