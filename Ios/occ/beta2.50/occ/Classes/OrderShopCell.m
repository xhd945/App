//
//  OrderShopCell.m
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OrderShopCell.h"
#import "MsgViewController.h"
#import "AppDelegate.h"

@implementation OrderShopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView= [[UIImageView alloc]init];
        [_lineImageView setImage:[UIImage imageNamed:@"line_dotted.png"]];
        [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line_dotted.png"]];
        [_lineImageView setFrame:CGRectZero];
        _lineImageView.clipsToBounds=YES;
        [self.contentView addSubview:_lineImageView];
        
        _shopImageView = [[UIImageView alloc]init];
        [_shopImageView setFrame:CGRectZero];
        [_shopImageView setImage:[UIImage imageNamed:@"bg_shop.png"]];
        [_shopImageView setHighlightedImage:[UIImage imageNamed:@"bg_shop.png"]];
        [self.contentView addSubview:_shopImageView];
        
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setText:@"商家:"];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setHighlightedTextColor:COLOR_333333];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:FONT_12];
        [self.contentView addSubview:_nameLabel];
        
        _onlineButton = [[UIButton alloc]init];
        [_onlineButton setFrame:CGRectZero];
        [_onlineButton setImage:[UIImage imageNamed:@"bg_msg.png"] forState:UIControlStateNormal];
        [_onlineButton addTarget:self action:@selector(doMsg:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_onlineButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    [self.lineImageView setFrame:CGRectMake(0, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width, 2)];
    _shopImageView.frame=CGRectMake(15, 0, 22, 22);
    _shopImageView.center=CGPointMake(_shopImageView.center.x, self.frame.size.height/2);
    
    [_nameLabel sizeToFit];
    _nameLabel.frame=CGRectMake(_shopImageView.frame.origin.x+_shopImageView.frame.size.width, 0, _nameLabel.frame.size.width, self.frame.size.height);
    _onlineButton.bounds=CGRectMake(0, 0, 60, self.contentView.bounds.size.height);
    _onlineButton.center=CGPointMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width+15, self.frame.size.height/2);
}

-(void)setData:(NSMutableDictionary*)data
{
    _data =data;
    NSString *name=[NSString stringWithFormat:@"商家:%@",[data objectForKey:@"name"]];;
    [_nameLabel setText:name];
}

- (void)doMsg:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO) {
        return;
    }
    
    NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                        [_data objectForKey:@"id"],@"shopId",
                        [_data objectForKey:@"name"],@"sender",
                        [NSNumber numberWithInt:AskTypeShop],@"type",
                        [_data objectForKey:@"id"],@"objectId",
                        nil];
    MsgViewController *viewController=[[MsgViewController alloc]init];
    [viewController setData:data];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

@end
