//
//  NearbyCell.m
//  occ
//
//  Created by RS on 13-9-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "NearbyCell.h"

#define kSelectViewWidth 40.0
#define kImageWidth 70.0

@implementation NearbyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _shopImageView = [[UIImageView alloc]init];
        _shopImageView.frame=CGRectMake(0, 0, 320, 425);
        _shopImageView.backgroundColor = [UIColor clearColor];
        _shopImageView.layer.cornerRadius = 0.0;
        _shopImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_shopImageView];
        
        /*
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = FONT_16;
        _nameLabel.textColor = COLOR_333333;
        [self.contentView addSubview:_nameLabel];
        
        _briefLabel = [[UILabel alloc] init];
        _briefLabel.backgroundColor = [UIColor clearColor];
        _briefLabel.font = FONT_12;
        _briefLabel.textColor = COLOR_999999;
        [self.contentView addSubview:_briefLabel];
        
        _ratingView = [[OCCRatingView alloc] init];
        self.ratingView.userInteractionEnabled = NO;
        //[self.contentView addSubview:_ratingView];
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.font = FONT_12;
        _typeLabel.textColor = COLOR_999999;
        [self.contentView addSubview:_typeLabel];
        
        _favourLabel = [[UILabel alloc] init];
        _favourLabel.backgroundColor = [UIColor clearColor];
        _favourLabel.font = FONT_12;
        _favourLabel.textColor = COLOR_999999;
        [self.contentView addSubview:_favourLabel];
        
        _notifyLabel = [[UILabel alloc] init];
        _notifyLabel.backgroundColor = [UIColor clearColor];
        _notifyLabel.font = FONT_12;
        _notifyLabel.textColor = COLOR_999999;
        _notifyLabel.numberOfLines=0;
        [self.contentView addSubview:_notifyLabel];
         */
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)setData:(NSDictionary*)data
{
    NSArray *arr=[data objectForKey:@"notifyPicList"];
    if (arr!=nil&&arr.count>0)
    {
        NSString *strURL = [arr objectAtIndex:0];
        if ([strURL hasPrefix:@"http://"])
        {
            NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [self.shopImageView setImageWithURL:url
                               placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
        }
    }
    else
    {
        NSString *strURL = [data objectForKey:@"picturePath"];
        NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.shopImageView setImageWithURL:url
                           placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    
    /*
    NSString *strURL  = [[data objectForKey:@"picturePath"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.shopImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    [self.nameLabel setText:[data objectForKey:@"shopName"]];
    
    //[self.briefLabel setText:[data objectForKey:@"brief"]];
    
    NSString *favour = [NSString stringWithFormat:@"%@ 人浏览",[data objectForKey:@"favourNum"]];
    [self.favourLabel setText:favour];
    [self.favourLabel sizeToFit];
    
    [self.ratingView setRating:[data objectForKey:@"evaluation"]];
    
    [self.typeLabel setText:[data objectForKey:@"classification"]];
    
    [self.notifyLabel setText:[data objectForKey:@"notify"]];
    
    _shopImageView.frame=CGRectMake(10, 10, kImageWidth, kImageWidth);
    _nameLabel.frame=CGRectMake(_shopImageView.frame.origin.x+_shopImageView.frame.size.width+10, _shopImageView.frame.origin.y,
                                300-kImageWidth-10, 20);
    [_nameLabel sizeToFit];
    _briefLabel.frame=CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height,
                                 300-kImageWidth-10, 20);
    [_briefLabel sizeToFit];
    _ratingView.frame=CGRectMake(_nameLabel.frame.origin.x, _briefLabel.frame.origin.y+_briefLabel.frame.size.height,
                                 100, 20);
    _typeLabel.frame=CGRectMake(_briefLabel.frame.origin.x, _ratingView.frame.origin.y+_ratingView.frame.size.height,
                                300-kImageWidth-10, 20);
    [_typeLabel sizeToFit];
    _favourLabel.frame=CGRectMake(_typeLabel.frame.origin.x+_typeLabel.frame.size.width+10, _ratingView.frame.origin.y+_ratingView.frame.size.height,
                                  300-kImageWidth-10, 20);
    [_favourLabel sizeToFit];
    _notifyLabel.frame=CGRectMake(_typeLabel.frame.origin.x, _typeLabel.frame.origin.y+_typeLabel.frame.size.height,
                                  300-kImageWidth-10, 20);
    [_notifyLabel sizeToFit];
    
    self.height=_notifyLabel.frame.origin.y+_notifyLabel.frame.size.height+10;
     */
}

@end
