//
//  GHNormalTableViewCell.m
//  RS_CRM_iPhone
//
//  Created by RS on 13-7-19.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GHNormalTableViewCell.h"

@implementation GHNormalTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(27.0, 0.0, self.contentView.bounds.size.width-27.0, self.contentView.bounds.size.height);
    self.textLabel.backgroundColor=[UIColor clearColor];
}
@end
