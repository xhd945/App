//
//  RegisterSetPassWordViewController.m
//  occ
//
//  Created by mac on 13-9-13.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "RegisterSetPassWordViewController.h"

@interface RegisterSetPassWordViewController ()

@end

@implementation RegisterSetPassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"设置密码"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.view addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTitle:@"完成" WithTarget:self andSelector:@selector(doNext:) andLeft:NO];
    [headView addSubview:rightButton];
    
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    backgroundView.frame=CGRectMake(10, HEADER_HEIGHT+10, 300, 44);
    backgroundView.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView];
    
    UIImageView *backgroundView1=[[UIImageView alloc]init];
    [backgroundView1 setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    backgroundView1.frame=CGRectMake(10, HEADER_HEIGHT+10+54, 300, 44);
    backgroundView1.userInteractionEnabled=YES;
    [self.view addSubview:backgroundView1];
    
    UILabel *passWordLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    passWordLabel.text=@"输入密码";
    passWordLabel.textAlignment=UITextAlignmentCenter;
    passWordLabel.font=FONT_14;
    passWordLabel.backgroundColor=[UIColor clearColor];
    [backgroundView addSubview:passWordLabel];
    
    _passWordTextField=[[UITextField alloc]initWithFrame:CGRectMake(80, 10, 320-80-20-20, 24)];
    _passWordTextField.delegate=self;
    _passWordTextField.backgroundColor=[UIColor clearColor];
    _passWordTextField.font=FONT_14;
    _passWordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _passWordTextField.placeholder=@"请设置登录密码";
    _passWordTextField.secureTextEntry=YES;
    [backgroundView addSubview:_passWordTextField];
    
    UILabel *passWordLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    passWordLabel1.text=@"确认密码";
    passWordLabel1.textAlignment=UITextAlignmentCenter;
    passWordLabel1.font=FONT_14;
    passWordLabel1.backgroundColor=[UIColor clearColor];
    [backgroundView1 addSubview:passWordLabel1];
    
    _passWordTextField1=[[UITextField alloc]initWithFrame:CGRectMake(80, 10, 320-80-20-20, 24)];
    _passWordTextField1.delegate=self;
    _passWordTextField1.backgroundColor=[UIColor clearColor];
    _passWordTextField1.placeholder=@"请再次填入";
    _passWordTextField1.font=FONT_14;
    _passWordTextField1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _passWordTextField1.secureTextEntry=YES;
    [backgroundView1 addSubview:_passWordTextField1];
}

-(void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doNext:(id)sender
{
    [self hideKeyboard];
    NSString *passWord1=_passWordTextField.text;
    if (passWord1 ==nil || [passWord1 length]<=0)
    {
        [self showTip:@"请输入密码"];
        return;
    }
    
    NSString *passWord2=_passWordTextField1.text;
    if (passWord2 ==nil || [passWord2 length]<=0)
    {
        [self showTip:@"请输入密码"];
        return;
    }
    
    if (![_passWordTextField.text isEqualToString:_passWordTextField1.text])
    {
        [self showTip:@"两次密码不一致"];
        return;
    }
    
    [CommonMethods showWaitView:@"正在请求中,请稍候..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  _passWordTextField.text,@"pwd",
                                                  _phoneStr,@"mobile",
                                                  _codeStr,@"code",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:newRegister_URL andData:reqdata andDelegate:nil];
                       
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
                                                                                              message:@"手机注册成功"
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [CommonMethods loginWithUsername:_phoneStr andPassword:_passWordTextField.text];
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
    [_passWordTextField resignFirstResponder];
    [_passWordTextField1 resignFirstResponder];
}

@end
