//
//  GrouponFootCell.m
//  occ
//
//  Created by plocc on 13-12-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponFootCell.h"
#import "MsgViewController.h"
#import "ShopViewController.h"
#import "AppDelegate.h"

@implementation GrouponFootCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImage *redImage = [UIImage imageNamed:@"btn_bg_red"];
        redImage=[redImage stretchableImageWithLeftCapWidth:redImage.size.width/2 topCapHeight:redImage.size.height/2];
        
        UIImage *grayImage = [UIImage imageNamed:@"btn_bg_light_gray"];
        grayImage=[grayImage stretchableImageWithLeftCapWidth:grayImage.size.width/2 topCapHeight:grayImage.size.height/2];
        
        UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 300, 20)];
        titleImageView.backgroundColor = COLOR_BG_CLASS5;
        [self.contentView addSubview:titleImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleImageView.frame.origin.y, 100, 20)];
        _titleLabel.backgroundColor = COLOR_FFFFFF;
        [_titleLabel setCenter:CGPointMake(SCREEN_WIDTH/2, _titleLabel.center.y)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        _titleLabel.font = FONT_16;
        _titleLabel.textColor = COLOR_333333;
        _titleLabel.text=@"店铺信息";
        [self.contentView addSubview:_titleLabel];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+10, 70, 70)];
        _logoImageView.backgroundColor = [UIColor clearColor];
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 5.0;
        _logoImageView.image = [CommonMethods defaultImageWithType:OCCDefaultImageTypePortrait];
        [self.contentView addSubview:_logoImageView];
        
        _logoButton = [[UIButton alloc] initWithFrame:_logoImageView.frame];
        [_logoButton addTarget:self action:@selector(toShop:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_logoButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoImageView.frame.origin.x+_logoImageView.frame.size.width+10, _logoImageView.frame.origin.y, SCREEN_WIDTH, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = FONT_16;
        _nameLabel.textColor = COLOR_333333;
        [self.contentView addSubview:_nameLabel];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, SCREEN_WIDTH-100, 20)];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.font = FONT_12;
        _typeLabel.textColor=COLOR_999999;
        _typeLabel.numberOfLines=2;
        [self.contentView addSubview:_typeLabel];
        
        _favoriteShopButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_favoriteShopButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        _favoriteShopButton.titleLabel.font=FONT_12;
        [_favoriteShopButton addTarget:self action:@selector(addShopToFavorite:) forControlEvents:UIControlEventTouchUpInside];
        _favoriteShopButton.frame = CGRectMake(_typeLabel.frame.origin.x,
                                               _logoImageView.frame.origin.y+_logoImageView.frame.size.height-15,
                                               80,
                                               30);
        [self.contentView addSubview:_favoriteShopButton];
        
        UIImageView *favoriteImageView=[[UIImageView alloc]init];
        [favoriteImageView setTag:100];
        [favoriteImageView setImage:[UIImage imageNamed:@"icon_favorite_red"]];
        [favoriteImageView setFrame:CGRectMake(0, 0, 16, 16)];
        [_favoriteShopButton addSubview:favoriteImageView];
        
        OCCAttributedLabel *favoriteShopLabel=[[OCCAttributedLabel alloc]initWithFrame:CGRectMake(20, 0, 80, 16)];
        [favoriteShopLabel setTag:101];
        favoriteShopLabel.backgroundColor = [UIColor clearColor];
        favoriteShopLabel.font = FONT_14;
        favoriteShopLabel.textColor = COLOR_333333;
        favoriteShopLabel.text=@"0人已收藏";
        [_favoriteShopButton addSubview:favoriteShopLabel];
        _favoriteShopLabel=favoriteShopLabel;
        
        UILabel *lineLabel=[[UILabel alloc]init];
        lineLabel.frame=CGRectMake(_favoriteShopButton.frame.origin.x + _favoriteShopButton.frame.size.width+10, _favoriteShopButton.frame.origin.y, 0.5, 20);
        lineLabel.backgroundColor = COLOR_999999;
        lineLabel.alpha=0.5;
        //[self.contentView addSubview:lineLabel];
        
        _chatButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chatButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        _chatButton.titleLabel.font=FONT_12;
        [_chatButton addTarget:self action:@selector(doChat:) forControlEvents:UIControlEventTouchUpInside];
        _chatButton.frame = CGRectMake(_favoriteShopButton.frame.origin.x + _favoriteShopButton.frame.size.width+10, _favoriteShopButton.frame.origin.y, 100, 30);
        [self.contentView addSubview:_chatButton];
        
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
        
        _favoriteItemButton = [[UIButton alloc]init];
        [_favoriteItemButton setFrame:CGRectMake(0, _logoImageView.frame.origin.y+_logoImageView.frame.size.height+10, 145, 40)];
        [_favoriteItemButton setImage:[UIImage imageNamed:@"icon_favorite_gray"] forState:UIControlStateNormal];
        [_favoriteItemButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [_favoriteItemButton addTarget:self action:@selector(addShopToFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [_favoriteItemButton setTitle:@"收藏店铺" forState:UIControlStateNormal];
        [_favoriteItemButton setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        _favoriteItemButton.titleLabel.font=FONT_12;
        [self.contentView addSubview:_favoriteItemButton];
        
        _toshopButton = [[UIButton alloc]init];
        [_toshopButton setFrame:CGRectMake(_favoriteItemButton.frame.origin.x+_favoriteItemButton.frame.size.width+10, _favoriteItemButton.frame.origin.y, _favoriteItemButton.frame.size.width, _favoriteItemButton.frame.size.height)];
        [_toshopButton setImage:[UIImage imageNamed:@"icon_message_home"] forState:UIControlStateNormal];
        [_toshopButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        [_toshopButton addTarget:self action:@selector(toShop:) forControlEvents:UIControlEventTouchUpInside];
        [_toshopButton setTitle:@"进入店铺" forState:UIControlStateNormal];
        [_toshopButton setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        _toshopButton.titleLabel.font=FONT_12;
        [self.contentView addSubview:_toshopButton];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    [_typeLabel sizeToFit];
}

-(void)setData:(NSDictionary*)data
{
    _shopData=data;
    NSString *strURL  = [[data objectForKey:@"shopImage"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [_logoImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    [_nameLabel setText:[data objectForKey:@"shopName"]];
    [_typeLabel setText:[data objectForKey:@"shopProp"]];
    
    NSString *count = [NSString stringWithFormat:@"%@",[data objectForKey:@"shopFavourNum"]];
    if ([data objectForKey:@"shopFavourNum"]==nil)
    {
        count = @"0";
    }
    NSString *showString = [NSString stringWithFormat:@"%@%@",count,@"人收藏"];
    [_favoriteShopLabel setText:showString];
    [_favoriteShopLabel setColor:COLOR_DA6432 fromIndex:0 length:[count length]];
    [_favoriteShopLabel sizeToFit];
}

- (void)toShop:(id)sender
{
    NSDictionary *data=[NSDictionary dictionaryWithObjectsAndKeys:[_shopData objectForKey:@"shopId"],KEY_SHOPID,nil];
    ShopViewController *viewController=[[ShopViewController alloc]init];
    [viewController setData:data];
    [CommonMethods pushShopViewControllerWithData:data];
}

- (void)doChat:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO)
    {
        return;
    }
    
    NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                        [_shopData objectForKey:@"shopId"],KEY_SHOPID,
                        [_shopData objectForKey:@"shopName"],@"sender",
                        [NSNumber numberWithInt:AskTypeShop],@"type",
                        [_shopData objectForKey:@"shopId"],@"objectId",
                        nil];
    MsgViewController *viewController=[[MsgViewController alloc]init];
    [viewController setData:data];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)addShopToFavorite:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]],@"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_shopData objectForKey:@"shopName"] ,@"shopName",
                                                  [_shopData objectForKey:@"shopId"],@"shopId",
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
                                              NSString *favourNum = [NSString stringWithFormat:@"%@",[data objectForKey:@"favourNum"]];
                                              NSString *showString = [NSString stringWithFormat:@"%@ %@",favourNum,@"人收藏"];
                                              [_favoriteShopLabel setText:showString];
                                              [_favoriteShopLabel setColor:COLOR_DA6432 fromIndex:0 length:[favourNum length]];
                                              [_favoriteShopLabel sizeToFit];
                                              
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

- (void)addItemToFavorite:(id)sender
{
    
}

-(float)getCellHeight
{
    return 180.0;
}

@end
