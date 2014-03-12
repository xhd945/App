//
//  RegisterViewController.m
//  occ
//
//  Created by RS on 13-8-8.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterCodeViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessNotification:)
                                                 name:@"loginSuccessNotification"
                                               object:nil];
    
    _pickerDataList = [[NSArray alloc]initWithObjects:
                       @"中国",
                       @"美国",
                       nil];
    _areaArr=[[NSArray alloc]initWithObjects:
              @"+86",
              @"+1",
              nil];
    _codeTextField.delegate=self;
    _telTextField.delegate=self;
    [_telTextField setKeyboardType:UIKeyboardTypePhonePad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"注册"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    _rightButton = [CommonMethods navigationButtonWithTitle:@"下一步" WithTarget:self andSelector:@selector(doNext:) andLeft:NO];
    [headView addSubview:_rightButton];
    
    UIView *segementView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT)];
    segementView.backgroundColor = COLOR_BG_CLASSONE;
    OCCSegement *segement = [[OCCSegement alloc] initWithFrame:CGRectMake(10, (HEADER_HEIGHT - 28)/2, SCREEN_WIDTH - 10*2, 28)
                                                          type:OCCSegementTypeDefaultThree
                                                 andTitleArray:[NSArray arrayWithObjects:@"手机注册",@"邮箱注册",nil]];
    segement.delegate = self;
    [segementView addSubview:segement];
    [self.view addSubview:segementView];
    
    UIView *tableViewFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    tableViewFooterView.backgroundColor=[UIColor clearColor];
    
    UIImageView *checkImgv1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 16, 16)];
    checkImgv1.image=[UIImage imageNamed:@"checkbox_press_green"];
    [tableViewFooterView addSubview:checkImgv1];
    
    UILabel *consentLabel1=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 80, 25)];
    consentLabel1.backgroundColor=[UIColor clearColor];
    consentLabel1.text=@"已阅读并同意";
    consentLabel1.font=FONT_12;
    consentLabel1.textColor=[UIColor grayColor];
    [tableViewFooterView addSubview:consentLabel1];
    
    UILabel *serviceLabel1=[[UILabel alloc]initWithFrame:CGRectMake(110, 5, 80, 25)];
    serviceLabel1.backgroundColor=[UIColor clearColor];
    serviceLabel1.text=@"服务协议";
    serviceLabel1.font=FONT_12;
    serviceLabel1.textColor=COLOR_27813A;
    serviceLabel1.userInteractionEnabled=YES;
    [tableViewFooterView addSubview:serviceLabel1];

    UIButton *serviceBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    serviceBtn1.frame=CGRectMake(0, 0, 80, 30);
    [serviceBtn1 addTarget:self action:@selector(doService) forControlEvents:UIControlEventTouchUpInside];
    [serviceLabel1 addSubview:serviceBtn1];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT+HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:tableViewFooterView];
    [self.view addSubview:_tableView];
    
    UIView *tableView1FooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    tableView1FooterView.backgroundColor=[UIColor clearColor];
    
    UIImageView *checkImgv=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 16, 16)];
    checkImgv.image=[UIImage imageNamed:@"checkbox_press_green"];
    [tableView1FooterView addSubview:checkImgv];
    
    UILabel *consentLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 80, 25)];
    consentLabel.backgroundColor=[UIColor clearColor];
    consentLabel.text=@"已阅读并同意";
    consentLabel.font=FONT_12;
    consentLabel.textColor=[UIColor grayColor];
    [tableView1FooterView addSubview:consentLabel];
    
    UILabel *serviceLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 5, 80, 25)];
    serviceLabel.backgroundColor=[UIColor clearColor];
    serviceLabel.text=@"服务协议";
    serviceLabel.font=FONT_12;
    serviceLabel.textColor=COLOR_27813A;
    serviceLabel.userInteractionEnabled=YES;
    [tableView1FooterView addSubview:serviceLabel];
    
    UIButton *serviceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    serviceBtn.frame=CGRectMake(0, 0, 80, 30);
    [serviceBtn addTarget:self action:@selector(doService) forControlEvents:UIControlEventTouchUpInside];
    [serviceLabel addSubview:serviceBtn];
    
    UILabel *isHiddenPWLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 5, 80, 25)];
    isHiddenPWLabel.backgroundColor=[UIColor clearColor];
    isHiddenPWLabel.text=@"显示密码";
    isHiddenPWLabel.font=FONT_12;
    [tableView1FooterView addSubview:isHiddenPWLabel];

    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(235, 5, 40, 25)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [tableView1FooterView addSubview:switchButton];
    
    _tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT+HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [_tableView1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView1 setDelegate:self];
    [_tableView1 setDataSource:self];
    [_tableView1 setBackgroundView:nil];
    [_tableView1 setBackgroundColor:[UIColor clearColor]];
    _tableView1.hidden=YES;
    [_tableView1 setTableFooterView:tableView1FooterView];
    [self.view addSubview:_tableView1];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 210)];
    _pickerView.delegate=self;
    _pickerView.showsSelectionIndicator=YES;
    [_tableView addSubview:_pickerView];
}

- (void)viewDidUnload
{
    [self setFirstCell:nil];
    [self setSecondCell:nil];
    [self setTableFootView:nil];
    [self setCodeTextField:nil];
    [self setTelTextField:nil];
    [self setHideTextField:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    //UITouch *touch = [[event allTouches]anyObject];
    //UIView *touchView=touch.view;
    [self hideKeyboard];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) loginSuccessNotification:(NSNotification*)notification
{
    [self doBack:nil];
}

- (void)doBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)doAction:(id)sender
{
    if (isAcion==YES)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _pickerView.frame=CGRectMake(0, SCREEN_HEIGHT-HEADER_HEIGHT, 320, 210);
        [UIView commitAnimations];
        [_phoneTextField resignFirstResponder];
        [_areaTextField resignFirstResponder];
        isAcion=NO;
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _pickerView.frame=CGRectMake(0, SCREEN_HEIGHT-210-HEADER_HEIGHT, 320, 210);
        [UIView commitAnimations];
        [_phoneTextField resignFirstResponder];
        [_areaTextField resignFirstResponder];
        isAcion=YES;
    }
}

-(void)doService
{
    ServiceViewController *viewController=[[ServiceViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
        [_passWordTextField resignFirstResponder];
        [_passWordTextField setSecureTextEntry:NO];
    }
    else
    {
        [_passWordTextField resignFirstResponder];
        [_passWordTextField setSecureTextEntry:YES];
    }
}

-(void)selectedSegementIndex:(NSInteger)index
{
    if (index==0)
    {
        _tableView1.hidden=YES;
        _tableView.hidden=NO;
        [(UIButton *)_rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else
    {
        _tableView.hidden=YES;
        _tableView1.hidden=NO;
        [(UIButton *)_rightButton setTitle:@"确认" forState:UIControlStateNormal];
    }
}

- (void)doNext:(id)sender
{
    [self hideKeyboard];
    
    if (_tableView.hidden==NO)
    {
        NSString *tel=_phoneTextField.text;
        if (tel ==nil || [tel length]<=0)
        {
            [self showTip:@"请填写手机号码"];
            return;
        }
        
        NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"\\b(1)[3458][0-9]{9}\\b" options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger numberOfMatches1 = [regex1 numberOfMatchesInString:_phoneTextField.text options:0 range:NSMakeRange(0, [_phoneTextField.text length])];
        if(numberOfMatches1 !=1 )
        {
            [self showTip:@"手机号码格式不正确"];
            return;
        }
        
        [self validateOpenSms];
    }
    else
    {
        NSString *email=_emailTextField.text;
        if (email ==nil || [email length]<=0)
        {
            [self showTip:@"请填写邮箱"];
            return;
        }
        
        NSString *password=_passWordTextField.text;
        if (password ==nil || [password length]<=0)
        {
            [self showTip:@"请填写注册密码"];
            return;
        }
        
        if ([password length]<6 || [password length]>20)
        {
            [self showTip:@"注册密码必须为6-20个大小写英文字母,符号或数字"];
            return;
        }

        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:_emailTextField.text options:0 range:NSMakeRange(0, [_emailTextField.text length])];
        if(numberOfMatches !=1 )
        {
            [self showTip:@"邮箱格式不正确"];
            return;
        }
        
        [self registerEmail];
    }
}

-(void)registerEmail
{
    [CommonMethods showWaitView:@"正在请求中,请稍候..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  _passWordTextField.text,@"pwd",
                                                  _emailTextField.text,@"email",
                                                  nil];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       NSString *str=[NSString stringWithFormat:@"%@/userWeb/userMobileCenter/register.htm",OCC_IP];
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:str andData:reqdata andDelegate:nil];
                       
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
                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                              message:@"邮箱注册成功"
                                                                                             delegate:self
                                                                                    cancelButtonTitle:@"确定"
                                                                                    otherButtonTitles:nil];
                                              
                                              [alert show];
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

-(void)validateOpenSms
{
    [CommonMethods showWaitView:@"正在请求中,请稍候..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  _phoneTextField.text,@"mobile",
                                                  nil];
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:validateOpenSms_URL andData:reqdata andDelegate:nil];
                       
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
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              int type=[[data objectForKey:@"type"]intValue];
                                              if (type==0)
                                              {
                                                  RegisterSetPassWordViewController *viewController=[[RegisterSetPassWordViewController alloc]init];
                                                  viewController.phoneStr=_phoneTextField.text;
                                                  viewController.codeStr=@"1234";
                                                  [self.navigationController pushViewController:viewController animated:YES];
                                              }
                                              else
                                              {
                                                  RegisterCodeViewController *viewController=[[RegisterCodeViewController alloc]init];
                                                  viewController.phoneStr=_phoneTextField.text;
                                                  viewController.areaStr=_areaNumberLabel.text;
                                                  [self.navigationController pushViewController:viewController animated:YES];
                                              }
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _pickerView.frame=CGRectMake(0, SCREEN_HEIGHT-HEADER_HEIGHT, 320, 210);
    [UIView commitAnimations];
    isAcion=NO;
    return YES;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *dataStr=[_pickerDataList objectAtIndex:row];
    NSString *areaStr=[_areaArr objectAtIndex:row];
    _arealabel.text=[NSString stringWithFormat:@"%@ %@",dataStr,areaStr];
    _areaNumberLabel.text=areaStr;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableVieww cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView==tableVieww)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                static NSString * cellIdentifier = @"cell1";
                
                OCCLabelCell * cell1 = [_tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell1)
                {
                    cell1 = [[OCCLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell1.selectionStyle  = UITableViewCellSelectionStyleNone;
                    UIImageView *backgroundView=[[UIImageView alloc]init];
                    [backgroundView setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
                    [cell1 setBackgroundView:backgroundView];
                        
                    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
                    textLabel.text=@"国家和地区";
                    textLabel.textColor=[UIColor grayColor];
                    textLabel.textAlignment=UITextAlignmentCenter;
                    textLabel.font=FONT_14;
                    textLabel.userInteractionEnabled=NO;
                    textLabel.backgroundColor=[UIColor clearColor];
                    [cell1.contentView addSubview:textLabel];
                    
                    _arealabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 320-80-20-20-10, 24)];
                    _arealabel.text=@"中国 +86";
                    _arealabel.font=FONT_14;
                    _arealabel.userInteractionEnabled=YES;
                    _arealabel.textAlignment=UITextAlignmentRight;
                    [cell1.contentView addSubview:_arealabel];
                    
                    _areaButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    _areaButton.frame=CGRectMake(10, 10, 300, 24);
                    [_areaButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell1.contentView addSubview:_areaButton];
                }
                return cell1;
            }
                break;
            case 1:
            {
                static NSString * cellIdentifier = @"cell2";
                
                OCCLabelCell * cell2 = [_tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell2)
                {
                    cell2 = [[OCCLabelCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                    cell2.selectionStyle  = UITableViewCellSelectionStyleNone;
                    cell2.accessoryType =UITableViewCellAccessoryNone;
                    UIImageView *backgroundView=[[UIImageView alloc]init];
                    [backgroundView setImage:[[UIImage imageNamed:@"bg_tmp.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
                    [cell2 setBackgroundView:backgroundView];
                    
                    _areaNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 60, 24)];
                    _areaNumberLabel.text=@"+86";
                    _areaNumberLabel.font=FONT_14;
                    _areaNumberLabel.textAlignment=UITextAlignmentCenter;
                    _areaNumberLabel.backgroundColor=[UIColor clearColor];
                    [cell2.contentView addSubview:_areaNumberLabel];

                    _phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(90, 10, 320-100, 24)];
                    _phoneTextField.delegate=self;
                    _phoneTextField.font=FONT_14;
                    _phoneTextField.backgroundColor=[UIColor clearColor];
                    _phoneTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                    _phoneTextField.placeholder=@"请填写手机号码";
                    [_phoneTextField setKeyboardType:UIKeyboardTypePhonePad];
                    [cell2.contentView addSubview:_phoneTextField];
                }
                return cell2;
            }
                break;
            default:
                break;
        }
        return nil;
    }
    else
    {
        static NSString * cellIdentifier = @"cell3";
        
        OCCLabelCell * cell3 = [_tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell3)
        {
            cell3 = [[OCCLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell3.selectionStyle  = UITableViewCellSelectionStyleNone;
            cell3.accessoryType =UITableViewCellAccessoryNone;
            UIImageView *backgroundView=[[UIImageView alloc]init];
            [backgroundView setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
            [cell3 setBackgroundView:backgroundView];
            if (indexPath.section==0)
            {
                UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
                textLabel.text=@"邮箱";
                textLabel.textColor=[UIColor grayColor];
                textLabel.textAlignment=UITextAlignmentCenter;
                textLabel.font=FONT_14;
                textLabel.userInteractionEnabled=NO;
                textLabel.backgroundColor=[UIColor clearColor];
                [cell3.contentView addSubview:textLabel];
                
                _emailTextField=[[UITextField alloc]initWithFrame:CGRectMake(50, 10, 320, 24)];
                _emailTextField.delegate=self;
                _emailTextField.font=FONT_14;
                _emailTextField.placeholder=@"请输入用户邮箱";
                _emailTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                [_emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
                _emailTextField.backgroundColor=[UIColor clearColor];
                [cell3.contentView addSubview:_emailTextField];
            }
            if (indexPath.section==1)
            {
                UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
                textLabel.text=@"密码";
                textLabel.textColor=[UIColor grayColor];
                textLabel.textAlignment=UITextAlignmentCenter;
                textLabel.font=FONT_14;
                textLabel.userInteractionEnabled=NO;
                textLabel.backgroundColor=[UIColor clearColor];
                [cell3.contentView addSubview:textLabel];
                
                _passWordTextField=[[UITextField alloc]initWithFrame:CGRectMake(50, 10, 320, 24)];
                _passWordTextField.delegate=self;
                _passWordTextField.backgroundColor=[UIColor clearColor];
                _passWordTextField.placeholder=@"6-20个大小写英文字母,符号或数字";
                _passWordTextField.font=FONT_14;
                _passWordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                [_passWordTextField setSecureTextEntry:YES];
                [cell3.contentView addSubview:_passWordTextField];
            }
        }
        return cell3;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        [_hideTextField becomeFirstResponder];
    }
    else
    {
        [_hideTextField resignFirstResponder];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerDataList count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerDataList objectAtIndex:row];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [CommonMethods loginWithUsername:_emailTextField.text andPassword:_passWordTextField.text];
}

- (void) showTip:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:msg
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    
    [alert show];
}

- (void)hideKeyboard
{
    [_phoneTextField resignFirstResponder];;
    [_passWordTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_areaTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_telTextField resignFirstResponder];
    [_hideTextField resignFirstResponder];
}

@end
