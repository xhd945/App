//
//  GrouponHeadCell.h
//  occ
//
//  Created by plocc on 13-12-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

typedef NS_ENUM(NSInteger, GrouponStatusType)
{
    GrouponStatusTypeWill,//
    GrouponStatusTypeGoing,//
    GrouponStatusTypeOver,//
    GrouponStatusTypeSellOut,//
};

#import <UIKit/UIKit.h>

@interface GrouponHeadCell : UITableViewCell<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) UILabel *plPriceLabel;
@property(nonatomic,strong) OCCStrikeThroughLabel *listPriceLabel;
@property(nonatomic,strong) UILabel *discountLabel;
@property(nonatomic,strong) UILabel *numLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIButton *scoreButton;

@property(nonatomic,strong) NSDictionary *data;
@property(nonatomic,assign) long countDownTime;
@property(nonatomic,strong) NSTimer *myTimer;

-(void)setData:(NSDictionary*)data;

-(float)getCellHeight;
@end
