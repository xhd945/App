//
//  WhiteCell.m
//  occ
//
//  Created by RS on 13-8-27.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OneLineCell.h"

@implementation OneLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:_lineImageView];
        
        _rightImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:_rightImageView];
        
         _leftTextLabel=[[UILabel alloc]init];
         [_leftTextLabel setFont:FONT_14];
         [_leftTextLabel setTextColor:COLOR_333333];
         [_leftTextLabel setHighlightedTextColor:COLOR_333333];
        [_leftTextLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_leftTextLabel];
         
         _leftValueLabel=[[UILabel alloc]init];
         [_leftValueLabel setFont:FONT_12];
         [_leftValueLabel setTextColor:COLOR_999999];
         [_leftValueLabel setHighlightedTextColor:COLOR_999999];
        [_leftValueLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_leftValueLabel];
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
    
    switch (_lineStyle) {
        case OneLineCellLineTypeNone:
        {
            _lineImageView.hidden = YES;
        }
            break;
        case OneLineCellLineTypeLineDot:
        {
            _lineImageView.hidden = NO;
            [_lineImageView setImage:[UIImage imageNamed:@"line3"]];
            [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line3"]];
            [_lineImageView setFrame:CGRectMake(10, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-20, 1)];
        }
            break;
        case OneLineCellLineTypeLine1:
        {
            _lineImageView.hidden = NO;
            [_lineImageView setImage:[UIImage imageNamed:@"line2"]];
            [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line2"]];
            [_lineImageView setFrame:CGRectMake(0, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width, 1)];
        }
            break;
        default:
            break;
    }
    
    switch (_rightStyle) {
        case OneLineCellRightCheck:
        {
            _rightImageView.hidden = NO;
            [_rightImageView setImage:[UIImage imageNamed:@"next_nor.png"]];
            [_rightImageView setHighlightedImage:[UIImage imageNamed:@"next_nor.png"]];
        }
            break;
        case OneLineCellRightGou:
        {
            _rightImageView.hidden = NO;
            [_rightImageView setImage:[UIImage imageNamed:@"confirm.png"]];
            [_rightImageView setHighlightedImage:[UIImage imageNamed:@"confirm.png"]];
        }
            break;
        case OneLineCellRightNone:
        {
            _rightImageView.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    [_leftTextLabel setFrame:CGRectMake(15, 0, self.contentView.bounds.size.width, 44)];
    [_leftTextLabel setTextAlignment:NSTextAlignmentLeft];
    [_leftValueLabel setFrame:CGRectMake(15, 0, self.contentView.bounds.size.width-40, 44)];
    [_leftValueLabel setTextAlignment:NSTextAlignmentRight];

    [self.rightImageView sizeToFit];
    self.rightImageView.center=CGPointMake(self.contentView.frame.size.width - self.rightImageView.frame.size.width/2-15, 44/2);
}

- (void)setData:(NSDictionary*)data
{
    [_leftTextLabel setText:[data objectForKey:@"name"]];
    [_leftValueLabel setText:[data objectForKey:@"value"]];
}

@end
