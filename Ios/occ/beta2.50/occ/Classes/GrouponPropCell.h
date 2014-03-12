//
//  GrouponItemCell.h
//  occ
//
//  Created by RS on 13-11-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrouponPropCellDelegate <NSObject>
- (void)grouponPropChange;
@end

@interface GrouponPropCell : UITableViewCell

@property(nonatomic,strong) UIButton *upDownButton;

@property(nonatomic,assign) id<GrouponPropCellDelegate>delegate;

@property(nonatomic,strong) UIImage *whiteImage;
@property(nonatomic,strong) UIImage *greenImage;
@property(nonatomic,strong) NSMutableArray* propCtrlList;//属性控件集合
@property(nonatomic,strong) NSMutableArray* selectedPropBtnList;//

@property(nonatomic,strong) NSMutableDictionary* data;
@property(nonatomic,assign) int minHeight;
@property(nonatomic,assign) int maxHeight;
@property(nonatomic,assign) int expand;

-(void)addItemToCart:(id)sender;
-(float)getCellHeight;

@end
