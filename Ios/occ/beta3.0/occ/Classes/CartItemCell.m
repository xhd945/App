//
//  CartCell.m
//  occ
//
//  Created by RS on 13-8-5.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "CartItemCell.h"
#import "BusinessManager.h"
#import "UserManager.h"

#define kLeftImageWidth 70
#define kNameLaberWidth 120
#define kBtnWidth 35

@implementation CartItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView =[[UIImageView alloc]init];
        [self.contentView addSubview:_lineImageView];
        
        _leftImageView=[[UIImageView alloc]init];
        //_leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_leftImageView];
        
        UIImage *typeImage = [UIImage imageNamed:@"groupon_bg_list"];
        _typeImageView=[[UIImageView alloc]init];
        _typeImageView.image=typeImage;
        _typeImageView.frame=CGRectMake(kLeftImageWidth - typeImage.size.width, 0, typeImage.size.width, typeImage.size.height);
        _typeImageView.backgroundColor = [UIColor clearColor];
        [_leftImageView addSubview:_typeImageView];
        
        _checkButton =[[UIButton alloc]init];
        [_checkButton addTarget:self action:@selector(doCheck:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkButton];
        
        _checkImageView=[[UIButton alloc]init];
        [self.contentView addSubview:_checkImageView];
        
        _favorateButton=[[UIButton alloc]init];
        [_favorateButton addTarget:self action:@selector(addItemtoFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_favorateButton];
        
        _deleteButton=[[UIButton alloc]init];
        [_deleteButton addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];
        
        _plusButton=[[UIButton alloc]init];
        [_plusButton addTarget:self action:@selector(doPlus:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_plusButton];
        
        _minusButton=[[UIButton alloc]init];
        [_minusButton addTarget:self action:@selector(doMinus:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_minusButton];
        
        _nameLabel=[[UILabel alloc]init];
        [self.contentView addSubview:_nameLabel];
        
        _priceLabel=[[UILabel alloc]init];
        [self.contentView addSubview:_priceLabel];
        
        _oldPriceLabel=[[OCCStrikeThroughLabel alloc]init];
        [self.contentView addSubview:_oldPriceLabel];
        
        _numLabel=[[UILabel alloc]init];
        [self.contentView addSubview:_numLabel];
        
        _countButton=[[UIButton alloc]init];
        [self.contentView addSubview:_countButton];
        
        _bargainLabel=[[UILabel alloc]init];
        self.bargainLabel.numberOfLines=0;
        [_bargainLabel setTextColor:COLOR_453D3A];
        [_bargainLabel setHighlightedTextColor:COLOR_453D3A];
        [self.bargainLabel setBackgroundColor:[UIColor clearColor]];
        self.bargainLabel.font = FONT_12;
        [self.contentView addSubview:_bargainLabel];
        
        UIView *accessView=[[UIView alloc]init];
        accessView.frame=CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT);
        accessView.alpha=0.5;
        
        UIToolbar * inputView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        [inputView setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(doCancel:)];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doConfirm:)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:cancelButton,btnSpace,doneButton,nil];
        [inputView setItems:buttonsArray];
        
        _countTextfield = [[UITextField alloc] initWithFrame:CGRectMake(120.0f, 80.0f, 150.0f, 30.0f)];
        [_countTextfield setBorderStyle:UITextBorderStyleNone];
        _countTextfield.placeholder = @"";
        _countTextfield.secureTextEntry = NO;
        _countTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        _countTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _countTextfield.returnKeyType = UIReturnKeyDone;
        _countTextfield.clearButtonMode = UITextFieldViewModeNever;
        _countTextfield.keyboardType=UIKeyboardTypeNumberPad;
        _countTextfield.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        _countTextfield.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        _countTextfield.textAlignment = UITextAlignmentCenter;
        _countTextfield.backgroundColor=COLOR_BEBEBE;
        _countTextfield.inputAccessoryView=inputView;
        _countTextfield.delegate = self;
        _countTextfield.layer.cornerRadius=5.0;
        _countTextfield.layer.masksToBounds=YES;
        _countTextfield.font=FONT_22;
        _countTextfield.textColor=COLOR_D91F1E;
        [self.contentView addSubview:_countTextfield];
        
        UIImage *image=[UIImage imageNamed:@"list_bgwhite2_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height-10];
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [self setBackgroundView:backgroundView];
        [backgroundView setImage:image];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        [self setSelectedBackgroundView:selectedBackgroundView];
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

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    [_lineImageView setFrame:CGRectMake(10, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-20, 1)];
    [_lineImageView setImage:[UIImage imageNamed:@"line3"]];
    [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line3"]];
    
    //调整位置
    //图片的中心
    //CGRect selfRect = self.checkButton.frame;
    CGRect selfRect = CGRectMake(0, 0, 0, 0);
    selfRect.origin = CGPointMake(0, 0);
    selfRect.size = CGSizeMake(10+10+22, 100);
    self.checkButton.frame = selfRect;
    
    selfRect = self.leftImageView.frame;
    selfRect.origin = CGPointMake(self.checkButton.frame.origin.x + self.checkButton.frame.size.width, 10);
    selfRect.size = CGSizeMake(kLeftImageWidth, kLeftImageWidth);
    self.leftImageView.frame = selfRect;
    
    [self.nameLabel sizeToFit];
    selfRect = self.nameLabel.frame;
    selfRect.origin = CGPointMake(self.leftImageView.frame.origin.x + self.leftImageView.frame.size.width+5, self.leftImageView.frame.origin.y);
    //selfRect.size = CGSizeMake(kNameLaberWidth, 40);
    self.nameLabel.frame = selfRect;
    
    self.oldPriceLabel.frame=CGRectMake(self.oldPriceLabel.frame.origin.x, self.leftImageView.frame.origin.y, self.oldPriceLabel.frame.size.width, self.oldPriceLabel.frame.size.height);
    
    //调整按钮
    CGFloat OperationX = self.frame.size.width - 10*3;
    UIImage *btnBGImage = [UIImage imageNamed:@"btn_bg_light_gray"];
    UIImage *stretchImage = [btnBGImage stretchableImageWithLeftCapWidth:btnBGImage.size.width/2 topCapHeight:btnBGImage.size.height/2];
    self.favorateButton.titleLabel.font = FONT_10;
    [self.favorateButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [self.favorateButton setTitleColor:COLOR_FFFFFF forState:UIControlStateHighlighted];
    self.favorateButton.titleLabel.numberOfLines = 2;
    self.favorateButton.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    [self.favorateButton setBackgroundImage:stretchImage forState:UIControlStateNormal];
    [self.favorateButton setImage:[UIImage imageNamed:@"icon_favorite_rgray"] forState:UIControlStateNormal];
    //[self.favorateButton setTitle:@"移入\n收藏夹" forState:UIControlStateNormal];
    //[self.favorateButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5,0,0)];
    //[self.favorateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5,0,0)];
    self.favorateButton.frame = CGRectMake(OperationX - 100+25, 5, kBtnWidth, kBtnWidth);
    
    [self.deleteButton setTitle:nil forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:stretchImage forState:UIControlStateNormal];
    self.deleteButton.frame = CGRectMake(OperationX - kBtnWidth, 5, kBtnWidth, kBtnWidth);
    
    [self.minusButton setTitle:nil forState:UIControlStateNormal];
    [self.minusButton setImage:[UIImage imageNamed:@"reduce.png"] forState:UIControlStateNormal];
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg1_left"] forState:UIControlStateNormal];
    
    [self.plusButton setTitle:nil forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [self.plusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg3_right"] forState:UIControlStateNormal];
    self.plusButton.frame = CGRectMake(OperationX - kBtnWidth, 10 + kBtnWidth + 10/2, kBtnWidth, kBtnWidth);
    self.minusButton.frame = CGRectMake(OperationX - 100, 10 + kBtnWidth + 10/2, kBtnWidth, kBtnWidth);
    
    self.countButton.userInteractionEnabled = NO;
    self.countButton.frame = CGRectMake(OperationX - 100 + kBtnWidth, 10 + kBtnWidth + 10/2, 100 - kBtnWidth*2, kBtnWidth);
    [self.countButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    self.countButton.titleLabel.font = FONT_14;
    [self.countButton setBackgroundImage:[UIImage imageNamed:@"btn_bg2_mid"] forState:UIControlStateNormal];
    
    self.countTextfield.frame = CGRectMake(self.favorateButton.frame.origin.x,
                                           self.favorateButton.frame.origin.y+self.favorateButton.frame.size.height+10,
                                           kBtnWidth*2+5,
                                           kBtnWidth);
    
    float height=[CommonMethods heightForString:_bargainLabel.text andFont:_bargainLabel.font andWidth:kBargainLabelWidth-30];
    self.bargainLabel.frame=CGRectMake(self.leftImageView.frame.origin.x, self.leftImageView.frame.origin.y+self.leftImageView.frame.size.height+10, kBargainLabelWidth-30, height);
    [self.bargainLabel sizeToFit];
}

- (void)addItemtoFavorite:(id)sender
{
    int type= [[_data objectForKey:@"type"]integerValue];
    if (type==1)
    {
        [CommonMethods showTextDialog:@"抱歉,不能收藏团购商品" inView:nil];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj = [NSMutableDictionary dictionaryWithCapacity:2];
                       [obj setObject:[NSNumber numberWithInt:[[Singleton sharedInstance]mall]] forKey:@"mall"];
                       [obj setObject:[[Singleton sharedInstance] TGC] forKey:KEY_TGC];
                       [obj setObject:[_data objectForKey:KEY_ID] forKey:KEY_ID];
                       [obj setObject:[_data objectForKey:KEY_ITEMNAME] forKey:KEY_NAME];
                       [obj setObject:[NSNumber numberWithInteger:OCCSearchClassiFicationItem] forKey:KEY_CATEGORY];
                       [obj setObject:[NSNumber numberWithInteger:OCCFavoriteFromCart] forKey:KEY_FROMTYPE];
                       [obj setObject:[NSNumber numberWithInt:self.cartId] forKey:KEY_CARTID];
                       
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
                                              //[CommonMethods showSuccessDialog:@"收藏商品成功" inView:nil];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"addItemToFavoriteSuccessNotification" object:nil];
                                              
                                              [_favorateButton setImage:[UIImage imageNamed:@"icon_favorite_red"] forState:UIControlStateNormal];
                                              
                                              NSMutableArray *shopList = [[[Singleton sharedInstance]cartData]objectForKey:@"shopList"];
                                              for (NSMutableDictionary *shop in shopList) {
                                                  NSMutableArray *itemList = [shop objectForKey:@"itemList"];
                                                  for (NSMutableDictionary *item in itemList)
                                                  {
                                                      int xx=[[item objectForKey:@"id"]intValue];
                                                      int yy=[[_data objectForKey:@"id"]intValue];
                                                      if (xx==yy)
                                                      {
                                                          [itemList removeObject:item];
                                                          if ([itemList count]==0)
                                                          {
                                                              [shopList removeObject:shop];
                                                          }
                                                          [_delegate cartCellDidChange];
                                                          return;
                                                      }
                                                  }
                                              }
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

- (void)doDelete:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                  ^{
                      NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                 [[Singleton sharedInstance]TGC], @"TGC",
                                                 [NSNumber numberWithInt:self.cartId], @"cartId",
                                                 [NSNumber numberWithInt:self.shopId], @"shopId",
                                                 [_data objectForKey:@"id"], @"itemId",
                                                 [_data objectForKey:@"type"], @"type",
                                                 nil];
                      
                      NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                      
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                     });
                      
                      ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:deleteItem_URL andData:reqdata andDelegate:nil];
                      
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
                      if (root!=nil && [[root objectForKey:@"code"]intValue]==0)
                      {
                          dispatch_async(dispatch_get_main_queue(),
                                         ^{
                                             //[CommonMethods showSuccessDialog:@"删除商品成功" inView:nil];
                                             
                                             NSMutableArray *shopList = [[[Singleton sharedInstance]cartData]objectForKey:@"shopList"];
                                             for (NSMutableDictionary *shop in shopList) {
                                                 NSMutableArray *itemList = [shop objectForKey:@"itemList"];
                                                 for (NSMutableDictionary *item in itemList)
                                                 {
                                                     int xx=[[item objectForKey:@"id"]intValue];
                                                     int yy=[[_data objectForKey:@"id"]intValue];
                                                     if (xx==yy)
                                                     {
                                                         [itemList removeObject:item];
                                                         if ([itemList count]==0)
                                                         {
                                                             [shopList removeObject:shop];
                                                         }
                                                         [_delegate cartCellDidChange];
                                                         return;
                                                     }
                                                 }
                                             }
                                         });
                      }
                  });
}

- (void)doCancel:(id)sender
{
    [self.countTextfield resignFirstResponder];
    _countTextfield.text=[NSString stringWithFormat:@"%@",[_data objectForKey:@"buyNum"]];
}

- (void)doConfirm:(id)sender
{
    int num=[_countTextfield.text intValue];
    if (num<=1)
    {
        num=1;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [NSNumber numberWithInt:self.cartId], @"cartId",
                                                  [NSNumber numberWithInt:self.shopId], @"shopId",
                                                  [_data objectForKey:@"id"], @"itemId",
                                                  [_data objectForKey:@"type"], @"type",
                                                  [NSNumber numberWithInt:num], @"itemNum",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:changeItemNum_URL andData:reqdata andDelegate:nil];
                       
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
                                              NSString *str=[NSString stringWithFormat:@"%d",num];
                                              [_numLabel setText:str];
                                              [_data setObject:str forKey:@"buyNum"];
                                              [_delegate cartCellPlusMInus:_data];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:nil];
                                          });
                       }
                   });
}

- (void)doPlus:(id)sender
{
    int num=[[_data objectForKey:@"buyNum"]intValue];
    num++;
    if (num<=1) {
        num=1;
    }
    
    NSString *str=[NSString stringWithFormat:@"%d",num];
    [_numLabel setText:str];
    [_data setObject:str forKey:@"buyNum"];
    [_delegate cartCellPlusMInus:_data];
}

- (void)doMinus:(id)sender
{
    int num=[[_data objectForKey:@"buyNum"]intValue];
    num--;
    if (num<=1)
    {
        num=1;
    }
    
    NSString *str=[NSString stringWithFormat:@"%d",num];
    [_numLabel setText:str];
    [_data setObject:str forKey:@"buyNum"];
    [_delegate cartCellPlusMInus:_data];
}

- (void)doCheck:(id)sender
{
    if ([[_data objectForKey:@"check"]boolValue]) {
        [_data setObject:[NSNumber numberWithBool:NO] forKey:@"check"];
    }else{
        [_data setObject:[NSNumber numberWithBool:YES] forKey:@"check"];
    }
    
    [_delegate cartCellDidChange];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableView *tableView = (UITableView *)self.superview;
    if (![tableView isKindOfClass:[UITableView class]]) tableView = (UITableView *)tableView.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return YES;
}

-(void)setData:(NSMutableDictionary*)data
{
    _data =data;
    
    NSString *strURL  = [[data objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.leftImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    if ([[data objectForKey:@"type"]intValue]==1)
    {
        self.typeImageView.hidden=NO;
    }
    else
    {
        self.typeImageView.hidden=YES;
    }
    
    [_nameLabel setTextColor:COLOR_453D3A];
    [_nameLabel setHighlightedTextColor:COLOR_453D3A];
    [_nameLabel setFont:FONT_14];
    NSString *itemName=[data objectForKey:@"itemName"];
    [_nameLabel setText:itemName];
    
    CGSize labelSize = [itemName sizeWithFont:_nameLabel.font
                                     forWidth:kNameLaberWidth
                                lineBreakMode:UILineBreakModeCharacterWrap];
    [_nameLabel setNumberOfLines:2];
    _nameLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    CGRect selfRect = _nameLabel.frame;
    selfRect.size = CGSizeMake(labelSize.width, labelSize.height);
    _nameLabel.frame = selfRect;
    
    [_priceLabel setTextColor:COLOR_D91F1E];
    [_priceLabel setHighlightedTextColor:COLOR_D91F1E];
    NSString *plPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"plPrice"]];
    [_priceLabel setText:plPrice];
    
    [_oldPriceLabel setTextColor:[UIColor grayColor]];
    _oldPriceLabel.font = FONT_12;
    [_oldPriceLabel setHighlightedTextColor:COLOR_453D3A];
    NSString *listPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"listPrice"]];
    [_oldPriceLabel setText:listPrice];
    
    _numLabel.font = FONT_16;
    [_numLabel setTextColor:COLOR_D91F1E];
    [_numLabel setHighlightedTextColor:COLOR_D91F1E];
    NSString *num=[NSString stringWithFormat:@"数量:%@",[data objectForKey:@"buyNum"]];
    [_numLabel setText:num];
    [_countButton setTitle:[NSString stringWithFormat:@"%@",[data objectForKey:@"buyNum"]] forState:UIControlStateNormal];
    
    if ([[_data objectForKey:@"check"]boolValue]) {
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_press.png"] forState:UIControlStateNormal];
    }else{
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_nor.png"] forState:UIControlStateNormal];
    }
    
    CGFloat OperationViewWidth = 110;
    if ([[_data objectForKey:@"edit"]boolValue]) {
        _favorateButton.hidden=NO;
        _deleteButton.hidden=NO;
        _minusButton.hidden=NO;
        _plusButton.hidden=NO;
        _countButton.hidden=NO;
        _nameLabel.hidden=YES;
        _countTextfield.hidden=NO;
        _minusButton.hidden=YES;
        _plusButton.hidden=YES;
        _countButton.hidden=YES;
    }else{
        _favorateButton.hidden=YES;
        _deleteButton.hidden=YES;
        _minusButton.hidden=YES;
        _plusButton.hidden=YES;
        _countButton.hidden=YES;
        _nameLabel.hidden=NO;
        OperationViewWidth = 0;
        _countTextfield.hidden=YES;
    }
    
    CGFloat pointY = 12.0;
    labelSize = [listPrice sizeWithFont:_oldPriceLabel.font];
    selfRect = _oldPriceLabel.frame;
    selfRect.size = CGSizeMake(labelSize.width, labelSize.height);
    selfRect.origin = CGPointMake(self.frame.size.width - 10*3 - OperationViewWidth - labelSize.width, pointY);
    _oldPriceLabel.frame = selfRect;
    pointY += labelSize.height - 3;
    
    labelSize = [plPrice sizeWithFont:_priceLabel.font];
    selfRect = _priceLabel.frame;
    selfRect.size = CGSizeMake(labelSize.width, labelSize.height);
    selfRect.origin = CGPointMake(self.frame.size.width - 10*3 - OperationViewWidth - labelSize.width, pointY);
    _priceLabel.frame = selfRect;
    pointY += labelSize.height + 3;
    
    labelSize = [num sizeWithFont:_numLabel.font];
    selfRect = _numLabel.frame;
    selfRect.size = CGSizeMake(labelSize.width, labelSize.height);
    selfRect.origin = CGPointMake(self.frame.size.width - 10*3 - OperationViewWidth- labelSize.width, pointY);
    _numLabel.frame = selfRect;
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSMutableArray *itemBargainList=[data objectForKey:@"itemBargainList"];
    for (int i=0; i<[itemBargainList count]; i++) {
        NSDictionary *item=[itemBargainList objectAtIndex:i];
        if ([[item objectForKey:@"name"] isKindOfClass:[NSString class]]){
            [arr addObject:[item objectForKey:@"name"]];
        }
    }
    
    NSString *text=[arr componentsJoinedByString:@"\n"];
    [_bargainLabel setText:text];
    
    _countTextfield.text=[NSString stringWithFormat:@"%@",[_data objectForKey:@"buyNum"]];
}

@end
