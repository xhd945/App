//
//  GrouponNoticeCell.m
//  occ
//
//  Created by RS on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponNoticeCell.h"

@implementation GrouponNoticeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT_14;
        _titleLabel.textColor = COLOR_333333;
        _titleLabel.highlightedTextColor = COLOR_333333;
        [_titleLabel setNumberOfLines:0];
        _titleLabel.text=@"购买须知";
        [self.contentView addSubview:_titleLabel];
        
        _notifyLabel = [[UILabel alloc]init];
        _notifyLabel.backgroundColor = [UIColor clearColor];
        _notifyLabel.font = FONT_12;
        _notifyLabel.textColor = COLOR_999999;
        _notifyLabel.highlightedTextColor = COLOR_999999;
        [_notifyLabel setNumberOfLines:0];
        [self.contentView addSubview:_notifyLabel];
        
        UIImage *image=[UIImage imageNamed:@"list_bgremind_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:image];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        
        [self setBackgroundView:backgroundView];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
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
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    [_titleLabel setFrame:CGRectMake(10,10,kBargainLabelWidth, 20)];
    int height=[CommonMethods heightForString:_notifyLabel.text andFont:_notifyLabel.font andWidth:280];
    [_notifyLabel setFrame:CGRectMake(10,40,280, height)];
    [_notifyLabel sizeToFit];
}

-(void)setData:(NSDictionary*)data
{
    [_notifyLabel setText:[data objectForKey:@"buyNotify"]];
    self.height=[CommonMethods heightForString:[data objectForKey:@"buyNotify"] andFont:FONT_12 andWidth:280];
}

-(float)getCellHeight
{
    return self.height+50;
}

@end
