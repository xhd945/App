//
//  ShopInfoHeadView.h
//  occ
//
//  Created by zhangss on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCRatingView.h"
#import "OCCAttributedLabel.h"
#import "Shop.h"

@interface ShopInfoHeadView : UIView
{
    UIImageView *_headImageView;
    UILabel  *_nameLabel;
    UILabel  *_shopType;
    UIButton *_chatButton;
    UIButton *_favoriteBtn;
    UIButton *_locateButton;
    OCCAttributedLabel *_favoriteLabel;
    UIButton *_scoreButton;
    Shop    *_shopData;
}

- (void)setDataForShopHeader:(Shop *)data;

@end
