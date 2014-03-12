//
//  ShopCell.h
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCRatingView.h"
#import "Shop.h"

typedef NS_ENUM(NSInteger, ShopCellType)
{
    ShopCellTypeDefault,
    ShopCellTypeSelected,
    ShopCellTypeOther
};

@protocol ShopCellDelegate <NSObject>

@optional

- (void)shopCellIsSelected:(BOOL)isSelected withId:(NSInteger)selectedId;

@end

@interface ShopCell : UITableViewCell

@property (strong, nonatomic) UIButton *selectedButton;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *favourLabel;
@property (strong, nonatomic) OCCRatingView *ratingView;
@property (strong, nonatomic) UIButton *scoreButton;
@property (assign, nonatomic) id <ShopCellDelegate> delegate;
@property (assign, nonatomic) NSInteger selectedId;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) ShopCellType cellType;

- (id)initWithGoodsCellStyle:(ShopCellType)type reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setDataForShop:(Shop *)data;

@end
