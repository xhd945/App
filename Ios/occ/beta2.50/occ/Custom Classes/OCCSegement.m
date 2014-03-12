//
//  OCCSegement.m
//  occ
//
//  Created by zhangss on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCSegement.h"

#define kSegementHeight 30
#define kSegementBaseTag 10000

@implementation OCCSegement

- (id)initWithFrame:(CGRect)frame type:(OCCSegementType)type andTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setFrame:frame];
        _titleArr = [[NSArray alloc] initWithArray:titleArray];
        
        switch (type)
        {
            case OCCSegementTypeDefaultOne:
            {
                _normalTitleColor = [UIColor blackColor];
                _normalBgColor = COLOR_FFFFFF;
                _selectedTitleColor = COLOR_FFFFFF;
                _selectedBgColor = COLOR_2A7F3C;
                break;
            }
            case OCCSegementTypeDefaultTwo:
            {
                _normalTitleColor = [UIColor blackColor];
                _normalBgColor = COLOR_FFFFFF;
                _selectedTitleColor = COLOR_FFFFFF;
                _selectedBgColor = COLOR_AA6506;
                break;
            }
            case OCCSegementTypeDefaultThree:
            {
                _normalTitleColor = COLOR_666666;
                _selectedTitleColor = COLOR_000000;
                UIImage *leftImage = [UIImage imageNamed:@"segement_left_normal"];
                UIImage *leftSelectedImage = [UIImage imageNamed:@"segement_left_selected"];
                UIImage *middleImage = [UIImage imageNamed:@"segement_middle_normal"];
                UIImage *middleSelectedImage = [UIImage imageNamed:@"segement_middle_selected"];
                UIImage *rightImage = [UIImage imageNamed:@"segement_right_normal"];
                UIImage *rightSelectedImage = [UIImage imageNamed:@"segement_right_selected"];

                _leftImage = [leftImage stretchableImageWithLeftCapWidth:leftImage.size.width - 1 topCapHeight:leftImage.size.height / 2];
                _leftSelectedImage = [leftSelectedImage stretchableImageWithLeftCapWidth:leftSelectedImage.size.width - 1 topCapHeight:leftSelectedImage.size.height / 2];
                _middleImage = [middleImage stretchableImageWithLeftCapWidth:middleImage.size.width / 2 topCapHeight:middleImage.size.height / 2];
                _middleSelectedImage = [middleSelectedImage stretchableImageWithLeftCapWidth:leftImage.size.width / 2 topCapHeight:leftImage.size.height / 2];
                _rightImage = [rightImage stretchableImageWithLeftCapWidth:1 topCapHeight:leftImage.size.height / 2];
                _rightSelectedImage = [rightSelectedImage stretchableImageWithLeftCapWidth:1 topCapHeight:leftImage.size.height / 2];
                break;
            }
            default:
                break;
        }
        
        [self setClipsToBounds:YES];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderColor = COLOR_CBCBCB.CGColor;
        self.layer.borderWidth = 0.5;
        
        CGFloat itemWidth = frame.size.width / [titleArray count];
        
        for (NSInteger i = 0; i < [titleArray count]; i++)
        {
            UIButton *itemBtn = [[UIButton alloc]init];
            [itemBtn setFrame:CGRectMake(itemWidth * i, 0, itemWidth, kSegementHeight)];
            [itemBtn addTarget:self action:@selector(itemTap:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.titleLabel.font = FONT_14;
            itemBtn.tag = kSegementBaseTag + i;
            [itemBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [self addSubview:itemBtn];
            
            if (i < [titleArray count] - 1)
            {
                //分割线
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(itemBtn.frame.origin.x + itemBtn.frame.size.width - 1, 0, 1, itemBtn.frame.size.height)];
                lineView.backgroundColor = COLOR_CBCBCB;
                [self addSubview:lineView];
            }
        }
        
        [self itemTap:[self viewWithTag:kSegementBaseTag]];
    }
    return self;
}

- (void)itemTap:(id)sender
{
    UIButton *btnItem = (UIButton *)sender;
    
    if (btnItem.tag == _selectedTag)
    {
        //点击相同项
        return;
    }
    
    _selectedTag = btnItem.tag;
    
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]] &&
            (subView.tag - kSegementBaseTag) >= 0)
        {
            if (_normalBgColor)
            {
                if (subView.tag != btnItem.tag)
                {
                    [(UIButton *)subView setTitleColor:_normalTitleColor forState:UIControlStateNormal];
                    [(UIButton *)subView setBackgroundColor:_normalBgColor];
                }
                else
                {
                    [(UIButton *)subView setTitleColor:_selectedTitleColor forState:UIControlStateNormal];
                    [(UIButton *)subView setBackgroundColor:_selectedBgColor];
                }
            }
            else
            {
                if (subView.tag - kSegementBaseTag == 0)
                {
                    //左边
                    if (subView.tag != btnItem.tag)
                    {
                        [(UIButton *)subView setTitleColor:_normalTitleColor forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_leftImage forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_leftImage forState:UIControlStateHighlighted];

                    }
                    else
                    {
                        [(UIButton *)subView setTitleColor:_selectedTitleColor forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_leftSelectedImage forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_leftSelectedImage forState:UIControlStateHighlighted];

                    }
                }
                else if (subView.tag - kSegementBaseTag == [_titleArr count] - 1)
                {
                    //右边
                    if (subView.tag != btnItem.tag)
                    {
                        [(UIButton *)subView setTitleColor:_normalTitleColor forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_rightImage forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_rightImage forState:UIControlStateHighlighted];
                    }
                    else
                    {
                        [(UIButton *)subView setTitleColor:_selectedTitleColor forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_rightSelectedImage forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_rightSelectedImage forState:UIControlStateHighlighted];
                    }
                }
                else
                {
                    //中间
                    if (subView.tag != btnItem.tag)
                    {
                        [(UIButton *)subView setTitleColor:_normalTitleColor forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_middleImage forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_middleImage forState:UIControlStateHighlighted];
                    }
                    else
                    {
                        [(UIButton *)subView setTitleColor:_selectedTitleColor forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_middleSelectedImage forState:UIControlStateNormal];
                        [(UIButton *)subView setBackgroundImage:_middleSelectedImage forState:UIControlStateHighlighted];
                    }
                }
            }
        }
    }
    
    //代理返回 Intex
    NSInteger itemIndex = btnItem.tag - kSegementBaseTag;
    if ([_delegate respondsToSelector:@selector(selectedSegementIndex:)])
    {
        [_delegate selectedSegementIndex:itemIndex];
    }

}

#pragma mark -
#pragma mark Change Title
- (void)changeSegementTitleWithIndex:(NSInteger)index andCount:(NSInteger)count
{
    if (count > 0)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:kSegementBaseTag + index];
        [btn setTitle:[NSString stringWithFormat:@"%@(%d)",[_titleArr objectAtIndex:index],count] forState:UIControlStateNormal];
    }else{
        UIButton *btn = (UIButton *)[self viewWithTag:kSegementBaseTag + index];
        [btn setTitle:[NSString stringWithFormat:@"%@",[_titleArr objectAtIndex:index]] forState:UIControlStateNormal];
    }
}

- (void)selectItem:(int)index
{
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]] &&(subView.tag - kSegementBaseTag) == index)
        {
            UIButton *btn=(UIButton *)subView;
            [self itemTap:btn];
            return;
        }
    }
}

@end
