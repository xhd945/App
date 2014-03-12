//
//  SearchSuggestCell.m
//  occ
//
//  Created by zhangss on 13-9-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "SearchSuggestCell.h"

#define kMaxLength 255

@implementation SearchSuggestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *rightImageView = [[UIImageView alloc]init];
        [rightImageView setFrame:CGRectZero];
        [rightImageView setImage:[UIImage imageNamed:@"next_nor.png"]];
        [rightImageView setHighlightedImage:[UIImage imageNamed:@"next_nor.png"]];
        rightImageView.clipsToBounds=YES;
        [self.contentView addSubview:rightImageView];
        _rightImageView=rightImageView;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor=[UIColor clearColor];
        _nameLabel.font=FONT_16;
        _nameLabel.textColor=COLOR_333333;
        [self.contentView addSubview:_nameLabel];

        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.backgroundColor=[UIColor clearColor];
        _typeLabel.font=FONT_16;
        _typeLabel.textColor=COLOR_DA6432;
        [self.contentView addSubview:_typeLabel];
        
        self.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassOne];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_rightImageView setFrame:CGRectMake(0,0, 11, 11)];
    [_rightImageView setCenter:CGPointMake(300, self.contentView.frame.size.height/2)];
    
    _typeLabel.center = CGPointMake(_typeLabel.center.x, self.contentView.bounds.size.height/2);
}

- (void)setText:(NSString *)text andTypeString:(NSString *)typeStr
{
    _nameLabel.text = text;
    [_nameLabel sizeToFit];
    
    CGRect selfRect = _nameLabel.frame;
    selfRect.origin = CGPointMake(10, (self.frame.size.height - selfRect.size.height)/2);
    if (selfRect.size.width > kMaxLength)
    {
        selfRect.size.width = kMaxLength;
    }
    _nameLabel.frame = selfRect;
    if (typeStr)
    {
        _typeLabel.text = typeStr;
        _rightImageView.hidden = NO;
    }
    else
    {
        _rightImageView.hidden = YES;
    }
    [_typeLabel sizeToFit];
    
    selfRect = _typeLabel.frame;
    selfRect.origin = CGPointMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width, _nameLabel.frame.origin.y);
    _typeLabel.frame = selfRect;
}

@end
