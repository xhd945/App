//
//  GrouponItemCell.m
//  occ
//
//  Created by RS on 13-11-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponPropCell.h"
#import "DetailWebViewController.h"
#import "AppDelegate.h"

#define  BASE_BTN_TAG 100

@implementation GrouponPropCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImage *image=[UIImage imageNamed:@"btn_white"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        _whiteImage=image;
        
        image=[UIImage imageNamed:@"green_selected1"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        _greenImage=image;
        
        self.clipsToBounds=YES;
        
        image=[UIImage imageNamed:@"list_bgwhite_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:image];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        
        [self setBackgroundView:backgroundView];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
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
    [self relayoutView];
}

- (void)addItemToCart:(id)sender
{
    NSMutableArray *idsArr=[[NSMutableArray alloc]init];
    for (int i=0; i<_selectedPropBtnList.count; i++)
    {
        UIView *myview=[_selectedPropBtnList objectAtIndex:i];
        if (myview==nil || ![myview isKindOfClass:[UIButton class]])
        {
            [CommonMethods showTextDialog:@"请先选择商品规格" inView:nil];
            return;
        }
        [idsArr addObject:[NSString stringWithFormat:@"%d",myview.tag]];
    }
    
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO) {
        return;
    }
    
    NSString *link=[_data objectForKey:@"link"];
    if (link!=nil && [link length] > 0)
    {
        DetailWebViewController *viewController=[[DetailWebViewController alloc]init];
        [viewController setDetailURL:link];
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"groupId"],@"id",
                                                  [NSNumber numberWithInt:1],@"buyNum",
                                                  @"1",@"type",
                                                  [idsArr componentsJoinedByString:@","],@"grouponItemId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:itemBuy_URL andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showErrorDialog:@"网络异常,请检查您的网络设置!" inView:nil];
                                          });
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
                                              [CommonMethods showSuccessDialog:@"购买团购成功" inView:nil];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"addItemToCartSuccessNotification" object:nil];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

- (void)doProp:(id)sender
{
    UIButton *sbbtn=(UIButton *)sender;
    for (int i=0; i<_propCtrlList.count; i++)
    {
        NSDictionary *data=[_propCtrlList objectAtIndex:i];
        NSArray *btnList=[data objectForKey:@"btnList"];
        for (int j=0; j<btnList.count; j++)
        {
            UIButton *btn=[btnList objectAtIndex:j];
            if (btn.tag==sbbtn.tag)
            {
                [_selectedPropBtnList replaceObjectAtIndex:i withObject:btn];
                [self relayoutView];
                return;
            }
        }
    }
}

- (void)doUpDown:(id)sender
{
    if (self.expand==0)
    {
        self.expand=1;
    }
    else
    {
        self.expand=0;
    }
}

-(void)setData:(NSMutableDictionary*)data
{
    _data=data;
    _propCtrlList=[[NSMutableArray alloc]init];
    _selectedPropBtnList=[[NSMutableArray alloc]init];
    
    CGRect rect=CGRectMake(0, 5, 10, 10);
    NSArray *itemGroupList=[data objectForKey:@"itemGroupList"];
    for (int i=0; i<itemGroupList.count; i++)
    {
        NSDictionary *data=[itemGroupList objectAtIndex:i];
        UILabel *label=[[UILabel alloc]init];
        [label setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT*i)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:FONT_14];
        [label setTextColor:COLOR_333333];
        [label setText:@"选择商品规格"];
        [label setTag:[[data objectForKey:@"itemGrpoupId"]intValue]];
        [self.contentView addSubview:label];
        
        [label sizeToFit];
        [label setFrame:CGRectMake(10, rect.origin.y+rect.size.height, label.frame.size.width, label.frame.size.height)];
        rect=label.frame;
        
        NSMutableDictionary *tmp=[[NSMutableDictionary alloc]init];
        NSMutableArray *btnList=[[NSMutableArray alloc]init];
        
        rect=CGRectMake(0, label.frame.origin.y+label.frame.size.height+5, 0, 0);
        NSArray *itemList=[data objectForKey:@"itemList"];
        for (int j=0; j<itemList.count; j++)
        {
            NSDictionary *data=[itemList objectAtIndex:j];
            UIButton *btn = [[UIButton alloc]init];
            [btn setBackgroundImage:_whiteImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(doProp:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = FONT_12;
            [btn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
            [btn setTitle:[data objectForKey:@"itemName"] forState:UIControlStateNormal];
            [btn setTag:[[data objectForKey:@"id"]intValue]];
            [self.contentView addSubview:btn];
            
            [btn sizeToFit];
            [btn setFrame:CGRectMake(rect.origin.x+rect.size.width+10, rect.origin.y, MIN(btn.frame.size.width+20,280), HEADER_HEIGHT)];
            rect=btn.frame;
            
            if (rect.origin.x+rect.size.width>300)
            {
                rect=CGRectMake(0, rect.origin.y+rect.size.height+5, 0, 0);
                [btn sizeToFit];
                [btn setFrame:CGRectMake(rect.origin.x+rect.size.width+10, rect.origin.y, MIN(btn.frame.size.width+20,280), HEADER_HEIGHT)];
                rect=btn.frame;
            }
            
            [btnList addObject:btn];
            
            if (j==0)
            {
                [_selectedPropBtnList addObject:btn];
            }
        }
        
        [tmp setObject:label forKey:@"label"];
        [tmp setObject:btnList forKey:@"btnList"];
        [_propCtrlList addObject:tmp];
    }

    self.maxHeight=rect.origin.y+rect.size.height+5;
    self.minHeight=HEADER_HEIGHT;
}

-(float)getCellHeight
{
    if(self.expand==0)
    {
        return self.maxHeight;
    }
    else
    {
        return self.maxHeight;
    }
}

-(void)relayoutView
{
    for (int i=0; i<_propCtrlList.count; i++)
    {
        NSDictionary *data=[_propCtrlList objectAtIndex:i];
        UILabel *label=[data objectForKey:@"label"];
        NSArray *btnList=[data objectForKey:@"btnList"];
        UIButton *sbbtn=[_selectedPropBtnList objectAtIndex:i];
        for (int j=0; j<btnList.count; j++)
        {
            UIButton *btn=[btnList objectAtIndex:j];
            if (btn.tag==sbbtn.tag)
            {
                [btn setBackgroundImage:_greenImage forState:UIControlStateNormal];
                //[label setText:sbbtn.titleLabel.text];
                //[label sizeToFit];
            }
            else
            {
                [btn setBackgroundImage:_whiteImage forState:UIControlStateNormal];
            }
        }
    }
}

@end
