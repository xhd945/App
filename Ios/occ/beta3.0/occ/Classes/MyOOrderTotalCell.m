//
//  MyOOrderTotalCell.m
//  occ
//
//  Created by RS on 13-11-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyOOrderTotalCell.h"
#import "GatewayViewController.h"
#import "AppDelegate.h"

@implementation MyOOrderTotalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _totlePriceLabel=[[UILabel alloc]init];
        [_totlePriceLabel setFont:FONT_14];
        [_totlePriceLabel setText:@"合计:"];
        [_totlePriceLabel setTextColor:COLOR_333333];
        [_totlePriceLabel setHighlightedTextColor:COLOR_333333];
        [_totlePriceLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_totlePriceLabel];
        
        _priceLabel=[[UILabel alloc]init];
        [_priceLabel setFont:FONT_14];
        [_priceLabel setTextAlignment:NSTextAlignmentRight];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextColor:COLOR_DA6432];
        [_priceLabel setHighlightedTextColor:COLOR_DA6432];
        [self.contentView addSubview:_priceLabel];
        
        _totleNumberLabel=[[UILabel alloc]init];
        [_totleNumberLabel setFont:FONT_14];
        [_totleNumberLabel setText:@"数量:"];
        [_totleNumberLabel setTextColor:COLOR_333333];
        [_totleNumberLabel setHighlightedTextColor:COLOR_333333];
        [_totleNumberLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_totleNumberLabel];
        
        _numLabel=[[UILabel alloc]init];
        [_numLabel setFont:FONT_14];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setTextColor:COLOR_DA6432];
        [_numLabel setHighlightedTextColor:COLOR_DA6432];
        [self.contentView addSubview:_numLabel];
        
        _confirmButton = [CommonMethods buttonWithTitle:@"立即支付" withTarget:self andSelector:@selector(doConfirm:) andFrame:CGRectMake(210, 10, 80, 44) andButtonType:OCCButtonTypeYellow];
        //[self.contentView addSubview:_confirmButton];
        
        UIImage *image=[UIImage imageNamed:@"list_bgwhite3_nor"];
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

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    _totlePriceLabel.frame=CGRectMake(10, 10, 120, 20);
    _priceLabel.frame=_totlePriceLabel.frame;
    
    _totleNumberLabel.frame=CGRectMake(10, 30, 120, 20);
    _numLabel.frame=_totleNumberLabel.frame;
    
    _confirmButton.center=CGPointMake(self.contentView.bounds.size.width-_confirmButton.frame.size.width/2-10, self.contentView.bounds.size.height/2);
}

- (void)doConfirm:(id)sender
{
    int type=[[_data objectForKey:@"orderStat"]intValue];
}

- (void)confirm
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [self.data objectForKey:@"id"],@"orderId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:orderRecv_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                      });
                       
                       NSError *error = [request error];
                       if (error)
                       {
                           NSLog(@"Failed %@ with code %d and with userInfo %@",
                                 [error domain],
                                 [error code],
                                 [error userInfo]);
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"网络异常,请检查您的网络设置!" inView:nil];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:nil];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                  message:@"确认成功"
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:@"确定"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

-(void)setData:(NSMutableDictionary*)data
{
    @try {
        _data =data;
        NSString *price=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"allPrice"]];
        [_priceLabel setText:price];
        
        NSString *num=[NSString stringWithFormat:@"%@",[data objectForKey:@"allNum"]];
        [_numLabel setText:num];
    }
    @catch (NSException *exception) {
        
    }
    
    if ([[data objectForKey:@"orderStat"]intValue]==150)  //交易关闭
    {
        [_priceLabel setTextColor:COLOR_333333];
        [_priceLabel setHighlightedTextColor:COLOR_333333];
        [_numLabel setTextColor:COLOR_333333];
        [_numLabel setHighlightedTextColor:COLOR_333333];
    }
    else
    {
        [_priceLabel setTextColor:COLOR_DA6432];
        [_priceLabel setHighlightedTextColor:COLOR_DA6432];
        [_numLabel setTextColor:COLOR_DA6432];
        [_numLabel setHighlightedTextColor:COLOR_DA6432];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_data setObject:@"9" forKey:@"orderStat"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmOrderSuccessNotification"
                                                        object:nil];
    
    //UIImage *grayImage=[UIImage imageNamed:@"btn_bg_light_gray"];
    //grayImage = [grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
    //[(UIButton*)self.confirmButton setBackgroundImage:grayImage forState:UIControlStateNormal];
    //[(UIButton*)self.confirmButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    //[(UIButton*)self.confirmButton setUserInteractionEnabled:NO];
}

@end
