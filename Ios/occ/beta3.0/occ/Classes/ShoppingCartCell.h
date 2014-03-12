//
//  ShoppingCartCell.h
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@property (weak, nonatomic) IBOutlet UILabel *title3Label;
@property (weak, nonatomic) IBOutlet UILabel *title4Label;

-(void)setData:(NSDictionary*)data;
@end
