//
//  MsgViewController.m
//  occ
//
//  Created by RS on 13-9-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgCell.h"

@interface MsgViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation MsgViewController

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView==_header)
    {
        self.page=1;
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(loadDataList) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(loadDataList) userInfo:nil repeats:NO];
    }
}

#pragma mark -
#pragma mark 关于键盘的大小改变
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyBoardWillShow:)
                                                name:@"UIKeyboardWillShowNotification"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyBoardWillHide)
                                                name:@"UIKeyboardWillHideNotification"
                                              object:nil];
}

- (void)refreshAllDownFrame:(BOOL)isEdit
{
    //调整下面的整个输入框坐标(计算出的是键盘收起时的坐标状态)
    CGRect viewRect = _sendView.frame;
    viewRect.size.height =  _msgField.frame.size.height + 10;
    if (isEdit)
    {
        //当正在处于输入状态下,要减去键盘高度
        viewRect.origin.y = SCREEN_HEIGHT - viewRect.size.height - _keyBoardSize.height;//键盘弹出时的坐标
    }
    else
    {
        viewRect.origin.y = SCREEN_HEIGHT - viewRect.size.height;//键盘收起时的坐标
    }
    _sendBackgroundView.frame = _msgField.frame;
    _sendView.frame = viewRect;
}

- (void)initSendView
{
    _sendView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    _sendView.backgroundColor = COLOR_BG_CLASSTHREE;
    
    _msgField = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(15 + HEADER_HEIGHT, 6, 250, 35)];//180
    [_msgField.layer setCornerRadius:3];
    [_msgField.layer setMasksToBounds:YES];
    [_msgField setUserInteractionEnabled:YES];
    _msgField.delegate = self;
    _msgField.minNumberOfLines = 1;
    _msgField.maxNumberOfLines = 4;
    _msgField.font = FONT_14;
    _msgField.returnKeyType = UIReturnKeySend;
    _msgField.backgroundColor = COLOR_FFFFFF;
    
    UIView *leftButton = [CommonMethods toolBarButtonWithTarget:self
                                                    andSelector:@selector(showKeyboard:)
                                                  andButtonType:OCCToolBarButtonTypeKeyboard andLeft:YES];
//    UIView *rightButton = [CommonMethods toolBarButtonWithTarget:self
//                                                     andSelector:@selector(showEmojiView:)
//                                                   andButtonType:OCCToolBarButtonTypeAdd andLeft:NO];
//    UIView *emojiBtn = [CommonMethods toolBarButtonWithTarget:self
//                                                     andSelector:@selector(addButtonClicked:)
//                                                   andButtonType:OCCToolBarButtonTypeEmoji andLeft:NO];
//    CGRect selfRect = emojiBtn.frame;
//    selfRect.origin.x = selfRect.origin.x - HEADER_HEIGHT;
//    emojiBtn.frame = selfRect;
    [_sendView addSubview:leftButton];
//    [_sendView addSubview:rightButton];
//    [_sendView addSubview:emojiBtn];
    [_sendView addSubview:_msgField];
    [self.view addSubview:_sendView];
    [self addNotification];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_dataList==nil)
    {
        _dataList =[[NSMutableArray alloc]init];
    }
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[_data objectForKey:@"sender"]];
    [titleLable setFrame:CGRectMake(60,0, SCREEN_WIDTH-120, HEADER_HEIGHT)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    //UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doMore:) andButtonType:OCCNavigationButtonTypeMore andLeft:NO];
    //[topImageView addSubview:rightButton];
    
    UITableView *tableView=[[UITableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-2*HEADER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.backgroundColor=[UIColor clearColor];
    _header.scrollView = self.tableView;
    
    // 上拉加载
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.backgroundColor=[UIColor clearColor];
    _footer.scrollView = self.tableView;
    _footer.hidden=YES;
    
    [self addNotification];
    [self initSendView];
    _page = 0;
    [self loadDataList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_header free];
    [_footer free];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doMore:(id)sender
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)showKeyboard:(id)sender
{
    BOOL isFirstRes = [_msgField isFirstResponder];
    if (isFirstRes)
    {
        [_msgField resignFirstResponder];
    }
    else
    {
        [_msgField becomeFirstResponder];
    }
}

- (void)showEmojiView:(id)sender
{
    
}

- (void)addButtonClicked:(id)sender
{
    
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index=indexPath.row;
    NSDictionary *data = [_dataList objectAtIndex:index];
    return [MsgCell getCellHeight:data andType:[self getMsgFormatType:index]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MsgCellIdentifier=@"MsgCellIdentifier";
    
    MsgCell *cell = (MsgCell*)[tableView dequeueReusableCellWithIdentifier:MsgCellIdentifier];
    if (cell == nil)
    {
        cell = [[MsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MsgCellIdentifier];
    }

    int index=indexPath.row;
    NSDictionary *data = [_dataList objectAtIndex:index];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setType:[self getMsgFormatType:index]];
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[_msgField resignFirstResponder];
}

#pragma mark -
#pragma mark HPGrowingTextViewDelegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    return YES;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)aText
{
    if ([aText isEqualToString:@"\n"])
    {
        //直接发送出去
        [self sendData:[NSString stringWithFormat:@"%@",_msgField.text]];
        _msgField.text = @"";
        return NO;
    }
    return YES;
}

//HPGrowingTextView高度高度发生变化是 调用的方法
- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    [self refreshAllDownFrame:YES];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark 关于键盘的show和hide
- (void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary * info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyBoardSize = kbSize;//保存好键盘大小
    
    //控制底部View的位置
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [self refreshAllDownFrame:YES];
    [UIView commitAnimations];
    
    CGRect selfRect = _tableView.frame;
    selfRect.size.height = _sendView.frame.origin.y - HEADER_HEIGHT;
    _tableView.frame = selfRect;
    if ([_dataList count]>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataList count]-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:NO];
    }
}

- (void)keyBoardWillHide
{
    //键盘消失  重置数据
    _keyBoardSize = CGSizeZero;
    //重新控制底部View的位置
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [self refreshAllDownFrame:NO];
    [UIView commitAnimations];
    
    CGRect selfRect = _tableView.frame;
    selfRect.size.height = _sendView.frame.origin.y - HEADER_HEIGHT;
    _tableView.frame = selfRect;
    if ([_dataList count]>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataList count]-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:NO];
    }
}

#pragma mark -
#pragma mark - Your actions
- (void)sendData:(NSString *)text
{
    if ([text length] == 0)
    {
        [CommonMethods showAutoDismissView:@"请输入内容" inView:self.view];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  text,@"content",
                                                  [_data objectForKey:KEY_SHOPID],KEY_SHOPID,
                                                  [_data objectForKey:@"type"],@"type",
                                                  [_data objectForKey:@"objectId"],@"objectId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:sendMessage_URL andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showErrorDialog:@"网络异常,请检查您的网络设置!" inView:self.view];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                                              [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                              NSString *date=[dateFormatter stringFromDate:[NSDate new]];
                                              
                                              NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:
                                                                  text,@"content",
                                                                  date,@"createDate",
                                                                  @"",@"id",
                                                                  [[Singleton sharedInstance]userName],@"sender",
                                                                  @"0",@"type",
                                                                  nil];
                                              [_dataList addObject:data];
                                              [self.tableView reloadData];
                                              NSIndexPath * indexPath=[NSIndexPath indexPathForRow:_dataList.count-1 inSection:0];
                                              [_tableView scrollToRowAtIndexPath:indexPath
                                                                atScrollPosition:UITableViewScrollPositionBottom
                                                                        animated:NO];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)loadDataList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [NSNumber numberWithInt:self.page+1],@"page",
                                                  [_data objectForKey:@"shopId"],@"shopId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadMessage_URL andData:reqdata andDelegate:nil];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods hideWaitView];
                                          [_header endRefreshing];
                                          [_footer endRefreshing];
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
                                              [CommonMethods showErrorDialog:@"网络异常,请检查您的网络设置!" inView:self.view];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              NSArray *dataList=[data objectForKey:@"messageList"];
                                              if ([dataList count]==0 || dataList.count<PAGE_SIZE) {
                                                  _header.hidden=YES;
                                              }
                                              
                                              self.page++;
                                              if (self.page==1) {
                                                  NSArray* reversedDataList = [[dataList reverseObjectEnumerator] allObjects];
                                                  _dataList=[NSMutableArray arrayWithArray:reversedDataList];
                                              }else{
                                                  NSArray *tmpDataList=[NSArray arrayWithArray:_dataList];
                                                  NSArray* reversedDataList = [[dataList reverseObjectEnumerator] allObjects];
                                                  _dataList=[NSMutableArray arrayWithArray:reversedDataList];
                                                  [_dataList addObjectsFromArray:tmpDataList];
                                              }
                                              [self.tableView reloadData];
                                              if ([_dataList count]>0 && self.page==1)
                                              {
                                                  NSIndexPath * indexPath=[NSIndexPath indexPathForRow:[_dataList count]-1 inSection:0];
                                                  [_tableView scrollToRowAtIndexPath:indexPath
                                                                    atScrollPosition:UITableViewScrollPositionBottom
                                                                            animated:NO];
                                              }
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showErrorDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (MsgFormatType)getMsgFormatType:(int)index
{
    NSDictionary *current=[self.dataList objectAtIndex:index];
    NSDictionary *last=(index-1)>=0&&(index-1)<self.dataList.count?[self.dataList objectAtIndex:index-1]:nil;
    if (last!=nil) {
        if ([[last objectForKey:@"type"]intValue]!=[[current objectForKey:@"type"]intValue]) {
            last=nil;
        }
    }
    NSDictionary *next=(index+1)>=0&&(index+1)<self.dataList.count?[self.dataList objectAtIndex:index+1]:nil;
    if (next!=nil) {
        if ([[next objectForKey:@"type"]intValue]!=[[current objectForKey:@"type"]intValue]) {
            next=nil;
        }
    }
    
    if (last==nil)
    {
        if (next==nil)
        {
            return MsgFormatType2;
        }
        else
        {
            return MsgFormatType1;
        }
    }
    else if(next==nil)
    {
        return MsgFormatType6;
    }
    else
    {
        return MsgFormatType5;
    }
}

@end
