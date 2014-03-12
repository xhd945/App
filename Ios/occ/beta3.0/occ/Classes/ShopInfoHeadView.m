//
//  ShopInfoHeadView.m
//  occ
//
//  Created by zhangss on 13-9-3.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ShopInfoHeadView.h"
#import "BusinessManager.h"
#import "MsgViewController.h"
#import "AppDelegate.h"
#import "UserManager.h"
#import "MapViewController.h"

#define kHeadImageWidth 70
#define kViewInterval   10

@implementation ShopInfoHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SHOP_BASEINFO_HEIGHT);
        self.backgroundColor = COLOR_BG_CLASSONE;
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        _headImageView.backgroundColor = [UIColor clearColor];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 5.0;
        _headImageView.image = [CommonMethods defaultImageWithType:OCCDefaultImageTypeImage];
        [self addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width+10, _headImageView.frame.origin.y, SCREEN_WIDTH, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = FONT_16;
        _nameLabel.textColor = COLOR_333333;
        [self addSubview:_nameLabel];
        
        _shopType = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+10, SCREEN_WIDTH, 20)];
        _shopType.backgroundColor = [UIColor clearColor];
        _shopType.font = FONT_12;
        _shopType.textColor=COLOR_999999;
        [self addSubview:_shopType];
        
        _favoriteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_favoriteBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        _favoriteBtn.titleLabel.font=FONT_12;
        [_favoriteBtn addTarget:self action:@selector(addFavorite:) forControlEvents:UIControlEventTouchUpInside];
        _favoriteBtn.frame = CGRectMake(_shopType.frame.origin.x, _shopType.frame.origin.y+_shopType.frame.size.height+5, 100, 30);
        [self addSubview:_favoriteBtn];
        
        UIImageView *favoriteImageView=[[UIImageView alloc]init];
        [favoriteImageView setTag:100];
        [favoriteImageView setImage:[UIImage imageNamed:@"icon_favorite_red"]];
        [favoriteImageView setFrame:CGRectMake(0, 0, 16, 16)];
        [_favoriteBtn addSubview:favoriteImageView];
        
        OCCAttributedLabel *favoriteLabel=[[OCCAttributedLabel alloc]initWithFrame:CGRectMake(20, 0, 80, 16)];
        [favoriteLabel setTag:101];
        //[favoriteLabel setFrame:CGRectMake(20, 0, 80, 20)];
        favoriteLabel.backgroundColor = [UIColor clearColor];
        favoriteLabel.font = FONT_14;
        favoriteLabel.textColor = COLOR_333333;
        favoriteLabel.text=@"0人已收藏";
        [_favoriteBtn addSubview:favoriteLabel];
        _favoriteLabel=favoriteLabel;
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(_favoriteBtn.frame.origin.x + _favoriteBtn.frame.size.width, _favoriteBtn.frame.origin.y, 0.5, 20)];
        lineLabel.backgroundColor = COLOR_999999;
        lineLabel.alpha=0.5;
        //[self addSubview:lineLabel];

        _chatButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chatButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        _chatButton.titleLabel.font=FONT_12;
        [_chatButton addTarget:self action:@selector(doChat:) forControlEvents:UIControlEventTouchUpInside];
        _chatButton.frame = CGRectMake(_favoriteBtn.frame.origin.x + _favoriteBtn.frame.size.width+2, _favoriteBtn.frame.origin.y, 100, 30);
        [self addSubview:_chatButton];
        
        UIImageView *chatImageView=[[UIImageView alloc]init];
        [chatImageView setTag:100];
        [chatImageView setImage:[UIImage imageNamed:@"icon_message_yellow"]];
        [chatImageView setFrame:CGRectMake(0, 0, 16, 16)];
        [_chatButton addSubview:chatImageView];
        
        OCCAttributedLabel *chatLabel=[[OCCAttributedLabel alloc]init];
        [chatLabel setTag:101];
        [chatLabel setFrame:CGRectMake(20, 0, 80, 16)];
        chatLabel.backgroundColor = [UIColor clearColor];
        chatLabel.font = FONT_14;
        chatLabel.textColor = COLOR_333333;
        chatLabel.text=@"联系客服";
        [_chatButton addSubview:chatLabel];
        
        _scoreButton = [[UIButton alloc]init];
        [_scoreButton setFrame:CGRectMake(275, 30, 30, 30)];
        [_scoreButton setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [_scoreButton setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateHighlighted];
        [_scoreButton.titleLabel setFont:FONT_12];
        [_scoreButton setTitleEdgeInsets:UIEdgeInsetsMake(5,0,0,0)];
        [_scoreButton setUserInteractionEnabled:NO];
        [self addSubview:_scoreButton];
        
        UIImage *grayImage = [UIImage imageNamed:@"btn_bg_gray"];
        grayImage=[grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
        
        UIImage *bgImage = [UIImage imageNamed:@"navi_icon_locate"];
        UIButton *locateButton= [[UIButton alloc] initWithFrame:CGRectZero];
        [locateButton setBackgroundColor:COLOR_44853F];
        locateButton.layer.masksToBounds = YES;
        locateButton.layer.cornerRadius = 6;
        locateButton.frame = CGRectMake(245, 35, bgImage.size.width, bgImage.size.height);
        //[locateButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [locateButton setImage:[UIImage imageNamed:@"navi_icon_locate"] forState:UIControlStateNormal];
        [locateButton addTarget:self action:@selector(doLocate:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:locateButton];
        _locateButton=locateButton;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)doLocate:(id)sender
{
    int shopId=[_shopData.shopID intValue];
    MapViewController *viewController=[[MapViewController alloc]init];
    viewController.shopId=shopId;
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)doChat:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO)
    {
        return;
    }
    
    if (_shopData.shopID == nil)
    {
        return;
    }
    
    NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                        _shopData.shopID,KEY_SHOPID,
                        _shopData.shopName,@"sender",
                        [NSNumber numberWithInt:AskTypeShop],@"type",
                        _shopData.shopID,@"objectId",
                        nil];
    MsgViewController *viewController=[[MsgViewController alloc]init];
    [viewController setData:data];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)addFavorite:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO)
    {
        return;
    }
    
    if (_shopData.shopID == nil)
    {
        ZSLog(@"店铺ID为空 不能收藏");
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]],@"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  _shopData.shopName,@"shopName",
                                                  _shopData.shopID,@"shopId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:favourShop_URL andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showSuccessDialog:@"收藏店铺成功" inView:nil];
                                              
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              _shopData.shopFavourNum= [NSNumber numberWithInt:[[data objectForKey:@"favourNum"]intValue]];
                                              NSString *favourNum = [NSString stringWithFormat:@"%@",[data objectForKey:@"favourNum"]];
                                              NSString *showString = [NSString stringWithFormat:@"%@ %@",favourNum,@"人收藏"];
                                              [_favoriteLabel setText:showString];
                                              [_favoriteLabel setColor:COLOR_DA6432 fromIndex:0 length:[favourNum length]];
                                              [_favoriteLabel sizeToFit];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"addShopToFavoriteSuccessNotification" object:nil];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

- (void)setDataForShopHeader:(Shop *)data
{
    _shopData = data;
    
    if (data.shopImage && [data.shopImage length] > 0)
    {
        NSString *strURL = [data.shopImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strURL];
        [_headImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    else
    {
        [_headImageView setImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    }
    
    [_nameLabel setText:data.shopName];
    [_nameLabel sizeToFit];
    
    /*
    _locateButton.frame = CGRectMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width+10,
                                     _nameLabel.frame.origin.y,
                                     _locateButton.frame.size.width,
                                     _locateButton.frame.size.height);
     */
    
    NSString *count = [NSString stringWithFormat:@"%@",data.shopFavourNum];
    if (data.shopFavourNum == nil)
    {
        count = @"0";
    }
    NSString *showString = [NSString stringWithFormat:@"%@ %@",count,@"人收藏"];
    [_favoriteLabel setText:showString];
    [_favoriteLabel setColor:COLOR_DA6432 fromIndex:0 length:[count length]];
    [_favoriteLabel sizeToFit];
    
    [_scoreButton setTitle:[NSString stringWithFormat:@"%.1f",[data.shopRating floatValue]] forState:UIControlStateNormal];
    
    [_shopType setText:data.shopType];
    [_shopType sizeToFit];
}

@end
