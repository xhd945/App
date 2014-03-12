//
//  FloorCell.m
//  occ
//
//  Created by RS on 13-8-19.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "FloorCell.h"
#import "CommonMethods.h"

@implementation FloorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.selectedBackgroundView = [CommonMethods selectedCellBGViewWithType:OCCCellSelectedBGTypeClassTwo];
        
        [self.contentView addSubview:[CommonMethods cellNaviLineWithSuperFrame:self.frame]];
        
        UIImage *floorImage = [UIImage imageNamed:@"floor"];
        _floorImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, (44 - floorImage.size.width)/2, floorImage.size.width, floorImage.size.height)];
        _floorImage.image = floorImage;
        _floorImage.highlightedImage = [UIImage imageNamed:@"floor_selected"];
        [self.contentView addSubview:_floorImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, _floorImage.frame.size.width, _floorImage.frame.size.height)];
        [_titleLabel setTextColor:COLOR_74665B];
        [_titleLabel setHighlightedTextColor:COLOR_74665B];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT_12;
        [_floorImage addSubview:_titleLabel];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(_floorImage.frame.origin.x + _floorImage.frame.size.width + 10, 0, LEFTVIEW_WIDTH - (_floorImage.frame.origin.x + _floorImage.frame.size.width + 10), 44)];
        [_descLabel setTextColor:COLOR_D1BEB0];
        [_descLabel setHighlightedTextColor:COLOR_FBB714];
        _descLabel.font = FONT_16;
        _descLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_descLabel];
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
    NSString *text = data.naviName;
    [_titleLabel setText:[text substringWithRange:NSMakeRange(0, 2)]];
    [_descLabel setText:[text substringFromIndex:3]];
}

@end
