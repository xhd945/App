//
//  GoodsCell.h
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCStrikeThroughLabel.h"
#import "Goods.h"

typedef NS_ENUM(NSInteger, GoodsCellType)
{
    GoodsCellTypeDefault,
    GoodsCellTypeSelected,
    GoodsCellTypeOther
};

@protocol GoodsCellDelegate <NSObject>

@optional

- (void)goodsCellIsSelected:(BOOL)isSelected withId:(NSInteger)selectedId;

@end

@interface GoodsCell : UITableViewCell

@property (strong, nonatomic) UIButton *selectedButton;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *curPriceLabel;
@property (strong, nonatomic) OCCStrikeThroughLabel *oldPriceLabel;
@property (strong, nonatomic) UILabel *salesLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UIImageView *goodsTypeImageV;
@property (assign, nonatomic) id <GoodsCellDelegate> delegate;
@property (assign, nonatomic) NSInteger selectedId;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) GoodsCellType cellType;

- (id)initWithGoodsCellStyle:(GoodsCellType)type reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setDataForGoods:(Goods *)data;
-(void)setDataForGroupOn:(NSDictionary*)data;

@end
