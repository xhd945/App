//
//  OCCTabbar.m
//  occ
//
//  Created by zhangss on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCTabbar.h"

#define kBtnBaseTag 1000

@implementation OCCTabbar

- (id)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArr = [[NSArray alloc] initWithArray:titleArr];
        
        self.clipsToBounds=YES;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, HEADER_HEIGHT);

        UIImage *image = [UIImage imageNamed:@"bg_segment"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - image.size.width)/2, (self.frame.size.height - image.size.height)/2, image.size.width, image.size.height)];
        bgImageView.image = image;
        [self addSubview:bgImageView];
        
        NSInteger itemCount = [titleArr count];
        CGFloat itemWidth = self.frame.size.width / itemCount;
        _normalTitleColor = COLOR_666666;
        _selectedTitleColor = COLOR_000000;
        _sortUpImage = [UIImage imageNamed:@"reorder_up_press"];
        _sortDownImage = [UIImage imageNamed:@"reorder_down_press"];
        _sortTypeDic = [[NSMutableDictionary alloc] initWithCapacity:[titleArr count]];
        
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
        
        for (int i = 0; i < [titleArr count]; i++)
        {
            UIButton *buttonItem = [[UIButton alloc]init];
            [buttonItem setFrame:CGRectMake(itemWidth * i, 5,itemWidth, HEADER_HEIGHT - 10)];
            [buttonItem setBackgroundColor:[UIColor clearColor]];
            [buttonItem addTarget:self action:@selector(buttonItemPress:) forControlEvents:UIControlEventTouchUpInside];
            buttonItem.titleLabel.font = FONT_14;
            buttonItem.tag = kBtnBaseTag + i;
            [buttonItem setTitleColor:_normalTitleColor forState:UIControlStateNormal];

            NSString *titleStr = [titleArr objectAtIndex:i];
            [buttonItem setTitle:titleStr forState:UIControlStateNormal];
            
            if (i==3)
            {
                [buttonItem setImageEdgeInsets:UIEdgeInsetsMake(0,5,0,10)];
                [buttonItem setTitleEdgeInsets:UIEdgeInsetsMake(0,5,0,10)];
                [buttonItem setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
                _searchTag = buttonItem.tag;
                [_sortTypeDic setObject:[NSNumber numberWithInteger:SortTypeOther] forKey:[NSNumber numberWithInteger:buttonItem.tag]];
            }
            else if(i==2)
            {
                [buttonItem setImageEdgeInsets:UIEdgeInsetsMake(0,40,0,0)];
                [buttonItem setTitleEdgeInsets:UIEdgeInsetsMake(0,-20,0,0)];
                [buttonItem setImage:_sortDownImage forState:UIControlStateNormal];
                _priceTag = buttonItem.tag;
                [_sortTypeDic setObject:[NSNumber numberWithInteger:SortTypeDown] forKey:[NSNumber numberWithInteger:buttonItem.tag]];
            }
            else
            {
                [buttonItem setImageEdgeInsets:UIEdgeInsetsMake(0,40,0,0)];
                [buttonItem setTitleEdgeInsets:UIEdgeInsetsMake(0,-20,0,0)];
                [buttonItem setImage:_sortDownImage forState:UIControlStateNormal];
                [_sortTypeDic setObject:[NSNumber numberWithInteger:SortTypeDown] forKey:[NSNumber numberWithInteger:buttonItem.tag]];
            }
            [self addSubview:buttonItem];
            
            if (i < [titleArr count] - 1)
            {
                //分割线
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(buttonItem.frame.origin.x + buttonItem.frame.size.width - 1, buttonItem.frame.origin.y, 1, buttonItem.frame.size.height)];
                lineView.backgroundColor = COLOR_CBCBCB;
                [self addSubview:lineView];
            }
        }
        
        //默认选择
        [self buttonItemPress:[self viewWithTag:kBtnBaseTag]];
    }
    return self;
}

- (void)buttonItemPress:(id)sender
{
    UIButton *btnItem = (UIButton *)sender;
    NSInteger itemIndex = btnItem.tag - kBtnBaseTag;
    SortType selectedSortType = SortTypeOther;
    
    if (btnItem.tag == _selectedTag)
    {
        if (_selectedTag == _priceTag)
        {
            selectedSortType = [[_sortTypeDic objectForKey:[NSNumber numberWithInteger:btnItem.tag]] integerValue];
            //重复点击normal 改变UI
            if (selectedSortType == SortTypeUp)
            {
                selectedSortType = SortTypeDown;
            }
            else if (selectedSortType == SortTypeDown)
            {
                selectedSortType = SortTypeUp;
            }
            
            UIImage *itemImage = selectedSortType == SortTypeDown ? _sortDownImage : _sortUpImage;
            [btnItem setImage:itemImage forState:UIControlStateNormal];
            [_sortTypeDic setObject:[NSNumber numberWithInteger:selectedSortType] forKey:[NSNumber numberWithInteger:btnItem.tag]];
        }
        else
        {
            //UI无变化
            return;
        }
    }
    else if (btnItem.tag- kBtnBaseTag == [_titleArr count] - 1)
    {
       
    }
    else
    {
        _selectedTag = btnItem.tag;
        for (UIView *subView in self.subviews)
        {
            if ([subView isKindOfClass:[UIButton class]] &&(subView.tag - kBtnBaseTag) >= 0)
            {
                if (subView.tag - kBtnBaseTag == 0)
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
                else if (subView.tag - kBtnBaseTag == [_titleArr count] - 1)
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
        
        [_uparrowImageView setFrame:CGRectMake(btnItem.center.x,self.frame.size.height - 10,10, 10)];
        
        selectedSortType = [[_sortTypeDic objectForKey:[NSNumber numberWithInteger:btnItem.tag]] integerValue];
    }
    
    //代理返回 Intex及SortType
    if ([_delegate respondsToSelector:@selector(tabbar:tapIndex:andType:)])
    {
        [_delegate tabbar:self tapIndex:itemIndex andType:selectedSortType];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
