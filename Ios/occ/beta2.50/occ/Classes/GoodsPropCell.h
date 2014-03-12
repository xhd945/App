//
//  GoodsPropCell.h
//  occ
//
//  Created by RS on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsPropCellDelegate <NSObject>
- (void)updownChange;
- (void)itemChange:(long)itemId;
@end

@interface GoodsPropCell : UITableViewCell
{
    UILabel *_propLabel;
    UILabel *_prop1NameLabel;
    UILabel *_prop2NameLabel;
    UIView *_outView;
    NSMutableArray *_propBtnList1;
    NSMutableArray *_propBtnList2;
    UIButton *_plusButton;
    UIButton *_numButton;
    UIButton *_minusButton;
    UILabel *_stockLabel;
    UIButton *_favoriteButton;
    UIButton *_cartButton;
    UIButton *_upDownButton;
    UIImageView *_upDownImageView;
    UILabel *_lineLabel;
}

@property(nonatomic,assign) id<GoodsPropCellDelegate>delegate;
@property(nonatomic,strong) NSMutableDictionary* data;
@property(nonatomic,assign) int minHeight;
@property(nonatomic,assign) int maxHeight;
@property(nonatomic,assign) int buyNum;

@property(nonatomic,assign) int expand;
@property(nonatomic,assign) int x;
@property(nonatomic,assign) int y;

- (void)addItemToCart:(id)sender;
- (void)addItemToFavorite:(id)sender;
- (void)setData:(NSDictionary*)data;
- (float)getCellHeight;
- (long)getItemId;

@end
