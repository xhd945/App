//
//  MyOOrderStatusCell.m
//  occ
//
//  Created by RS on 13-11-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyOOrderStatusCell.h"

@implementation MyOOrderStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView =[[UIImageView alloc]init];
        [_lineImageView setImage:[UIImage imageNamed:@"line3"]];
        [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line3"]];
        [self.contentView addSubview:_lineImageView];
        
        UIImage *grayImage=[UIImage imageNamed:@"bg_lightgray"];
        grayImage=[grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
        
        UIButton *statustButton = [[UIButton alloc]init];
        [statustButton setFrame:CGRectZero];
        [statustButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [statustButton addTarget:self action:@selector(doConfirm:) forControlEvents:UIControlEventTouchUpInside];
        statustButton.titleLabel.font = FONT_12;
        [statustButton setTitle:@"店铺名称" forState:UIControlStateNormal];
        [statustButton setTitleColor:COLOR_27813A forState:UIControlStateNormal];
        [statustButton setUserInteractionEnabled:NO];
        [self.contentView addSubview:statustButton];
        _statustButton=statustButton;
        
        _statustLabel = [[UILabel alloc]init];
        [_statustLabel setFrame:CGRectZero];
        [_statustLabel setFont:FONT_12];
        [_statustLabel setTextColor:COLOR_27813A];
        [_statustLabel setHighlightedTextColor:COLOR_27813A];
        [_statustLabel setTextAlignment:NSTextAlignmentRight];
        [_statustLabel setBackgroundColor:[UIColor clearColor]];
        //[self.contentView addSubview:_statustLabel];
        
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setFrame:CGRectZero];
        [_timeLabel setFont:FONT_12];
        [_timeLabel setTextColor:COLOR_27813A];
        [_timeLabel setHighlightedTextColor:COLOR_27813A];
        [_timeLabel setTextAlignment:NSTextAlignmentLeft];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        //[self.contentView addSubview:_timeLabel];
        
        UIImage *image=[UIImage imageNamed:@"list_bgwhite1_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height-10];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:image];
        [self setBackgroundView:backgroundView];
        
        UIView *selectedBackgroundView=[[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        [self setSelectedBackgroundView:selectedBackgroundView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    self.lineImageView.frame=CGRectMake(10, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-20, 1);
    
    [_statustButton sizeToFit];
    int width=MAX(240, _statustButton.frame.size.width+10);
    _statustButton.frame = CGRectMake((self.contentView.frame.size.width - width )/2,(30-22)/2, width, 22);
    
    _statustLabel.frame = CGRectMake(10,0, self.contentView.frame.size.width-10, self.frame.size.height);
    _timeLabel.frame = CGRectMake(10,0, self.contentView.frame.size.width-10, self.frame.size.height);
}

-(void)setData:(NSDictionary*)data
{
    _data=data;
    NSString *createdDate=[data objectForKey:@"createdDate"]!=nil?[data objectForKey:@"createdDate"]:@"";
    NSString *closeDate=[data objectForKey:@"closeDate"]!=nil?[data objectForKey:@"closeDate"]:@"";
    NSString *orderStat=[CommonMethods getOrderStatusbyId:[[data objectForKey:@"orderStat"]intValue]];
    
    if(orderStat!=nil)
    {
        _statustLabel.text=[NSString stringWithFormat:@"%@",orderStat];
    }
    
    if (createdDate!=nil)
    {
        _timeLabel.text=[NSString stringWithFormat:@"下单时间:%@",createdDate];
    }
    else
    {
        _timeLabel.text=[NSString stringWithFormat:@"下单时间:%@",@""];
    }
    
    if ([[data objectForKey:@"orderStat"]intValue]==150)  //交易关闭
    {
        NSString *text=[NSString stringWithFormat:@"%@ 关闭时间:%@",orderStat,closeDate];
        [_statustButton setTitle:text forState:UIControlStateNormal];
        [_statustButton setTitle:text forState:UIControlStateHighlighted];
        
        [_statustLabel setTextColor:COLOR_453D3A];
        [_statustLabel setHighlightedTextColor:COLOR_453D3A];
        [_timeLabel setTextColor:COLOR_453D3A];
        [_timeLabel setHighlightedTextColor:COLOR_453D3A];
        [_statustButton setTitleColor:COLOR_453D3A forState:UIControlStateNormal];
    }
    else
    {
        NSString *text=[NSString stringWithFormat:@"%@ 下单时间:%@",orderStat,createdDate];
        [_statustButton setTitle:text forState:UIControlStateNormal];
        [_statustButton setTitle:text forState:UIControlStateHighlighted];
        
        [_statustLabel setTextColor:COLOR_27813A];
        [_statustLabel setHighlightedTextColor:COLOR_27813A];
        [_timeLabel setTextColor:COLOR_27813A];
        [_timeLabel setHighlightedTextColor:COLOR_27813A];
        [_statustButton setTitleColor:COLOR_27813A forState:UIControlStateNormal];
    }
}

- (void)doConfirm:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"orderId"], @"orderId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadCart_URL andData:reqdata andDelegate:nil];
                       
                       NSError *error = [request error];
                       if (error)
                       {
                           NSLog(@"Failed %@ with code %d and with userInfo %@",
                                 [error domain],
                                 [error code],
                                 [error userInfo]);
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root!=nil && [[root objectForKey:@"code"]intValue]==0)
                       {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              
                                          });
                       }
                   });
}

@end
