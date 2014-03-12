//
//  OCCSegementShop.m
//  occ
//
//  Created by RS on 13-11-21.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#define kSegementHeight 30
#define kSegementBaseTag 10000

#import "OCCSegementShop.h"

@implementation OCCSegementShop

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _normalTitleColor = COLOR_666666;
        _selectedTitleColor = COLOR_000000;
        UIImage *leftImage = [UIImage imageNamed:@"segement_left_normal"];
        UIImage *leftSelectedImage = [UIImage imageNamed:@"segement_left_selected"];
        UIImage *middleImage = [UIImage imageNamed:@"segement_middle_normal"];
        UIImage *middleSelectedImage = [UIImage imageNamed:@"segement_middle_selected"];
        UIImage *rightImage = [UIImage imageNamed:@"segement_right_normal"];
        UIImage *rightSelectedImage = [UIImage imageNamed:@"segement_right_selected"];
        
        _sortUpImage = [UIImage imageNamed:@"reorder_up_press"];
        _sortDownImage = [UIImage imageNamed:@"reorder_down_press"];
        
        _leftImage = [leftImage stretchableImageWithLeftCapWidth:leftImage.size.width - 1 topCapHeight:leftImage.size.height / 2];
        _leftSelectedImage = [leftSelectedImage stretchableImageWithLeftCapWidth:leftSelectedImage.size.width - 1 topCapHeight:leftSelectedImage.size.height / 2];
        _middleImage = [middleImage stretchableImageWithLeftCapWidth:middleImage.size.width / 2 topCapHeight:middleImage.size.height / 2];
        _middleSelectedImage = [middleSelectedImage stretchableImageWithLeftCapWidth:leftImage.size.width / 2 topCapHeight:leftImage.size.height / 2];
        _rightImage = [rightImage stretchableImageWithLeftCapWidth:1 topCapHeight:leftImage.size.height / 2];
        _rightSelectedImage = [rightSelectedImage stretchableImageWithLeftCapWidth:1 topCapHeight:leftImage.size.height / 2];

        NSArray *titleArray=[NSArray arrayWithObjects:@"新品",@"销量",@"价格",@"收藏人数",nil];
        _titleArray=titleArray;
        
        [self setClipsToBounds:YES];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderColor = COLOR_CBCBCB.CGColor;
        self.layer.borderWidth = 0.5;
        
        CGFloat itemWidth = frame.size.width / [titleArray count];
        
        for (int i=0; i<[titleArray count]; i++)
        {
            UIButton *itemBtn = [[UIButton alloc]init];
            [itemBtn setFrame:CGRectMake(itemWidth * i, 0, itemWidth, kSegementHeight)];
            [itemBtn addTarget:self action:@selector(itemTap:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.titleLabel.font = FONT_14;
            itemBtn.tag = kSegementBaseTag + i;
            [itemBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [self addSubview:itemBtn];
            
            if (i==2)
            {
                [itemBtn setImageEdgeInsets:UIEdgeInsetsMake(0,40,0,0)];
                [itemBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-20,0,0)];
                [itemBtn setImage:_sortDownImage forState:UIControlStateNormal];
                _priceSortType=SortTypeDown;
                _priceTag = itemBtn.tag;
            }
            
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)itemTap:(id)sender
{
    UIButton *btnItem = (UIButton *)sender;
    NSInteger itemIndex = btnItem.tag - kSegementBaseTag;

    if (btnItem.tag == _selectedTag)
    {
        if (_selectedTag == _priceTag)
        {
            if (_priceSortType == SortTypeUp)
            {
                _priceSortType = SortTypeDown;
            }
            else if (_priceSortType == SortTypeDown)
            {
                _priceSortType = SortTypeUp;
            }
            
            UIImage *itemImage = (_priceSortType==SortTypeDown?_sortDownImage:_sortUpImage);
            [btnItem setImage:itemImage forState:UIControlStateNormal];
        }
        else
        {
            return;
        }
    }
    
    _selectedTag = btnItem.tag;
    
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]] && (subView.tag - kSegementBaseTag) >= 0)
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
                else if (subView.tag - kSegementBaseTag == [_titleArray count] - 1)
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
    
    // 0:新品；1：销量；2：人气；3：价格降序；4：价格升序；
    if ([_delegate respondsToSelector:@selector(selectedSegementToSort:)])
    {
        switch (itemIndex)
        {
            case 0:
                [_delegate selectedSegementToSort:0];
                break;
            case 1:
                [_delegate selectedSegementToSort:1];
                break;
            case 2:
                if (_priceSortType == SortTypeUp)
                {
                    [_delegate selectedSegementToSort:4];
                }
                else if (_priceSortType == SortTypeDown)
                {
                    [_delegate selectedSegementToSort:3];
                }
                break;
            case 3:
                [_delegate selectedSegementToSort:2];
                break;
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Change Title
- (void)changeSegementTitleWithIndex:(NSInteger)index andCount:(NSInteger)count
{
    if (count > 0)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:kSegementBaseTag + index];
        [btn setTitle:[NSString stringWithFormat:@"%@(%d)",[_titleArray objectAtIndex:index],count] forState:UIControlStateNormal];
    }
    else
    {
        UIButton *btn = (UIButton *)[self viewWithTag:kSegementBaseTag + index];
        [btn setTitle:[NSString stringWithFormat:@"%@",[_titleArray objectAtIndex:index]] forState:UIControlStateNormal];
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
