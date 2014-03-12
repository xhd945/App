//
//  ROllLabel.h
//  RollLabel
//
//  Created by zhouxl on 12-11-2.
//  Copyright (c) 2012年 zhouxl. All rights reserved.
//


#import <UIKit/UIKit.h>
#define kConstrainedSize CGSizeMake(10000,40)//字体最大

@interface ROllLabel : UIScrollView
{
    NSUInteger space;
    CGRect frame1;
    CGRect frame2;
    CGRect RollFrame;
}

//rollLabelTitle方式中的两个label及他们的frame
@property (nonatomic,retain) UILabel *label1;
@property (nonatomic,retain) UILabel *label2;
@property (nonatomic,assign) CGRect frame1;
@property (nonatomic,assign) CGRect frame2;
//两个label中间的距离
@property (nonatomic,assign) NSUInteger space;

//RollLabel的frame
@property (nonatomic,assign) CGRect RollFrame;


@property (nonatomic,assign) NSTimer *timer;

//label每滑动一次的时间
@property (nonatomic,assign) float timeInterval;

//调用的是哪种滚动方法
@property (nonatomic,assign) NSUInteger mode;

//设置滚动时的动画效果
@property (nonatomic,assign) UIViewAnimationOptions animationOption;

/*title,要显示的文字
 *color,文字颜色
 *font , 字体大小
 *superView,要加载标签的视图
 *rect ,标签的frame
 *tempspace,先后的文字间的间隔
 */

- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgcolor;

//文字相继出现
- (void)rollLabelTitle:(NSString *)title textcolor:(UIColor *)color font:(UIFont *)font middleSpace:(NSUInteger) tempspace;

//滚动式文字只出现一次
- (void)rollOnlyOneTitle:(NSString *)title textcolor:(UIColor *)color font:(UIFont *)font;

//暂停已添加在页面中滚动的label
-(void)pause;

//恢复已添加在页面中label的滚动
-(void)reStart;


@end
