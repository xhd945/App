//
//  AddressModifyViewController.m
//  occ
//
//  Created by RS on 13-8-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "AddressModifyViewController.h"

@interface AddressModifyViewController ()

@end

@implementation AddressModifyViewController

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
    self.check=NO;
    
    self.provinceDataList = [[NSMutableArray alloc]init];
    self.cityDataList = [[NSMutableArray alloc]init];
    self.areaDataList = [[NSMutableArray alloc]init];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    // 设置选择器
    UIPickerView *communityPickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 150.0, 320.0, 216.0)];
    communityPickerview.delegate = self;
    communityPickerview.showsSelectionIndicator = YES;
    _communityPickerview=communityPickerview;
    
    UIPickerView *provincePickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 150.0, 320.0, 216.0)];
    provincePickerview.delegate = self;
    provincePickerview.showsSelectionIndicator = YES;
    _provincePickerview=provincePickerview;
    
    NSString *consignee=[_data objectForKey:@"consignee"];
    if (consignee==nil||[consignee length]==0)
    {
        consignee=@"未知";
    }
    
    OCCFieldCell *nameCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [nameCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	nameCell.field.placeholder = @"收货人姓名";
    nameCell.field.text=consignee;
    nameCell.field.delegate=self;
    nameCell.field.clearButtonMode=UITextFieldViewModeWhileEditing;
    _nameCell=nameCell;
	
	OCCFieldCell *mobileCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [mobileCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	mobileCell.field.placeholder = @"手机号码";
    mobileCell.field.text=[_data objectForKey:@"mobile"];
    mobileCell.field.delegate=self;
    mobileCell.field.clearButtonMode=UITextFieldViewModeWhileEditing;
    _mobileCell=mobileCell;
    
    OCCFieldCell *areaCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [areaCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	areaCell.field.placeholder = @"详细地址";
    areaCell.field.text = @"";
    areaCell.field.delegate=self;
    areaCell.field.clearButtonMode=UITextFieldViewModeWhileEditing;
    _areaCell=areaCell;
    
    OCCFieldCell *detailAddrCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [detailAddrCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	detailAddrCell.field.placeholder = @"详细地址";
    detailAddrCell.field.text=[_data objectForKey:@"address"];
    detailAddrCell.field.clearButtonMode=UITextFieldViewModeWhileEditing;
    detailAddrCell.field.delegate=self;
    _detailAddrCell=detailAddrCell;
	
	_dataList = [[NSMutableArray alloc] initWithObjects:
                 nameCell,
                 mobileCell,
                 detailAddrCell,
                 nil];

    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"编辑收货地址"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doConfirm:) andButtonType:OCCNavigationButtonTypeCheck andLeft:NO];
    [headView addSubview:rightButton];
    
    UIView *addrHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 150.0f)];
    [addrHeaderView setClipsToBounds:YES];
    _addrHeaderView=addrHeaderView;
    
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 240.0f, 40.0f)];
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    searchTextField.placeholder = @"请输入小区或者街道名";
    searchTextField.text = @"";
    searchTextField.font = FONT_14;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchTextField.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.delegate = self;
    searchTextField.keyboardType = UIKeyboardTypeDefault;
    [addrHeaderView addSubview:searchTextField];
    _searchTextField=searchTextField;
    
    UITextField *searchHideTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    searchHideTextField.inputView=communityPickerview;
    searchHideTextField.inputAccessoryView=self.communityToolBar;
    [addrHeaderView addSubview:searchHideTextField];
    _searchHideTextField=searchHideTextField;
    
    UIView *searchButton = [CommonMethods buttonWithTitle:@"查询" withTarget:self
                                              andSelector:@selector(doSearch:) andFrame:CGRectMake(260, 0, 50, 40)
                                            andButtonType:OCCButtonTypeYellow];
    [addrHeaderView addSubview:searchButton];
    
    UIButton *checkButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 50, 170, 40)];
    [checkButton setImage:[UIImage imageNamed:@"checkbox_nor"] forState:UIControlStateNormal];
    [checkButton setTitle:@"其他地址(第三方物流)" forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(doCheck:) forControlEvents:UIControlEventTouchUpInside];
    [checkButton setTitleColor:COLOR_666666 forState:UIControlStateNormal];
    [checkButton setTitleColor:COLOR_666666 forState:UIControlStateHighlighted];
    checkButton.titleLabel.font=FONT_14;
    [addrHeaderView addSubview:checkButton];
    _checkButton=checkButton;
    
    UITextField *provinceTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 100.0f, 90.0f, 40.0f)];
    [provinceTextField setBorderStyle:UITextBorderStyleRoundedRect];
    provinceTextField.placeholder = @"省";
    provinceTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    provinceTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    provinceTextField.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    provinceTextField.returnKeyType = UIReturnKeyDone;
    provinceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    provinceTextField.delegate = self;
    provinceTextField.keyboardType = UIKeyboardTypeDefault;
    provinceTextField.inputView=provincePickerview;
    provinceTextField.inputAccessoryView=self.provinceToolBar;
    [addrHeaderView addSubview:provinceTextField];
    _provinceTextField=provinceTextField;
    
    UITextField *cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(provinceTextField.frame.origin.x+provinceTextField.frame.size.width+ 10.0f, provinceTextField.frame.origin.y, 90.0f, 40.0f)];
    [cityTextField setBorderStyle:UITextBorderStyleRoundedRect];
    cityTextField.placeholder = @"市";
    cityTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    cityTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cityTextField.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    cityTextField.returnKeyType = UIReturnKeyDone;
    cityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cityTextField.delegate = self;
    cityTextField.keyboardType = UIKeyboardTypeDefault;
    cityTextField.inputView=provincePickerview;
    cityTextField.inputAccessoryView=self.provinceToolBar;
    [addrHeaderView addSubview:cityTextField];
    _cityTextField=cityTextField;
    
    UITextField *areaTextField = [[UITextField alloc] initWithFrame:CGRectMake(cityTextField.frame.origin.x+cityTextField.frame.size.width+ 10.0f, cityTextField.frame.origin.y, 90.0f, 40.0f)];
    [areaTextField setBorderStyle:UITextBorderStyleRoundedRect];
    areaTextField.placeholder = @"区";
    areaTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    areaTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    areaTextField.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    areaTextField.returnKeyType = UIReturnKeyDone;
    areaTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    areaTextField.delegate = self;
    areaTextField.keyboardType = UIKeyboardTypeDefault;
    areaTextField.inputView=provincePickerview;
    areaTextField.inputAccessoryView=self.provinceToolBar;
    [addrHeaderView addSubview:areaTextField];
    _areaTextField=areaTextField;
    
    UIView *tableFootView=[[UIView alloc]init];
    [tableFootView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    _tableFootView=tableFootView;
    
    UIImage *whiteImage=[UIImage imageNamed:@"btn_white.png"];
    whiteImage=[whiteImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4, 0.0, 4)];
    
    UIButton *defaultButton = [[UIButton alloc]init];
    [defaultButton setFrame:CGRectMake(10, 46, 300, 44)];
    [defaultButton setBackgroundImage:whiteImage forState:UIControlStateNormal];
    //[defaultButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [defaultButton addTarget:self action:@selector(doDefault:) forControlEvents:UIControlEventTouchUpInside];
    defaultButton.titleLabel.font = FONT_12;
    [defaultButton setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    [defaultButton setTitle:@"设为默认地址" forState:UIControlStateNormal];
    [tableFootView addSubview:defaultButton];
    
    UIImage *redImage=[UIImage imageNamed:@"btn_red.png"];
    redImage=[redImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4, 0.0, 4)];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    [deleteButton setFrame:CGRectMake(10, 0, 300, 44)];
    [deleteButton setBackgroundImage:redImage forState:UIControlStateNormal];
    [deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.titleLabel.font = FONT_12;
    [deleteButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [deleteButton setTitle:@"删除该地址" forState:UIControlStateNormal];
    [tableFootView addSubview:deleteButton];
    
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"occ.db3" ofType:nil];
    self.db = [FMDatabase databaseWithPath:filePath];
    [self queryProvince];
    [self queryCity];
    [self queryArea];
    [self.provincePickerview reloadAllComponents];
    [self reloadProvinceCityAreaField];
    
    Address *province=[self queryProvinceById:[[_data objectForKey:@"province"]longValue]];
    if (province!=nil) {
        [self.provinceTextField setText:province.name];
    }
    
    Address *city=[self queryCityById:[[_data objectForKey:@"city"]longValue]];
    if (city!=nil) {
        [self.cityTextField setText:city.name];
    }
    
    Address *area=[self queryAreaById:[[_data objectForKey:@"area"]longValue]];
    if (area!=nil) {
        [self.areaTextField setText:area.name];
    }
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,1*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:tableFootView];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    int isOtherCommunity=[[_data objectForKey:@"isOtherCommunity"]intValue];
    self.check=isOtherCommunity;
    if (self.check) {
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_press"] forState:UIControlStateNormal];
        searchTextField.text=@"";
    }else{
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_nor"] forState:UIControlStateNormal];
        NSString *address=[_data objectForKey:@"communityName"];
        searchTextField.text=(address!=nil?address:@"");
        self.communityId=[[_data objectForKey:@"communityId"]intValue];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{

}

- (void)doCheck:(id)sender
{
    self.check=!self.check;
    [self.tableView reloadData];
    [self reloadProvinceCityAreaField];
    if (self.check) {
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_press"] forState:UIControlStateNormal];
    }else{
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_nor"] forState:UIControlStateNormal];
    }
}

- (IBAction)doSelectCommunicity:(id)sender
{
    [self hideKeyboard];
    
    NSInteger row = [self.communityPickerview selectedRowInComponent:0];
    self.searchTextField.text = [[self.communityDataList objectAtIndex:row]objectForKey:@"name"];
    self.communityId=[[[self.communityDataList objectAtIndex:row]objectForKey:@"id"]longValue];
}

- (IBAction)doSelectProvince:(id)sender
{
    [self hideKeyboard];
    [self reloadProvinceCityAreaField];
}

- (IBAction)doSelectCancel:(id)sender
{
    [self hideKeyboard];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // here, do whatever you wantto do
    //UITouch *touch = [[event allTouches]anyObject];
    //UIView *touchView=touch.view;
    [self hideKeyboard];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doSearch:(id)sender
{
    [self hideKeyboard];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  self.searchTextField.text, @"name",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });

                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadCommunity_URL andData:reqdata andDelegate:nil];
                       
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
                                              NSMutableArray *dataList=[data objectForKey:@"communityList"];
                                              _communityDataList=dataList;
                                              [_communityPickerview reloadAllComponents];
                                              if ([_communityDataList count]>0)
                                              {
                                                  [_searchHideTextField becomeFirstResponder];
                                              }
                                              else
                                              {
                                                  [CommonMethods showTextDialog:@"抱歉,没有搜索到相关信息!" inView:self.view];
                                                  [_searchHideTextField resignFirstResponder];
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

- (void)doConfirm:(id)sender
{
    [self hideKeyboard];
    
    if ([_nameCell.field.text length]==0) {
        [self showTip:@"请输入收货人姓名"];
        return;
    }
    
    if ([_mobileCell.field.text length]==0) {
        [self showTip:@"请输入手机号码"];
        return;
    }
    
    if ([_detailAddrCell.field.text length]==0) {
        [self showTip:@"请输入详细地址"];
        return;
    }
    
    if (self.check) {
        if ([_provinceTextField.text length]==0) {
            [self showTip:@"请选择省"];
            return;
        }
        
        if ([_cityTextField.text length]==0) {
            [self showTip:@"请选择市"];
            return;
        }
        
        if ([_areaTextField.text length]==0) {
            [self showTip:@"请选择区"];
            return;
        }
    }else{
        if ([_searchTextField.text length]==0) {
            [self showTip:@"请选择小区"];
            return;
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"id"], @"id",
                                                  _nameCell.field.text, @"consignee",
                                                  _mobileCell.field.text, @"mobile",
                                                  @"", @"tel",
                                                  [NSString stringWithFormat:@"%ld",self.provinceId], @"province",
                                                  [NSString stringWithFormat:@"%ld",self.cityId], @"city",
                                                  [NSString stringWithFormat:@"%ld",self.areaId], @"area",
                                                  _detailAddrCell.field.text, @"address",
                                                  self.check?@"1":@"0",@"isOtherCommunity",
                                                  [NSString stringWithFormat:@"%ld",self.communityId], @"communityId",
                                                  
                                                  @"200000", @"zipCode",
                                                  @"021", @"areaCode",
                                                  @"200000", @"ext",
                                                  @"1", @"addLabel",
                                                  @"1", @"type",
                                                  @"1", @"isDefault",
                                                  @"1", @"provincesInfo",
                                                  @"1",@"userId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:addAddress_URL andData:reqdata andDelegate:nil];
                       
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
                                              UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                  message:@"修改地址成功"
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"确定"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                              
                                              NSDictionary *data=[root objectForKey:@"data"];
                                              if (data!=nil&&[data objectForKey:@"id"]!=nil)
                                              {
                                                  NSMutableDictionary *orderData=[Singleton sharedInstance].orderData;
                                                  [orderData setObject:[data objectForKey:@"id"] forKey:@"addressId"];
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

- (void)doDelete:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"id"], @"id",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:deleteAddress_URL andData:reqdata andDelegate:nil];
                       
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
                                              UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                  message:@"删除地址成功"
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:@"确定"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];

                                          });
                       }else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [CommonMethods showFailDialog:[root objectForKey:@"msg"] inView:self.view];
                                          });
                       }
                   });
}

- (void)doDefault:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"id"], @"id",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [CommonMethods showWaitView:@"正在请求中,请稍候..."];
                                      });
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:defaultAddress_URL andData:reqdata andDelegate:nil];
                       
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
                                              UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                  message:@"设置默认地址成功"
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"确定"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2)
    {
        if (self.check)
        {
            return 150;
        }
        else
        {
            return 100;
        }
    }
    else
    {
        return 5.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return section==2?self.addrHeaderView:nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section=indexPath.section;
    OCCFieldCell *cell=[_dataList objectAtIndex:section];
    cell.lineImageView.hidden=YES;
    
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setImage:[[UIImage imageNamed:@"list_edit_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    UIImageView *selectedBackgroundView=[[UIImageView alloc]init];
    [selectedBackgroundView setImage:[[UIImage imageNamed:@"list_edit_press"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    
    [cell setBackgroundView:backgroundView];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
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
    [self hideKeyboard];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView==self.provincePickerview) {
        return 3;
    }else{
        return 1;
    }
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==self.provincePickerview) {
        if (component==0) {
            return [_provinceDataList count];
        }
        else if (component==1) {
            return [_cityDataList count];
        }
        else if (component==2) {
            return [_areaDataList count];
        }else{
            return 0;
        }
    }else{
        return [_communityDataList count];
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==self.provincePickerview) {
        if (component==0) {
            Address *data=[_provinceDataList objectAtIndex:row];
            return data.name;
        }
        else if (component==1) {
            Address *data=[_cityDataList objectAtIndex:row];
            return data.name;
        }
        else if (component==2) {
            Address *data=[_areaDataList objectAtIndex:row];
            return data.name;
        }else{
            return @"";
        }
    }else{
        return [[_communityDataList objectAtIndex:row]objectForKey:@"name"];;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==self.provincePickerview) {
        if (component==0) {
            [self queryCity];
            [pickerView reloadComponent:1];
            
            [self queryArea];
            [pickerView reloadComponent:2];
        }
        else if (component==1) {
            [self queryArea];
            [pickerView reloadComponent:2];
        }
        else if (component==2) {
            
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField=textField;
    
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self doBack:nil];
}

-(void)queryProvince
{
    if ([self.db open]) {
        FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=1"];
        while ([rs next]){
            Address *address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            [self.provinceDataList addObject:address];
        }
        [rs close];
    }
}

-(void)queryCity
{
    NSInteger row0 = [self.provincePickerview selectedRowInComponent:0];
    NSInteger row1 = [self.provincePickerview selectedRowInComponent:1];
    NSInteger row2 = [self.provincePickerview selectedRowInComponent:2];
    
    Address *province=[self.provinceDataList objectAtIndex:row0];
    self.provinceId=province.id;
    
    if ([self.db open]) {
        [self.cityDataList removeAllObjects];
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=2 and PARENT_ID=%ld",self.provinceId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            Address *address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            [self.cityDataList addObject:address];
        }
        [rs close];
    }
}

-(void)queryArea
{
    NSInteger row0 = [self.provincePickerview selectedRowInComponent:0];
    NSInteger row1 = [self.provincePickerview selectedRowInComponent:1];
    NSInteger row2 = [self.provincePickerview selectedRowInComponent:2];
    
    Address *city=[self.cityDataList objectAtIndex:row1];
    self.cityId=city.id;
    
    if ([self.db open]) {
        [self.areaDataList removeAllObjects];
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=3 and PARENT_ID=%ld",self.cityId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            Address *address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            [self.areaDataList addObject:address];
        }
        [rs close];
    }
}

-(Address *)queryProvinceById:(long)provinceId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=1 and ID=%ld",provinceId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(Address *)queryCityById:(long)cityId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=2 and ID=%ld",cityId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(Address *)queryAreaById:(long)areaId
{
    Address *address;
    
    if ([self.db open]) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM UC_SYSTEM_REGION_DICT where level=3 and ID=%ld",areaId];
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]){
            address=[[Address alloc]init];
            address.id=[rs intForColumn:@"id"];
            address.parentId=[rs intForColumn:@"PARENT_ID"];
            address.level = [rs intForColumn:@"LEVEL"];
            address.name = [rs stringForColumn:@"DICT_NAME"];
            break;
        }
        [rs close];
    }
    
    return address;
}

-(void)reloadProvinceCityAreaField
{
    if (self.provinceDataList.count>0)
    {
        NSInteger row0 = [self.provincePickerview selectedRowInComponent:0];
        Address *province=[self.provinceDataList objectAtIndex:row0];
        self.provinceTextField.text = province.name;
        self.provinceId=province.id;
    }
    else
    {
        self.provinceTextField.text = @"";
        self.provinceId=0;
    }
    
    if (self.cityDataList.count>0)
    {
        NSInteger row1 = [self.provincePickerview selectedRowInComponent:1];
        Address *city=[self.cityDataList objectAtIndex:row1];
        self.cityTextField.text = city.name;
        self.cityId=city.id;
    }
    else
    {
        self.cityTextField.text = @"";
        self.cityId=0;
    }
    
    if(self.areaDataList.count>0)
    {
        NSInteger row2 = [self.provincePickerview selectedRowInComponent:2];
        Address *area=[self.areaDataList objectAtIndex:row2];
        self.areaTextField.text = area.name;
        self.areaId=area.id;
    }
    else
    {
        self.areaTextField.text = @"";
        self.areaId=0;
    }
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
    [self.provinceTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    [self.searchTextField resignFirstResponder];
    [self.searchHideTextField resignFirstResponder];
    [self.nameCell.field resignFirstResponder];
    [self.mobileCell.field resignFirstResponder];
    [self.detailAddrCell.field resignFirstResponder];
}

@end
