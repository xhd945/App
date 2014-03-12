//
//  PayActivityCell.m
//  occ
//
//  Created by RS on 13-8-31.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "PayActivityCell.h"

@implementation PayActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView=[CommonMethods lineWithWithType:OCCLineType3];
        [self.contentView addSubview:_lineImageView];
        
        _bargainLabel = [[UILabel alloc]init];
        [_bargainLabel setTextAlignment:NSTextAlignmentLeft];
        [_bargainLabel setTextColor:COLOR_999999];
        [_bargainLabel setBackgroundColor:[UIColor clearColor]];
        [_bargainLabel setNumberOfLines:0];
        [_bargainLabel setFont:FONT_12];
        [self.contentView addSubview:_bargainLabel];
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
    
    [_lineImageView setFrame:CGRectMake(10, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-20, 1)];
    
    if (self.bargainLabel.text==nil||[self.bargainLabel.text length]==0) {
        _lineImageView.hidden=YES;
    }
}

-(void)setData:(NSDictionary*)data
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSMutableArray *itemBargainList=[data objectForKey:@"bargainList"];
    for (int i=0; i<[itemBargainList count]; i++) {
        NSDictionary *item=[itemBargainList objectAtIndex:i];
        if ([[item objectForKey:@"name"] isKindOfClass:[NSString class]]){
            [arr addObject:[item objectForKey:@"name"]];
        }
    }
    [_bargainLabel setText:[arr componentsJoinedByString:@"\n"]];
}

@end
