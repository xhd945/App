//
//  PayDataViewController.m
//  occ
//
//  Created by RS on 13-8-28.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "PayDateViewController.h"

@interface PayDateViewController ()

@end

@implementation PayDateViewController

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
    // 设置选择器
    UIPickerView *datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 150.0, 320.0, 216.0)];
    datePicker.delegate = self;
    datePicker.showsSelectionIndicator = YES;
    _datePicker=datePicker;
    
    UIPickerView *timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 150.0, 320.0, 216.0)];
    timePicker.delegate = self;
    timePicker.showsSelectionIndicator = YES;
    _timePicker=timePicker;
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    OCCFieldCell *dateCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [dateCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    dateCell.field.inputView=_datePicker;
    dateCell.field.delegate=self;
    dateCell.field.textColor=COLOR_333333;
    [dateCell.field becomeFirstResponder];
    _dateCell=dateCell;
    
    OCCFieldCell *timeCell = [[OCCFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [timeCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    timeCell.field.inputView=_timePicker;
    timeCell.field.delegate=self;
    timeCell.field.textColor=COLOR_333333;
    _timeCell=timeCell;

    _dataList = [[NSMutableArray alloc]initWithObjects:
                 dateCell,
                 timeCell,
                 nil];
    
    _dateList=[[Singleton sharedInstance].payData objectForKey:@"dateTimeList"];
    _timeList= [[_dateList objectAtIndex:0]objectForKey:@"timeList"];
    
    _dateCell.field.text=[[_dateList objectAtIndex:0]objectForKey:@"data"];
    _timeCell.field.text=[[_timeList objectAtIndex:0]objectForKey:@"dateTime"];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"预约收货时间"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [headView addSubview:leftButton];
    
    //UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doConfirm:) andButtonType:OCCNavigationButtonTypeCheck andLeft:NO];
    //[headView addSubview:rightButton];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,1*HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doBack:(id)sender
{
    [[Singleton sharedInstance].orderData setObject:_dateCell.field.text forKey:@"receiveDate"];
    [[Singleton sharedInstance].orderData setObject:_timeCell.field.text forKey:@"receiveTime"];
    [_delegate payDidChange];
    [self.navigationController popViewControllerAnimated:YES];
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
    int section=indexPath.section;
    OCCFieldCell *cell=[_dataList objectAtIndex:section];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    cell.lineImageView.hidden=YES;
    
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setImage:[[UIImage imageNamed:@"list_edit_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    [cell setBackgroundView:backgroundView];
    
    UIImageView *selectedBackgroundView=[[UIImageView alloc]init];
    [selectedBackgroundView setImage:[[UIImage imageNamed:@"list_edit_press"]resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
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
    [_dateCell.field resignFirstResponder];
    [_timeCell.field resignFirstResponder];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==self.datePicker)
    {
        return [_dateList count];
    }
    else
    {
        return [_timeList count];
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==self.datePicker)
    {
       return [[_dateList objectAtIndex:row]objectForKey:@"data"];
    }
    else
    {
        return [[_timeList objectAtIndex:row]objectForKey:@"dateTime"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==self.datePicker)
    {
        _timeList= [[_dateList objectAtIndex:row]objectForKey:@"timeList"];
        [self.timePicker reloadAllComponents];
        _dateCell.field.text=[[_dateList objectAtIndex:row]objectForKey:@"data"];
        _timeCell.field.text=[[_timeList objectAtIndex:0]objectForKey:@"dateTime"];
    }
    else
    {
        _timeCell.field.text=[[_timeList objectAtIndex:row]objectForKey:@"dateTime"];
    }
}

@end
