//
//  LeftBrandCell.m
//  occ
//
//  Created by RS on 13-8-8.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "BrandCell.h"
#import "ShopViewController.h"
#import "AppDelegate.h"
#import "ShopFilterViewController.h"

@implementation BrandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _leftButton = [[OCCButton alloc]init];
        [_leftButton setFrame:CGRectMake(10, 5, 117, 91)];
        [_leftButton.titleLabel setFont:FONT_12];
        [_leftButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leftButton];
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 83, 57)];
        _leftImageView.center=CGPointMake(_leftButton.frame.size.width/2, _leftButton.frame.size.height/2);
        [_leftButton addSubview:_leftImageView];
        
        _rightButton = [[OCCButton alloc]init];
        [_rightButton setFrame:CGRectMake(150, _leftButton.frame.origin.y, _leftButton.frame.size.width, _leftButton.frame.size.height)];
        [_rightButton.titleLabel setFont:FONT_12];
        [_rightButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightButton];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:_leftImageView.frame];
        _rightImageView.center=CGPointMake(_rightButton.frame.size.width/2, _rightButton.frame.size.height/2);
        [_rightButton addSubview:_rightImageView];
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
    [self setBackgroundView:nil];
    [super layoutSubviews];
}

- (IBAction)doAction:(id)sender
{
    OCCButton *btn=(OCCButton *)sender;
    [CommonMethods pushShopViewControllerWithData:btn.data];
}

-(void)setData1:(Brand *)data
{
    self.leftButton.userInteractionEnabled = YES;
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"brand_bg"] forState:UIControlStateNormal];
    [self.leftButton setData:[NSDictionary dictionaryWithObjectsAndKeys:data.brandID,KEY_SHOPID, nil]];
    
    NSString *strURL  = [data.brandIconUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.leftImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
}

- (void)setData2:(Brand *)data
{
    if (data==nil)
    {
        self.rightButton.hidden=YES;
        return;
    }
    else
    {
        self.rightButton.hidden=NO;
    }
    
    self.rightButton.userInteractionEnabled = YES;
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"brand_bg"] forState:UIControlStateNormal];
    [self.rightButton setData:[NSDictionary dictionaryWithObjectsAndKeys:data.brandID,KEY_SHOPID, nil]];

    NSString *strURL  = [data.brandIconUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.rightImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
}

@end
