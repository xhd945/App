//
//  OtherCouponViewController.m
//  occ
//
//  Created by RS on 13-8-29.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OtherCouponViewController.h"
#import "OneLineCell.h"
#import "TwoLineCell.h"

@interface OtherCouponViewController ()

@end

@implementation OtherCouponViewController

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
    if (_dataList==nil)
    {
        _dataList=[[NSMutableArray alloc]init];
    }
    
    [self.view setBackgroundColor:COLOR_BG_CLASSONE];
    
    UIView *footView = [[UIView alloc]init];
    [footView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [footView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:footView];
    
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [footView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:[NSString stringWithFormat:@"商家抵用券"]];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [footView addSubview:titleLable];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [footView addSubview:leftButton];
    
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS1];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [self.shopNameLabel setText:_shopName];
    [self.tableView reloadData];
    [self cashCashCouponId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setShopNameLabel:nil];
    [super viewDidUnload];
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count]+1;
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
    int row=indexPath.row;
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *selectedBackgroundView=[[UILabel alloc]init];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    
    switch (row)
    {
        case 0:
        {
            static NSString *OneLineCellIdentifier=@"OneLineCellIdentifier";
            
            OneLineCell *cell = (OneLineCell*)[tableView dequeueReusableCellWithIdentifier:OneLineCellIdentifier];
            if (cell == nil)
            {
                cell=[[OneLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneLineCellIdentifier];
            }
            
            NSDictionary *data = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"-1",@"id",@"不使用",@"name",nil];
            [cell setBackgroundView:backgroundView];
            [cell setSelectedBackgroundView:selectedBackgroundView];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setData:data];
            
            NSMutableArray *shopList=[[Singleton sharedInstance].orderData objectForKey:@"shopList"];
            NSMutableDictionary *shop=[shopList objectAtIndex:self.section-1];//第一个分段为地址列表
            int xx=[[shop objectForKey:@"cashCouponId"]intValue];
            int yy=[[data objectForKey:@"id"]intValue];
            if (xx==yy)
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                cell.rightStyle = TwoLineCellRightGou;
                cell.leftTextLabel.textColor = COLOR_DA6432;
            }
            return cell;
        }
            break;
        default:
        {
            static NSString *TwoCellIdentifier=@"TwoCellIdentifier";
            
            TwoLineCell *cell = (TwoLineCell*)[tableView dequeueReusableCellWithIdentifier:TwoCellIdentifier];
            if (cell == nil)
            {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TwoLineCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            NSDictionary *data = [_dataList objectAtIndex:row-1];
            NSDictionary *dataSort = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [data valueForKey:@"price"],@"name",
                                      [data valueForKey:@"name"],@"value",
                                      nil];
            
            [cell setBackgroundView:backgroundView];
            [cell setSelectedBackgroundView:selectedBackgroundView];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setData:dataSort];
            NSMutableArray *shopList=[[Singleton sharedInstance].orderData objectForKey:@"shopList"];
            NSMutableDictionary *shop=[shopList objectAtIndex:self.section-1];//第一个分段为地址列表
            int xx=[[shop objectForKey:@"cashCouponId"]intValue];
            int yy=[[data objectForKey:@"id"]intValue];
            if (xx==yy)
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                cell.rightStyle = TwoLineCellRightGou;
                cell.titleLabel.textColor = COLOR_DA6432;
            }
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    if (row==0)
    {
        NSMutableDictionary *shop=[[[Singleton sharedInstance].orderData objectForKey:@"shopList"]objectAtIndex:self.section-1];//第一个分段为地址列表
        [shop setObject:@"-1" forKey:@"cashCouponId"];
        [shop setObject:@"不使用" forKey:@"cashCouponName"];
        [shop setObject:@"0" forKey:@"cashCouponPrice"];
        [self compareCashCouponId];
        [_delegate payDidChange];
        [self doBack:nil];
    }
    else
    {
        NSDictionary *data = [_dataList objectAtIndex:row-1];
        NSMutableDictionary *shop=[[[Singleton sharedInstance].orderData objectForKey:@"shopList"]objectAtIndex:self.section-1];//第一个分段为地址列表
        [shop setObject:[data objectForKey:@"id"] forKey:@"cashCouponId"];
        [shop setObject:[data objectForKey:@"name"] forKey:@"cashCouponName"];
        [shop setObject:[data objectForKey:@"price"] forKey:@"cashCouponPrice"];
        [self compareCashCouponId];
        [_delegate payDidChange];
        [self doBack:nil];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}

- (void)cashCashCouponId
{
    NSMutableArray *shopList=[[Singleton sharedInstance].orderData objectForKey:@"shopList"];
    NSMutableDictionary *shop=[shopList objectAtIndex:self.section-1];
    _cashCouponId=[[shop objectForKey:@"cashCouponId"]intValue];
}

- (void)compareCashCouponId
{
    NSMutableArray *shopList=[[Singleton sharedInstance].orderData objectForKey:@"shopList"];
    NSMutableDictionary *shop=[shopList objectAtIndex:self.section-1];
    int xxx=[[shop objectForKey:@"cashCouponId"]intValue];
    if (xxx!=_cashCouponId)
    {
        [[Singleton sharedInstance].orderData setObject:@"-1" forKey:@"plCashCouponId"];
        [[Singleton sharedInstance].orderData setObject:@"不使用" forKey:@"plCashCouponName"];
        [[Singleton sharedInstance].orderData setObject:@"0" forKey:@"plCashCouponPrice"];
    }
}

@end
