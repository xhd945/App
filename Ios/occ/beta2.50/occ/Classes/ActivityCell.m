//
//  ActivityCell.m
//  occ
//
//  Created by RS on 13-8-14.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ActivityCell.h"
@implementation ActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _whiteView = [[UIView alloc]init];
        [_whiteView setBackgroundColor:COLOR_FFFFFF];
        _whiteView.layer.masksToBounds=YES;
        _whiteView.layer.cornerRadius=5;
        [self.contentView addSubview:_whiteView];
        
        _activityImageView = [[UIImageView alloc]init];
        [_whiteView addSubview:_activityImageView];
        
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.textColor=COLOR_333333;
        _nameLabel.backgroundColor=[UIColor clearColor];
        _nameLabel.textAlignment=UITextAlignmentLeft;
        _nameLabel.font=FONT_14;
        _nameLabel.numberOfLines=2;
        [self.contentView addSubview:_nameLabel];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundView:backgroundView];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        [self setSelectedBackgroundView:selectedBackgroundView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {

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
    
    _whiteView.frame=CGRectMake(10, 10, 120, 80);
    _activityImageView.frame=CGRectMake(5, 5, _whiteView.frame.size.width-10, _whiteView.frame.size.height-10);

    _nameLabel.frame=CGRectMake(_whiteView.frame.origin.x+_whiteView.frame.size.width+5, _whiteView.frame.origin.y+30, SCREEN_WIDTH-_whiteView.frame.origin.x-_whiteView.frame.size.width-15, 30);
    [_nameLabel sizeToFit];
}

-(void)setData:(NSDictionary *)data
{
    NSString *strURL  = [[data objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [_activityImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    [_nameLabel setText:[data objectForKey:@"name"]];
}

@end
