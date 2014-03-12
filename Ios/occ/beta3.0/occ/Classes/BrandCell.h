//
//  LeftBrandCell.h
//  occ
//
//  Created by RS on 13-8-8.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@interface BrandCell : UITableViewCell
@property (strong, nonatomic)  OCCButton *leftButton;
@property (strong, nonatomic)  OCCButton *rightButton;
@property (strong, nonatomic)  UIImageView *leftImageView;
@property (strong, nonatomic)  UIImageView *rightImageView;

@property (strong, nonatomic) Brand *data1;
@property (strong, nonatomic) Brand *data2;

- (IBAction)doAction:(id)sender;
-(void)setData1:(Brand *)data;
-(void)setData2:(Brand *)data;
@end
