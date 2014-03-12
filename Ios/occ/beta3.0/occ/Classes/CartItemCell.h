//
//  CartCell.h
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCellDelegate.h"
#import "OCCStrikeThroughLabel.h"

@interface CartItemCell : UITableViewCell
@property (assign, nonatomic) id<CartCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIButton *checkButton;
@property (strong, nonatomic) UIButton *checkImageView;
@property (strong, nonatomic) UIButton *favorateButton;
@property (strong, nonatomic) UIButton *plusButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *minusButton;
@property (strong, nonatomic) UIButton*countButton;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *typeImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) OCCStrikeThroughLabel *oldPriceLabel;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UILabel *bargainLabel;
@property (strong, nonatomic) UITextField *countTextfield;

@property (strong, nonatomic) NSMutableDictionary *data;
@property (assign, nonatomic) int shopId;
@property (assign, nonatomic) int cartId;

- (void)doFavorite:(id)sender;
- (void)doDelete:(id)sender;
- (void)doPlus:(id)sender;
- (void)doMinus:(id)sender;
- (void)doCheck:(id)sender;

-(void)setData:(NSMutableDictionary*)data;
@end

