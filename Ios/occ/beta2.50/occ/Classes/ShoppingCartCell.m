//
//  ShoppingCartCell.m
//  occ
//
//  Created by RS on 13-8-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ShoppingCartCell.h"

@implementation ShoppingCartCell

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

-(void)setData:(NSDictionary*)data
{
    [_leftImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shoppingcart_%@.png",[data objectForKey:@"image"]]]];
    
    [_title1Label setTextColor:COLOR_453D3A];
    [_title1Label setHighlightedTextColor:COLOR_453D3A];
    NSString *title1=[data objectForKey:@"title1"];
    [_title1Label setText:title1];
    
    [_title2Label setTextColor:COLOR_453D3A];
    [_title2Label setHighlightedTextColor:COLOR_453D3A];
    NSString *title2=[data objectForKey:@"title2"];
    [_title2Label setText:title2];
    
    [_title3Label setTextColor:COLOR_453D3A];
    [_title3Label setHighlightedTextColor:COLOR_453D3A];
    NSString *title3=[data objectForKey:@"title3"];
    [_title3Label setText:title3];
    
    [_title4Label setTextColor:COLOR_453D3A];
    [_title4Label setHighlightedTextColor:COLOR_453D3A];
    NSString *title4=[data objectForKey:@"title4"];
    [_title4Label setText:title4];
}

@end
