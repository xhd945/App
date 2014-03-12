//
//  OCCSwitchCell.m
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCSwitchCell.h"

@implementation OCCSwitchCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
	
    self.clipsToBounds=YES;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
	_switcher = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_switcher];
	
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
	
	CGRect r = CGRectInset(self.bounds, 8, 8);
	_switcher.frame = r;
	
}
@end
