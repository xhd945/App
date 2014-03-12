//
//  ShopCell.m
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ShopCell.h"

#define kSelectViewWidth 40.0
#define kImageWidth 70.0

@implementation ShopCell

- (id)initWithGoodsCellStyle:(ShopCellType)type reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassOne];
        _cellType = type;
        
        CGFloat pointX = 0.0;
        CGFloat pointY = 10.0;
        if (type == ShopCellTypeSelected)
        {
            [self initSelectedView];
            pointX += kSelectViewWidth;
        }
        else
        {
            pointX += 10.0;
        }
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(pointX, pointY - 3, kImageWidth + 6, kImageWidth + 6)];
        whiteView.layer.cornerRadius = 5.0;
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.borderWidth = 1.0;
        whiteView.layer.borderColor = COLOR_CBCBCB.CGColor;
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pointX+3, pointY, kImageWidth, kImageWidth)];
        _leftImageView.backgroundColor = [UIColor clearColor];
        _leftImageView.layer.cornerRadius = 5.0;
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_leftImageView];
        pointX += _leftImageView.frame.size.width + 15;
        pointY += 2;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY-3, self.frame.size.width - pointX - 50, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT_14;
        _titleLabel.textColor = COLOR_333333;
        [self.contentView addSubview:_titleLabel];
        pointY += _titleLabel.frame.size.height + 2;
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, pointY, self.frame.size.width - pointX - 45, 15)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = FONT_12;
        _detailLabel.textColor = COLOR_999999;
        [self.contentView addSubview:_detailLabel];
        _detailLabel.numberOfLines=2;
        pointY += _detailLabel.frame.size.height + 2;
        
        _ratingView = [[OCCRatingView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, pointY, 10, 10)];
        self.ratingView.userInteractionEnabled = NO;
        //[self.contentView addSubview:_ratingView];
        pointY += _ratingView.frame.size.height + 2;
        
        _scoreButton = [[UIButton alloc]init];
        [_scoreButton setFrame:CGRectMake(270, _leftImageView.frame.origin.y, 30, 30)];
        [_scoreButton setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [_scoreButton setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateHighlighted];
        [_scoreButton.titleLabel setFont:FONT_12];
        [_scoreButton setTitleEdgeInsets:UIEdgeInsetsMake(1,0,0,0)];
        [_scoreButton setUserInteractionEnabled:NO];
        [self.contentView addSubview:_scoreButton];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, pointY, 50, 20)];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.font = FONT_12;
        _typeLabel.textColor = COLOR_666666;
        [self.contentView addSubview:_typeLabel];
        pointX += _typeLabel.frame.size.width + 5;
        
        _favourLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, 50, 20)];
        _favourLabel.backgroundColor = [UIColor clearColor];
        _favourLabel.font = FONT_12;
        _favourLabel.textColor = COLOR_999999;
        //[self.contentView addSubview:_favourLabel];
                
        if (type == ShopCellTypeDefault)
        {
            [_titleLabel setHighlightedTextColor:COLOR_FFFFFF];
            [_detailLabel setHighlightedTextColor:COLOR_FFFFFF];
            [_typeLabel setHighlightedTextColor:COLOR_FFFFFF];
            [_favourLabel setHighlightedTextColor:COLOR_FFFFFF];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect selfRect = _selectedButton.frame;
    selfRect.size = CGSizeMake(kSelectViewWidth, self.frame.size.height);
    _selectedButton.frame = selfRect;
}

- (void)initSelectedView
{
    //选择View
    UIImage *image = [UIImage imageNamed:@"checkbox_nor"];
    _selectedButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [_selectedButton addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedButton setImage:image forState:UIControlStateNormal];
    [self.contentView addSubview:_selectedButton];
}

- (void)cellSelected:(UIGestureRecognizer *)gesture
{
    UIImage *selectedImage = [UIImage imageNamed:@"checkbox_press"];
    UIImage *image = [UIImage imageNamed:@"checkbox_nor"];
    _isSelected = !_isSelected;
    if (_isSelected)
    {
        [_selectedButton setImage:selectedImage forState:UIControlStateNormal];
    }
    else
    {
        [_selectedButton setImage:image forState:UIControlStateNormal];
    }
    
    if ([_delegate respondsToSelector:@selector(shopCellIsSelected:withId:)])
    {
        [_delegate shopCellIsSelected:_isSelected withId:_selectedId];
    }
}

-(void)setDataForFavorite:(NSDictionary*)data
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [data objectForKey:@"image"],@"logo",
                         [data objectForKey:@"shopName"],@"shopName",
                         [data objectForKey:@"brief"],@"brief",
                         [data objectForKey:@"classification"],@"classification",
                         [data objectForKey:@"id"],KEY_FAVOURID,
                         [data objectForKey:@"favourNum"],@"favour",
                         nil];
    [self setDataForShop:dic];
}

-(void)setDataForShop:(Shop *)data
{
    if (_cellType == ShopCellTypeSelected)
    {
        _selectedId = [data.shopFavourID integerValue];
        [_selectedButton setImage:[UIImage imageNamed:@"checkbox_nor"] forState:UIControlStateNormal];
    }
    //商铺Logo
    NSString *strURL = [data.shopImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.leftImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    NSString *title = data.shopName;
    [self.titleLabel setText:title];
    [self.titleLabel sizeToFit];

    NSString *detail = data.shopBrief;
    [self.detailLabel setText:detail];
    [self.detailLabel sizeToFit];

    [self.ratingView setRating:data.shopRating];
    [_scoreButton setTitle:[NSString stringWithFormat:@"%.1f",[data.shopRating floatValue]] forState:UIControlStateNormal];
    
    NSString *type = data.shopType;
    [self.typeLabel setText:type];
    [self.typeLabel sizeToFit];
    
    NSString *favour = [NSString stringWithFormat:@"%d 人浏览",[data.shopViewNum intValue]];
    [self.favourLabel setText:favour];
    [self.favourLabel sizeToFit];
    
    CGRect selfRect = self.favourLabel.frame;
    selfRect.origin.x = self.typeLabel.frame.origin.x + self.typeLabel.frame.size.width + 20;
    self.favourLabel.frame = selfRect;
}

@end
