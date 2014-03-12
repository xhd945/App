//
//  Address3Cell.m
//  occ
//
//  Created by RS on 13-8-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCFieldCell.h"

@implementation OCCFieldCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.clipsToBounds=YES;
    
    [self setBackgroundColor:[UIColor clearColor]];
	
	_field = [[UITextField alloc] initWithFrame:CGRectZero];
    _field.font = FONT_14;
	_field.backgroundColor = [UIColor clearColor];
    _field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  
	[self.contentView addSubview:_field];
    
    _lineImageView=[[UIImageView alloc]init];
    [_lineImageView setFrame:CGRectZero];
    [_lineImageView setImage:[UIImage imageNamed:@"line_dotted.png"]];
    [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line_dotted.png"]];
    [self.contentView addSubview:_lineImageView];
    
    return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
	[_lineImageView setFrame:CGRectMake(0, self.contentView.bounds.size.height-2, self.contentView.bounds.size.width, 2)];
    [_field setFrame:CGRectInset(self.contentView.bounds, 8, 8)];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	//_field.textColor = selected ? [UIColor blackColor] : [UIColor blackColor];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	//_field.textColor = highlighted ? [UIColor blackColor] : [UIColor blackColor];
}


@end
