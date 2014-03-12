//
//  GoodsBaseCell.h
//  occ
//
//  Created by RS on 13-11-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPhotoBrowserDelegate;

@interface GoodsHeadCell : UITableViewCell<UIScrollViewDelegate,MJPhotoBrowserDelegate>
{
    int         tapIndex;
}
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) UILabel *plPriceLabel;
@property(nonatomic,strong) OCCStrikeThroughLabel *listPriceLabel;
@property(nonatomic,strong) UIButton *scoreButton;

@property(nonatomic,strong) NSMutableDictionary      *pathDictionary;

@property(nonatomic,strong) NSDictionary *shopData;

-(void)setData:(NSDictionary*)data;
@end
