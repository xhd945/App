//
//  NavItemCell.m
//  occ
//
//  Created by RS on 13-8-19.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NavItemCell.h"
#import "OCCDefine.h"

@implementation NavItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassTwo];
        
        [self.contentView addSubview:[CommonMethods cellNaviLineWithSuperFrame:self.frame]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NaviData *)data
{
    [_rightImageView setImage:[UIImage imageNamed:@"next_nor.png"]];
    if ([data.naviIsParent integerValue] == 0)
    {
        [_rightImageView setHidden:NO];
    }
    else
    {
        [_rightImageView setHidden:YES];
    }
    
    [_titleLabel setTextColor:COLOR_D1BEB0];
    [_titleLabel setHighlightedTextColor:COLOR_FBB714];
    [_titleLabel setFont:FONT_16];
    NSString *title = data.naviName;
    [_titleLabel setText:title];
    
    [_numLabel setTextColor:COLOR_D1BEB0];
    [_numLabel setHighlightedTextColor:COLOR_FBB714];
    int count=[data.naviCout intValue];
    if (count < 0)
    {
        [_numLabel setText:@""];
    }
    else
    {
        NSString *num=[NSString stringWithFormat:@"%d",count];
        [_numLabel setText:num];
    }
    [_numLabel sizeToFit];
    
    CGRect selfRect = [_rightImageView frame];
    selfRect.origin.x = LEFTVIEW_WIDTH - selfRect.size.width - 28;
    _rightImageView.frame = selfRect;
    
    selfRect = _numLabel.frame;
    selfRect.origin.x = _rightImageView.frame.origin.x - selfRect.size.width - 10;
    _numLabel.frame = selfRect;
    
    selfRect = _titleLabel.frame;
    selfRect.origin.x = 15;
    selfRect.size.width = _numLabel.frame.origin.x - selfRect.origin.x;
    _titleLabel.frame = selfRect;
}
@end
