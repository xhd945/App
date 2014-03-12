//
//  OCCLabelCell.m
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCLabelCell.h"

@implementation OCCLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiantou_right.png"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    [self.textLabel setFont:FONT_14];
    [self.textLabel setTextColor:COLOR_333333];
    [self.textLabel setHighlightedTextColor:COLOR_333333];
    [self.detailTextLabel setFont:FONT_12];
    [self.detailTextLabel setTextColor:COLOR_999999];
    [self.detailTextLabel setHighlightedTextColor:COLOR_999999];
    
    if (self.accessoryType==UITableViewCellAccessoryNone)
    {
        self.accessoryView.hidden=YES;
    }
    else
    {
        self.accessoryView.hidden=NO;
    }
}

-(void)setData:(NSDictionary*)data
{
    [self.textLabel setText:[data objectForKey:@"name"]];
    [self.detailTextLabel setText:[data objectForKey:@"value"]];
}

@end
