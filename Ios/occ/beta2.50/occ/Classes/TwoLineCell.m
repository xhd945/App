//
//  TwoLineCell.m
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "TwoLineCell.h"

@implementation TwoLineCell

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
    
    [_lineImageView setFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 2)];
    [_lineImageView setImage:[UIImage imageNamed:@"line2.png"]];
    [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line2.png"]];
    _lineImageView.hidden=YES;
    
    switch (_rightStyle) {
        case TwoLineCellRightCheck:
        {
            _rightImageView.hidden = NO;
            [_rightImageView setImage:[UIImage imageNamed:@"next_nor.png"]];
            [_rightImageView setHighlightedImage:[UIImage imageNamed:@"next_nor.png"]];
        }
            break;
        case TwoLineCellRightGou:
        {
            _rightImageView.hidden = NO;
            [_rightImageView setImage:[UIImage imageNamed:@"confirm.png"]];
            [_rightImageView setHighlightedImage:[UIImage imageNamed:@"confirm.png"]];
        }
            break;
        case TwoLineCellRightNone:
        {
            _rightImageView.hidden = YES;
        }
            break;
        default:
            break;
    }

    
    [self.rightImageView sizeToFit];
    CGRect selfRect = self.rightImageView.frame;
    selfRect.origin = CGPointMake(self.frame.size.width - 10*3 - selfRect.size.width, (self.frame.size.height - selfRect.size.height) / 2);
    self.rightImageView.frame = selfRect;
}

-(void)setData:(NSDictionary*)data
{
    NSString *title = nil;
    id obj = [data objectForKey:@"name"];
    if ([obj isKindOfClass:[NSString class]])
    {
        title = obj;
    }
    else if ([obj isKindOfClass:[NSNumber class]])
    {
        title = [(NSNumber *)obj stringValue];
    }
    [_titleLabel setText:title];
    [_titleLabel setTextColor:COLOR_333333];
    [_titleLabel setHighlightedTextColor:COLOR_333333];
    
    NSString *detail=[data objectForKey:@"value"];
    [_detailLabel setText:detail];
    [_detailLabel setTextColor:COLOR_999999];
    [_detailLabel setHighlightedTextColor:COLOR_999999];
    
}

@end
