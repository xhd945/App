//
//  NavCell.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NavCell.h"

@implementation NavCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
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

-(void)setData:(NSDictionary*)data
{
    UIImage *leftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[data objectForKey:@"image"]]];
    [_leftImageView setImage:leftImage];
    [_leftImageView setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[data objectForKey:@"image_selected"]]]];
    
    [_rightImageView setImage:[UIImage imageNamed:@"next_nor.png"]];
        
    [_titleLabel setTextColor:COLOR_D1BEB0];
    [_titleLabel setHighlightedTextColor:COLOR_FBB714];
    [_titleLabel setFont:FONT_16];
    NSString *title=[data objectForKey:@"title"];
    [_titleLabel setText:title];
    
    CGRect selfRect = _leftImageView.frame;
    selfRect.origin = CGPointMake(15, (self.frame.size.height - leftImage.size.height)/2);
    selfRect.size = leftImage.size;
    _leftImageView.frame = selfRect;
    
    selfRect = _titleLabel.frame;
    selfRect.origin.x = _leftImageView.frame.origin.x + _leftImageView.frame.size.width + 10;
    _titleLabel.frame = selfRect;
    
    _numLabel.hidden=YES;
}

@end
