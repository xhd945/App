//
//  PayMessageCell.h
//  occ
//
//  Created by RS on 13-8-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMessageCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *lineImageView;
@property (strong, nonatomic)  SSTextView *textView;

@property (strong, nonatomic) NSMutableDictionary *data;

-(void)setData:(NSDictionary*)data;

@end
