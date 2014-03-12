//
//  GoodsPropCell.m
//  occ
//
//  Created by RS on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsPropCell.h"

#define kBtnWidth 35
#define  FOOT_BUTTON_WIDTH  120
#define  FOOT_BUTTON_HEIGHT 40

@implementation GoodsPropCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _propBtnList1=[[NSMutableArray alloc]init];
        _propBtnList2=[[NSMutableArray alloc]init];
        
        _outView=[[UIView alloc]init];
        [_outView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_outView setBackgroundColor:[UIColor clearColor]];
        [_outView setUserInteractionEnabled:YES];
        [self addSubview:_outView];
        
        _stockLabel = [[UILabel alloc]init];
        _stockLabel.backgroundColor = [UIColor clearColor];
        _stockLabel.font = FONT_12;
        _stockLabel.textColor = COLOR_999999;
        [_outView addSubview:_stockLabel];
        
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = COLOR_999999;
        //[self addSubview:_lineLabel];
        
        _propLabel=[[UILabel alloc]init];
        [_propLabel setFrame:CGRectZero];
        [_propLabel setBackgroundColor:[UIColor clearColor]];
        [_propLabel setFont:FONT_14];
        [_propLabel setTextColor:COLOR_333333];
        [self addSubview:_propLabel];
        
        _prop1NameLabel=[[UILabel alloc]init];
        [_prop1NameLabel setFrame:CGRectZero];
        [_prop1NameLabel setBackgroundColor:[UIColor clearColor]];
        [_prop1NameLabel setFont:FONT_14];
        [_prop1NameLabel setTextColor:COLOR_333333];
        [_outView addSubview:_prop1NameLabel];
        
        _prop2NameLabel=[[UILabel alloc]init];
        [_prop2NameLabel setFrame:CGRectZero];
        [_prop2NameLabel setBackgroundColor:[UIColor clearColor]];
        [_prop2NameLabel setFont:FONT_14];
        [_prop2NameLabel setTextColor:COLOR_333333];
        [_outView addSubview:_prop2NameLabel];
        
        _plusButton =[[UIButton alloc]init];
        [_plusButton setTitle:nil forState:UIControlStateNormal];
        [_plusButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [_plusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg3_right"] forState:UIControlStateNormal];
        [_plusButton addTarget:self action:@selector(doPlus:) forControlEvents:UIControlEventTouchUpInside];
        [_outView addSubview:_plusButton];
        
        _minusButton =[[UIButton alloc]init];
        [_minusButton setImage:[UIImage imageNamed:@"reduce.png"] forState:UIControlStateNormal];
        [_minusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg1_left"] forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(doMinus:) forControlEvents:UIControlEventTouchUpInside];
        [_outView addSubview:_minusButton];
        
        _numButton =[[UIButton alloc]init];
        [_numButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        _numButton.titleLabel.font = FONT_14;
        [_numButton setBackgroundImage:[UIImage imageNamed:@"btn_bg2_mid"] forState:UIControlStateNormal];
        [_numButton setTitle:@"0" forState:UIControlStateNormal];
        [_outView addSubview:_numButton];
        _numButton.userInteractionEnabled = NO;
        
        _favoriteButton =[[UIButton alloc]init];
        [_favoriteButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [_favoriteButton setTitle:@"收藏商品" forState:UIControlStateNormal];
        _favoriteButton.titleLabel.font = FONT_14;
        [_favoriteButton setImage:[UIImage imageNamed:@"btn_favorite_nor.png"] forState:UIControlStateNormal];
        [_favoriteButton setBackgroundImage:[[UIImage imageNamed:@"btn_white.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4, 0.0, 4)] forState:UIControlStateNormal];
        [_favoriteButton addTarget:self action:@selector(addItemToFavorite:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:_favoriteButton];
        
        _cartButton =[[UIButton alloc]init];
        [_cartButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [_cartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        _cartButton.titleLabel.font = FONT_14;
        [_cartButton setImage:[UIImage imageNamed:@"btn_shopcar_nor.png"] forState:UIControlStateNormal];
        [_cartButton setBackgroundImage:[[UIImage imageNamed:@"btn_white.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4, 0.0, 4)] forState:UIControlStateNormal];
        [_cartButton addTarget:self action:@selector(addItemToCart:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:_cartButton];
        
        _upDownButton =[[UIButton alloc]init];
        [_upDownButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_upDownButton addTarget:self action:@selector(doUpDown:) forControlEvents:UIControlEventTouchUpInside];
        _upDownButton.titleLabel.font = FONT_12;
        [_upDownButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [self addSubview:_upDownButton];
        
        _upDownImageView = [[UIImageView alloc]init];
        [_upDownImageView setFrame:CGRectMake(275, 18, 11, 11)];
        [_upDownImageView setImage:[UIImage imageNamed:@"arrow_down"]];
        _upDownImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_upDownImageView];
        
        UIImage *redImage = [UIImage imageNamed:@"list_bgremind_nor.png"];
        redImage=[redImage stretchableImageWithLeftCapWidth:redImage.size.width/2 topCapHeight:redImage.size.height/2];
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:redImage];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        
        [self setBackgroundView:backgroundView];
        [self setSelectedBackgroundView:selectedBackgroundView];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
    
    [self bringSubviewToFront:_upDownButton];
    if(self.expand==0)
    {
        _outView.hidden=YES;
        _propLabel.hidden=NO;
        [_favoriteButton setFrame:CGRectMake(30, self.minHeight-FOOT_BUTTON_HEIGHT-5, FOOT_BUTTON_WIDTH, FOOT_BUTTON_HEIGHT)];
        [_cartButton setFrame:CGRectMake(170, self.minHeight-FOOT_BUTTON_HEIGHT-5, FOOT_BUTTON_WIDTH, FOOT_BUTTON_HEIGHT)];
        _lineLabel.frame= CGRectMake(10, self.minHeight-FOOT_BUTTON_HEIGHT-5, SCREEN_WIDTH-20, 0.5);
        _upDownImageView.transform = CGAffineTransformIdentity;
    }
    else
    {
        _outView.hidden=NO;
        _propLabel.hidden=YES;
        [_favoriteButton setFrame:CGRectMake(30, self.maxHeight-FOOT_BUTTON_HEIGHT-5, FOOT_BUTTON_WIDTH, FOOT_BUTTON_HEIGHT)];
        [_cartButton setFrame:CGRectMake(170, self.maxHeight-FOOT_BUTTON_HEIGHT-5, FOOT_BUTTON_WIDTH, FOOT_BUTTON_HEIGHT)];
        _lineLabel.frame= CGRectMake(10, self.maxHeight-FOOT_BUTTON_HEIGHT-5, SCREEN_WIDTH-20, 0.5);
        _upDownImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)doProp1:(id)sender
{
    UIButton *btn= (UIButton *)sender;
    self.x=btn.tag;
    NSArray *propList1=[_data objectForKey:@"propList1"];
    NSArray *propList2=[[propList1 objectAtIndex:self.x] objectForKey:@"propList2"];
    if (propList2!=nil&&[propList2 count]>0)
    {
        self.y=0;
    }
    [_delegate itemChange:[self getItemId]];
}

- (void)doProp2:(id)sender
{
    UIButton *btn= (UIButton *)sender;
    self.y=btn.tag;
    [_delegate itemChange:[self getItemId]];
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
    
    [_delegate updownChange];
}

- (void)doPlus:(id)sender
{
    int stockNum=[self getStockNum];
    _buyNum++;
    if (_buyNum>=stockNum)
    {
        _buyNum=stockNum;
    }
    
    [_numButton setTitle:[NSString stringWithFormat:@"%d",_buyNum] forState:UIControlStateNormal];
}

- (void)doMinus:(id)sender
{
    if (_buyNum==1)
    {
        return;
    }
    
    _buyNum--;
    if (_buyNum<=0)
    {
        _buyNum=0;
    }
    [_numButton setTitle:[NSString stringWithFormat:@"%d",_buyNum] forState:UIControlStateNormal];
}

- (void)addItemToFavorite:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [NSNumber numberWithLong:[self getItemId]],KEY_ID,
                                                  [_data objectForKey:KEY_NAME],KEY_NAME,
                                                  [NSNumber numberWithInteger:OCCSearchClassiFicationItem],KEY_CATEGORY,
                                                  [NSNumber numberWithInt:OCCFavoriteFromOther],KEY_FROMTYPE,
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:mobileAddItemFavour_URL andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showSuccessDialog:@"收藏商品成功" inView:nil];
                                              [_favoriteButton setImage:[UIImage imageNamed:@"btn_favorite_press"] forState:UIControlStateNormal];
                                              [_favoriteButton setTitle:@"已收藏" forState:UIControlStateNormal];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"addItemToFavoriteSuccessNotification" object:nil];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

- (void)addItemToCart:(id)sender
{
    BOOL isLogin=[CommonMethods checkIsLogin];
    if (isLogin==NO)
    {
        return;
    }
    
    /*
    if ([self getExpand]==0)
    {
        self.expand=1;
        [_delegate updownChange];
        return;
    }
     */
    
    if (_buyNum<=0)
    {
        [CommonMethods showTextDialog:@"购买数量为0" inView:nil];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], KEY_TGC,
                                                  [NSNumber numberWithLong:[self getItemId]],KEY_ID,
                                                  [_data objectForKey:KEY_SHOPID],KEY_SHOPID,//能取就取
                                                  [NSNumber numberWithInt:self.buyNum],KEY_BUYNUM,
                                                  @"0",KEY_TYPE,   //0：商品；1：团购
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
                                              [CommonMethods showSuccessDialog:@"添加到购物车成功" inView:nil];
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

-(void)setData:(NSMutableDictionary*)data
{
    _data=data;
    [self getXY];
    
    NSArray *propList1=[data objectForKey:@"propList1"];
    if ([propList1 count]==0)
    {
        return;
    }
    
    int stockNum=[self getStockNum];
    [_stockLabel setText:[NSString stringWithFormat:@"(库存%d件)",stockNum]];
    if (stockNum>0 &&self.buyNum==0)
    {
        self.buyNum=1;
        [_numButton setTitle:[NSString stringWithFormat:@"%d",self.buyNum] forState:UIControlStateNormal];
    }
    
    NSString *prop=[data objectForKey:@"prop"];
    [_propLabel setText:prop];
    
    NSString *prop1Name=[data objectForKey:@"prop1Name"];
    [_prop1NameLabel setText:[NSString stringWithFormat:@"选择%@:",prop1Name]];
    
    for (int i=0; i<[_propBtnList1 count]; i++)
    {
        UIButton *btn= (UIButton *)[_propBtnList1 objectAtIndex:i];
        [btn removeFromSuperview];
        btn=nil;
    }
    [_propBtnList1 removeAllObjects];
    
    for (int i=0; i<[propList1 count]; i++)
    {
        UIButton *btn=btn = [[UIButton alloc]init];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_White.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doProp1:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FONT_12;
        [btn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [btn setTag:i];
        [btn setTitle:[[propList1 objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
        [_outView addSubview:btn];
        [_propBtnList1 addObject:btn];
        
        if (i==self.x)
        {
            [btn setBackgroundImage:[[UIImage imageNamed:@"green_selected1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
            [btn setBackgroundImage:[[UIImage imageNamed:@"green_selected1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
        }
    }
    
    NSString *prop2Name=[data objectForKey:@"prop2Name"];
    [_prop2NameLabel setText:[NSString stringWithFormat:@"选择%@:",prop2Name]];
    
    if (prop2Name==nil || [prop2Name length]==0)
    {
        _prop2NameLabel.hidden=YES;
    }
    
    for (int i=0; i<[_propBtnList2 count]; i++)
    {
        UIButton *btn= (UIButton *)[_propBtnList2 objectAtIndex:i];
        [btn removeFromSuperview];
        btn=nil;
    }
    [_propBtnList2 removeAllObjects];
    
    NSArray *propList2=[[propList1 objectAtIndex:self.x] objectForKey:@"propList2"];
    for (int i=0; i<[propList2 count]; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_White.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doProp2:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FONT_12;
        [btn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [btn setTag:i];
        [btn setTitle:[[propList2 objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
        [_outView addSubview:btn];
        [_propBtnList2 addObject:btn];
        
        if (i==self.y)
        {
            [btn setBackgroundImage:[[UIImage imageNamed:@"green_selected1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
            [btn setBackgroundImage:[[UIImage imageNamed:@"green_selected1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
        }
    }
    
    [self xxxx];
}

-(void)xxxx
{
    int height=0;
    
    [_propLabel setFrame:CGRectMake(20, 15, SCREEN_WIDTH-40, 40)];
    [_propLabel sizeToFit];
    [_propLabel setFrame:CGRectMake(_propLabel.frame.origin.x, _propLabel.frame.origin.y, SCREEN_WIDTH-40,_propLabel.frame.size.height)];
    height=_propLabel.frame.origin.y+_propLabel.frame.size.height;
    
    [_prop1NameLabel setFrame:CGRectMake(20, 15, SCREEN_WIDTH, 40)];
    [_prop1NameLabel sizeToFit];
    height=_prop1NameLabel.frame.origin.y+_prop1NameLabel.frame.size.height;
    
    CGRect rect=CGRectMake(10, height+5, 0, 0);
    for (int i=0;i<[_propBtnList1 count];i++)
    {
        UIButton *btn= (UIButton *)[_propBtnList1 objectAtIndex:i];
        [btn sizeToFit];
        [btn setFrame:CGRectMake(rect.origin.x+rect.size.width+10, rect.origin.y, btn.frame.size.width+20, HEADER_HEIGHT)];
        rect=btn.frame;
        
        if (rect.origin.x+rect.size.width>300)
        {
            rect=CGRectMake(10, rect.origin.y+rect.size.height+5, 0, 0);
            [btn sizeToFit];
            [btn setFrame:CGRectMake(rect.origin.x+rect.size.width+10, rect.origin.y, btn.frame.size.width+20, HEADER_HEIGHT)];
            rect=btn.frame;
        }
    }
    height=rect.origin.y+rect.size.height;
    
    if ([_propBtnList2 count]>0)
    {
        [_prop2NameLabel setFrame:CGRectMake(20, height+5, SCREEN_WIDTH, 40)];
        [_prop2NameLabel sizeToFit];
        height=_prop2NameLabel.frame.origin.y+_prop2NameLabel.frame.size.height;
        
        rect=CGRectMake(10, height+5, 0, 0);
        for (int i=0;i<[_propBtnList2 count];i++)
        {
            UIButton *btn= (UIButton *)[_propBtnList2 objectAtIndex:i];
            [btn sizeToFit];
            [btn setFrame:CGRectMake(rect.origin.x+rect.size.width+10, rect.origin.y, MIN(btn.frame.size.width+20,280), HEADER_HEIGHT)];
            rect=btn.frame;
            
            if (rect.origin.x+rect.size.width>300)
            {
                rect=CGRectMake(10, rect.origin.y+rect.size.height+5, 0, 0);
                [btn sizeToFit];
                [btn setFrame:CGRectMake(rect.origin.x+rect.size.width+10, rect.origin.y, MIN(btn.frame.size.width+20,280), HEADER_HEIGHT)];
                rect=btn.frame;
            }
        }
        height=rect.origin.y+rect.size.height;
    }
    
    _minusButton.frame = CGRectMake(20, height+5, kBtnWidth, kBtnWidth);
    _numButton.frame = CGRectMake(_minusButton.frame.origin.x+_minusButton.frame.size.width, _minusButton.frame.origin.y, kBtnWidth, kBtnWidth);
    _plusButton.frame = CGRectMake(_numButton.frame.origin.x+_numButton.frame.size.width, _numButton.frame.origin.y, kBtnWidth, kBtnWidth);
    _stockLabel.frame= CGRectMake(_plusButton.frame.origin.x+_plusButton.frame.size.width, _plusButton.frame.origin.y, 100, kBtnWidth);
    height=_plusButton.frame.origin.y+_plusButton.frame.size.height;
    
    _lineLabel.frame= CGRectMake(10, height, SCREEN_WIDTH-20, 0.5);
    
    [_favoriteButton setFrame:CGRectMake(30, _propLabel.frame.origin.x+_propLabel.frame.size.height+5, FOOT_BUTTON_WIDTH, 40)];
    [_cartButton setFrame:CGRectMake(170, _propLabel.frame.origin.x+_propLabel.frame.size.height+5, FOOT_BUTTON_WIDTH, 40)];
    self.minHeight=_favoriteButton.frame.origin.y+_favoriteButton.frame.size.height+5;
    
    [_favoriteButton setFrame:CGRectMake(30, height+5, FOOT_BUTTON_WIDTH, 40)];
    [_cartButton setFrame:CGRectMake(170, height+5, FOOT_BUTTON_WIDTH, 40)];
    self.maxHeight=_favoriteButton.frame.origin.y+_favoriteButton.frame.size.height+5;
    
    if(self.expand==0)
    {
        [_favoriteButton setFrame:CGRectMake(30, _propLabel.frame.origin.x+_propLabel.frame.size.height+5, FOOT_BUTTON_WIDTH, 40)];
        [_cartButton setFrame:CGRectMake(170, _propLabel.frame.origin.x+_propLabel.frame.size.height+5, FOOT_BUTTON_WIDTH, 40)];
    }
    else
    {
        [_favoriteButton setFrame:CGRectMake(30, height+5, FOOT_BUTTON_WIDTH, 40)];
        [_cartButton setFrame:CGRectMake(170, height+5, FOOT_BUTTON_WIDTH, 40)];
    }
}

-(float)getCellHeight
{
    if(self.expand==0)
    {
        return self.minHeight-40;
    }
    else
    {
        return self.maxHeight-40;
    }
}

-(int)getStockNum
{
    int stockNum=0;
    NSString *prop2Name=[_data objectForKey:@"prop2Name"];
    if (prop2Name!=nil&&[prop2Name length]>0)
    {
        NSArray *propList1=[_data objectForKey:@"propList1"];
        NSArray *propList2=[[propList1 objectAtIndex:self.x] objectForKey:@"propList2"];
        NSDictionary *data=[propList2 objectAtIndex:self.y];
        stockNum=[[data objectForKey:@"stockNum"]intValue];
    }
    else
    {
        NSArray *propList1=[_data objectForKey:@"propList1"];
        NSDictionary *data=[propList1 objectAtIndex:self.x];
        stockNum=[[data objectForKey:@"stockNum"]intValue];
    }

    return stockNum;
}

-(long)getItemId
{
    long itemId=0;
    NSString *prop2Name=[_data objectForKey:@"prop2Name"];
    if (prop2Name!=nil&&[prop2Name length]>0)
    {
        NSArray *propList1=[_data objectForKey:@"propList1"];
        NSArray *propList2=[[propList1 objectAtIndex:self.x] objectForKey:@"propList2"];
        NSDictionary *data=[propList2 objectAtIndex:self.y];
        itemId=[[data objectForKey:KEY_ITEMID]longValue];
    }
    else
    {
        NSArray *propList1=[_data objectForKey:@"propList1"];
        NSDictionary *data=[propList1 objectAtIndex:self.x];
        itemId=[[data objectForKey:KEY_ITEMID]longValue];
    }
    
    return itemId;
}

-(void)getXY
{
    self.x=0;
    self.y=0;
    NSArray *propList1=[_data objectForKey:@"propList1"];
    for (int i=0; i<[propList1 count]; i++)
    {
        NSDictionary *item=[propList1 objectAtIndex:i];
        if ([item objectForKey:@"itemId"]!=nil&&[[item objectForKey:@"itemId"]longValue]==[[_data objectForKey:@"itemId"]longValue])
        {
            self.x=i;
            self.y=0;
            return;
        }
        
        NSArray *propList2=[[propList1 objectAtIndex:i] objectForKey:@"propList2"];
        for (int j=0; j<[propList2 count]; j++)
        {
            NSDictionary *item=[propList2 objectAtIndex:j];
            if ([item objectForKey:@"itemId"]!=nil&&[[item objectForKey:@"itemId"]longValue]==[[_data objectForKey:@"itemId"]longValue])
            {
                self.x=i;
                self.y=j;
                return;
            }
        }
    }
}

-(long)getExpand
{
    return self.expand;
}

@end
