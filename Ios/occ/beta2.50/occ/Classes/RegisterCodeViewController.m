//
//  RegisterNextViewController.m
//  occ
//
//  Created by RS on 13-9-2.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "RegisterCodeViewController.h"

@interface RegisterCodeViewController ()

@end

@implementation RegisterCodeViewController

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
    OCCFieldCell *phoneCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [phoneCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	phoneCell.field.placeholder = @"请输入短信验证码";
    phoneCell.field.delegate=self;
    [phoneCell.field setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _codeCell=phoneCell;
	
    _dataList = [[NSMutableArray alloc]initWithObjects:phoneCell, nil];
    
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
    [self.view addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTitle:@"下一步" WithTarget:self andSelector:@selector(doNext:) andLeft:NO];
    [headView addSubview:rightButton];
    
    UIView *tableHeadView=[[UIView alloc]init];
    [tableHeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _tableHeadView=tableHeadView;
    
    UILabel *label1 = [[UILabel alloc]init];
    [label1 setTextColor:COLOR_999999];
    [label1 setFont:FONT_12];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setText:@"我们已经发送"];
    [label1 setFrame:CGRectMake(10,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [tableHeadView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]init];
    [label2 setTextColor:[UIColor colorWithRed:61/255.0 green:155/255.0 blue:77/255.0 alpha:1]];
    [label2 setFont:FONT_12];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setText:@"验证码短信"];
    [label2 setFrame:CGRectMake(85,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [tableHeadView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]init];
    [label3 setTextColor:COLOR_999999];
    [label3 setFont:FONT_12];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [label3 setText:@"到这个号码"];
    [label3 setFrame:CGRectMake(150,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [label3 setTextAlignment:NSTextAlignmentLeft];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [tableHeadView addSubview:label3];
    
    NSRange phoneRang;
    phoneRang.location=0;
    phoneRang.length=3;
    NSString *rangStr=[_phoneStr substringWithRange:phoneRang];
    
    NSRange phoneRang1;
    phoneRang1.location=3;
    phoneRang1.length=4;
    NSString *rangStr1=[_phoneStr substringWithRange:phoneRang1];
    
    NSRange phoneRang2;
    phoneRang2.location=7;
    phoneRang2.length=4;
    NSString *rangStr2=[_phoneStr substringWithRange:phoneRang2];
    
    UILabel *label4 = [[UILabel alloc]init];
    [label4 setTextColor:COLOR_999999];
    [label4 setFont:FONT_12];
    [label4 setBackgroundColor:[UIColor clearColor]];
    [label4 setText:[NSString stringWithFormat:@"%@ %@ %@ %@",_areaStr,rangStr,rangStr1,rangStr2]];
    [label4 setFrame:CGRectMake(10,20, SCREEN_WIDTH, HEADER_HEIGHT)];
    [label4 setBackgroundColor:[UIColor clearColor]];
    [label4 setTextAlignment:NSTextAlignmentLeft];
    [tableHeadView addSubview:label4];
    
    UIView *tableFootView=[[UIView alloc]init];
    [tableFootView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _tableFootView=tableFootView;
    
    UILabel *footLable = [[UILabel alloc]init];
    [footLable setTextColor:COLOR_999999];
    [footLable setFont:FONT_12];
    [footLable setBackgroundColor:[UIColor clearColor]];
    [footLable setText:@"接受短信大概需要30秒"];
    [footLable setFrame:CGRectMake(10,0, SCREEN_WIDTH, 20)];
    [footLable setTextAlignment:NSTextAlignmentLeft];
    [tableFootView addSubview:footLable];
    
    UIImage *whiteImage=[UIImage imageNamed:@"btn_bg_light_gray"];
    whiteImage=[whiteImage stretchableImageWithLeftCapWidth:whiteImage.size.width/2 topCapHeight:whiteImage.size.height/2];
    
    UIButton *timerButton = [[UIButton alloc]init];
    [timerButton setFrame:CGRectMake(10, 40, 300, 44)];
    [timerButton setBackgroundImage:whiteImage forState:UIControlStateNormal];
    //[timerButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [timerButton addTarget:self action:@selector(doRegetCode:) forControlEvents:UIControlEventTouchUpInside];
    timerButton.titleLabel.font = FONT_16;
    [timerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [timerButton setTitle:@"30秒后重新获取验证码" forState:UIControlStateNormal];
    [tableFootView addSubview:timerButton];
    _timerButton=timerButton;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setTableHeaderView:_tableHeadView];
    [tableView setTableFooterView:_tableFootView];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(handleTimer:)
                                                  userInfo:nil
                                                   repeats:YES];
    
    [self getCode];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (void)doNext:(id)sender
{
    [self hideKeyboard];
    NSString *code=_codeCell.field.text;
    if (code ==nil || [code length]<=0)
    {
        [self showTip:@"请输入验证码"];
        return;
    }
    
    RegisterSetPassWordViewController *viewController=[[RegisterSetPassWordViewController alloc]init];
    viewController.phoneStr=_phoneStr;
    viewController.codeStr=_codeCell.field.text;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)doRegetCode:(id)sender
{
    if (self.downup==0)
    {
        [self getCode];
    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCCFieldCell *cell=[_dataList objectAtIndex:indexPath.section];
    cell.lineImageView.hidden=YES;
    
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setImage:[[UIImage imageNamed:@"bg_white.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    [cell setBackgroundView:backgroundView];
    
    UILabel *selectedBackgroundView=[[UILabel alloc]init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)getCode
{
    [CommonMethods showWaitView:@"正在请求中,请稍候..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  _phoneStr,@"mobile",
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
                                              self.downup=30;
                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
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
    [_codeCell.field resignFirstResponder];
}

-(void)handleTimer:(NSTimer *)timer
{
    if(self.downup==0)
    {
        [_timerButton setTitle:[NSString stringWithFormat:@"重新获取验证码"] forState:UIControlStateNormal];
    }
    else
    {
        [_timerButton setTitle:[NSString stringWithFormat:@"%d秒后重新获取验证码",self.downup--] forState:UIControlStateNormal];
    }
}

@end
