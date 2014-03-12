//
//  CouponFilterViewController.m
//  occ
//
//  Created by RS on 13-9-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "CouponFilterViewController.h"
#import "NavCell.h"
#import "AppDelegate.h"

@interface CouponFilterViewController ()

@end

@implementation CouponFilterViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = COLOR_BG_CLASSTWO;
    
    NSArray *first=[NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"icon_floor",@"image",
                     @"icon_floor_selected",@"image_selected",
                     @"全部",@"title",
                     nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"icon_floor",@"image",
                     @"icon_floor_selected",@"image_selected",
                     @"楼层",@"title",
                     nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"icon_brand",@"image",
                     @"icon_brand_selected",@"image_selected",
                     @"品牌",@"title",
                     nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"icon_activity",@"image",
                     @"icon_activity_selected",@"image_selected",
                     @"活动",@"title",
                     nil],
                    nil];
    
    _dataList =[NSArray arrayWithObjects:first,nil];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassThree];
    [headView addSubview:topImageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeRightNavigationTitle];
    [titleLable setText:@"选择分类"];
    [titleLable setFrame:CGRectMake(SCREEN_WIDTH - LEFTVIEW_WIDTH + 15, 5, LEFTVIEW_WIDTH, HEADER_HEIGHT-5)];
    [headView addSubview:titleLable];
    _titleLable=titleLable;
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doConfirm:) andButtonType:OCCNavigationButtonTypeCheck andLeft:NO];
    [headView addSubview:rightButton];
    
    UIImage *whiteImage=[UIImage imageNamed:@"btn_white.png"];
    whiteImage=[whiteImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4, 0.0, 4)];
    
    //清除多余的Table线
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    emptyView.backgroundColor = [UIColor clearColor];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - LEFTVIEW_WIDTH,HEADER_HEIGHT,LEFTVIEW_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setAllowsMultipleSelection:YES];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:emptyView];
    [self.view addSubview:tableView];
    _tableView=tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doBack:(id)sender
{
    //[self.viewDeckController closeLeftViewAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doHome:(id)sender
{
    [self.viewDeckController closeLeftViewAnimated:YES];
}

- (void)doConfirm:(id)sender
{

}

#pragma mark -
#pragma mark Table Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataList objectAtIndex:section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *NavCellIdentifier=@"NavCellIdentifier";
    
    NavCell *cell = (NavCell*)[tableView dequeueReusableCellWithIdentifier:NavCellIdentifier];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NavCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    int row=indexPath.row;
    int section=indexPath.section;
    NSDictionary *data = [[_dataList objectAtIndex:section]objectAtIndex:row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row=indexPath.row;
    int section=indexPath.section;
    switch (section) {
        case 0:
        {
            if (row==0) {
               
            }else if(row==1){
                
            }else if(row==2){
                
            }
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
