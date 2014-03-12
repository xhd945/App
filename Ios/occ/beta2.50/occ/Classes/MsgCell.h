//
//  MsgCell.h
//  occ
//
//  Created by RS on 13-9-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MsgFormatType)
{
    MsgFormatType1,//时间+头像+竖线头
    MsgFormatType2,//时间+头像
    MsgFormatType3,//头像+竖线头
    MsgFormatType4,//头像
    MsgFormatType5,//竖线中
    MsgFormatType6,//竖线尾
};

@interface MsgCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *timeImageView;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UIImageView *headImageView;
@property (strong, nonatomic)  UIImageView *dotImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UIImageView *bgImageView;
@property (strong, nonatomic)  UIImage *leftImage;
@property (strong, nonatomic)  UIImage *rightImage;

@property (strong, nonatomic)  UIImage *leftDotImage;
@property (strong, nonatomic)  UIImage *rightDotImage;

@property (assign, nonatomic) MsgFormatType type;

-(void)setData:(NSDictionary*)data;

+(float)getCellHeight:(NSDictionary*)data andType:(MsgFormatType)type;

@end
