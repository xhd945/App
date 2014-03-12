//
//  OCCBarItem.h
//  occ
//
//  Created by zhangss on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCCBarItem : UIView
{
    UIImageView *_imageView;
    UILabel     *_nameLabel;
    UILabel     *_badgeLabel;
}

//Title的颜色存在默认值 需要时可以修改
@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *titleSelectedColor;

@property (nonatomic,strong)UIImage *normalImage;
@property (nonatomic,strong)UIImage *selectedImage;
@property (nonatomic,strong)NSString *title;

//设置选中状态
- (void)setSelected:(BOOL)isSelected;
//设置未读数
- (void)setUnReadCount:(NSInteger)count;

@end
