//
//  OrderTotalCell.m
//  occ
//
//  Created by RS on 13-9-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MyOrderTotalCell.h"
#import "GatewayViewController.h"
#import "AppDelegate.h"

@implementation MyOrderTotalCell

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
        [self.contentView addSubview:_confirmButton];
        
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
    [[Singleton sharedInstance]setLastOrderType:[self getOrderType]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"orderNo"], @"orderNo",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:orderPay_URL andData:reqdata andDelegate:nil];
                       
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
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:nil];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                                                                  [[root objectForKey:@"data"] objectForKey:@"paymentNo"],@"tradeNO",
                                                                  [_data objectForKey:@"realMon"],@"amount",
                                                                  [self getProductionsDesc],@"tradeDesc",
                                                                  nil];
                                              GatewayViewController *viewController=[[GatewayViewController alloc]init];
                                              [viewController setOrderData:data];
                                              AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                              [myDelegate.navigationController pushViewController:viewController animated:YES];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

-(void)setData:(NSMutableDictionary*)data
{
    @try {
        _data =data;
        NSString *price=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"realMon"]];
        [_priceLabel setText:price];
        
        NSString *num=[NSString stringWithFormat:@"%@",[data objectForKey:@"allNum"]];
        [_numLabel setText:num];
    }@catch (NSException *exception) {
        
    }
}

-(NSString*)getProductionsDesc
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSArray *itemList=[_data objectForKey:@"itemList"];
    for (NSDictionary *item in itemList)
    {
        [arr addObject:[item objectForKey:@"itemName"]];
    }
    NSString *result=[arr componentsJoinedByString:@","];
    if ([result length]>49)
    {
        result=[result substringToIndex:49];
    }
    return result;
}

-(LastOrderType)getOrderType
{
    NSArray *itemList=[_data objectForKey:@"itemList"];
    for (NSDictionary *item in itemList)
    {
        if ([[item objectForKey:@"type"]intValue]==0)
        {
            return LastOrderTypeNormal;
        }
    }
    
    return LastOrderTypeGroupon;
}

@end
