//
//  BindPhoneViewController.m
//  occ
//
//  Created by RS on 13-9-4.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "OCCFieldCell.h"

@interface BindPhoneViewController ()

@end

@implementation BindPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    OCCFieldCell *passwordCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [passwordCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    passwordCell.field.delegate=self;
    id mobile=[[Singleton sharedInstance] userMobile];
    if (mobile==[NSNull null])
    {
        passwordCell.field.placeholder = @"请输入您的手机号码";
    }
    else
    {
        passwordCell.field.text=[[Singleton sharedInstance] userMobile];
    }
    
    OCCFieldCell *passwordCell1 = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [passwordCell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
	passwordCell1.field.placeholder = @"请输入短信验证码";
    passwordCell1.field.delegate=self;
	
    _dataList = [[NSMutableArray alloc]initWithObjects:passwordCell,passwordCell1, nil];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"修改手机号码"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doConfirm:) andButtonType:OCCNavigationButtonTypeCheck andLeft:NO];
    [headView addSubview:rightButton];
    
    //===================================
    UIView *tableFooterView = [[UIView alloc]init];
    [tableFooterView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    
    _getNoteBtn = [[UIButton alloc]init];
    [_getNoteBtn setFrame:CGRectMake(10, 10, 300, 44)];
    [_getNoteBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4, 0.0, 4)] forState:UIControlStateNormal];
    [_getNoteBtn addTarget:self action:@selector(getNote) forControlEvents:UIControlEventTouchUpInside];
    _getNoteBtn.titleLabel.font = FONT_16;
    [_getNoteBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [_getNoteBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [tableFooterView addSubview:_getNoteBtn];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:tableFooterView];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [self.tableView reloadData];
    
    _downup=0;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(handleTimer:)
                                                  userInfo:nil
                                                   repeats:YES];
}

-(void)getNote
{
    NSString *tel=_phoneTextField.text;
    if (tel ==nil || [tel length]<=0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请填写手机号码"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"\\b(1)[3458][0-9]{9}\\b" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatches1 = [regex1 numberOfMatchesInString:_phoneTextField.text options:0 range:NSMakeRange(0, [_phoneTextField.text length])];
    if(numberOfMatches1 !=1 )
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"手机号码格式不正确"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  _phoneTextField.text,@"mobile",
                                                  nil];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:registerMobileNo_URL andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showFailDialog:@"网络异常,请检查您的网络设置!" inView:self.view];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              _downup=12;
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(void)handleTimer:(NSTimer *)timer
{
    if (self.downup==0)
    {
        [_getNoteBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        _getNoteBtn.userInteractionEnabled=YES;
        _getNoteBtn.alpha=1;
    }
    else
    {
        _getNoteBtn.alpha=0.5;
        _getNoteBtn.userInteractionEnabled=NO;
        [_getNoteBtn setTitle:[NSString stringWithFormat:@"正在获取短信验证码(%d)",_downup--] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_myTimer!=nil)
    {
        [_myTimer invalidate];
        _myTimer=nil;
    }
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doConfirm:(id)sender
{
    [self hideKeyboard];
    NSString *tel=_phoneTextField.text;
    if (tel ==nil || [tel length]<=0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请填写手机号码"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSString *code=_codeTextField.text;
    if (code ==nil || [code length]<=0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入短信验证码"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"\\b(1)[3458][0-9]{9}\\b" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatches1 = [regex1 numberOfMatchesInString:_phoneTextField.text options:0 range:NSMakeRange(0, [_phoneTextField.text length])];
    if(numberOfMatches1 !=1 )
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"手机号码格式不正确"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  _phoneTextField.text,@"newMobile",
                                                  _codeTextField.text,@"code",
                                                  nil];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:modifyUserInfo_URL andData:reqdata andDelegate:nil];
                       
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
                                              [CommonMethods showFailDialog:@"网络异常,请检查您的网络设置!" inView:self.view];
                                          });
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root==nil){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:@"服务器异常,请重试!" inView:self.view];
                                          });
                       }else if ([[root objectForKey:@"code"]intValue]==0){
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showSuccessDialog:@"修改手机号码成功" inView:self.view];
                                              [[Singleton sharedInstance] setUserMobile:_phoneTextField.text];
                                              [self.delegate setPhone:_phoneTextField.text];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString * cellIdentifier = @"cell1";
            OCCLabelCell * cell1 = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell1)
            {
                cell1 = [[OCCLabelCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                cell1.selectionStyle  = UITableViewCellSelectionStyleNone;
                UIImageView *backgroundView=[[UIImageView alloc]init];
                [backgroundView setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
                [cell1 setBackgroundView:backgroundView];
                
                _phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, 10, 300, 24)];
                _phoneTextField.placeholder=@"请输入要修改的手机号";
                _phoneTextField.delegate=self;
                _phoneTextField.font = FONT_14;
                [cell1 addSubview:_phoneTextField];
            }
            return cell1;
        }
            break;
        case 1:
        {
            static NSString * cellIdentifier = @"cell2";
            OCCLabelCell * cell2 = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell2)
            {
                cell2 = [[OCCLabelCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                cell2.selectionStyle  = UITableViewCellSelectionStyleNone;
                UIImageView *backgroundView=[[UIImageView alloc]init];
                [backgroundView setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
                [cell2 setBackgroundView:backgroundView];
                
                _codeTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, 10, 300, 24)];
                _codeTextField.placeholder=@"请输入短信验证码";
                _codeTextField.delegate=self;
                _codeTextField.font = FONT_14;
                [cell2 addSubview:_codeTextField];
            }
            return cell2;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [_phoneTextField resignFirstResponder];
}

@end
