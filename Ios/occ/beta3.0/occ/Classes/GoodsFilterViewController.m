//
//  SearchFilterViewController.m
//  occ
//
//  Created by RS on 13-8-12.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsFilterViewController.h"
#import "GoodsFilterCell.h"
#import "RulerView.h"

#define kSectionHeight 20

@interface GoodsFilterViewController ()

@end

@implementation GoodsFilterViewController

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
    
    self.priceFrom=MIN_PRICE;
    self.priceTo=MAX_PRICE;
    
    _dataList=[NSMutableArray arrayWithObjects:
               [NSMutableDictionary dictionaryWithObjectsAndKeys:
                @"价格区间：",@"title",
                @"0-∞",@"text",
                @"1",@"check",
                nil],
               nil];
    
    _firstDataList=[NSMutableArray arrayWithObjects:
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"0",@"check",
                     @"包邮",@"title",
                     nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"0",@"check",
                     @"限时折扣",@"title",
                     nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"0",@"check",
                     @"满一百减一百",@"title",
                     nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"0",@"check",
                     @"送积分",@"title",
                     nil],
                    nil];
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassThree];
    [headView addSubview:topImageView];
    
    UIView *rightButton = [CommonMethods toolBarButtonWithTarget:self andSelector:@selector(doConfirm:) andButtonType:OCCToolBarButtonTypeCheck andLeft:NO];
    [headView addSubview:rightButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeRightNavigationTitle];
    [titleLable setText:@"选择价格"];
    [titleLable setFrame:CGRectMake(SCREEN_WIDTH - LEFTVIEW_WIDTH + 15, 5, rightButton.frame.origin.x - (SCREEN_WIDTH - LEFTVIEW_WIDTH + 15), HEADER_HEIGHT-5)];
    [headView addSubview:titleLable];
    _titleLable=titleLable;
    
    //没有标题栏
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - LEFTVIEW_WIDTH, HEADER_HEIGHT , LEFTVIEW_WIDTH, SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setAllowsMultipleSelection:YES];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS4];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    //价格
    UIView *foot1TableView=[[UIView alloc]init];
    [foot1TableView setFrame:CGRectMake(0, 0, _tableView.frame.size.width, 90)];
    [foot1TableView setBackgroundColor:[UIColor clearColor]];
    [foot1TableView setClipsToBounds:YES];
    _foot1TableView =foot1TableView;
    
    RulerView *rulerView = [[RulerView alloc] initWithFrame:CGRectMake(20, 10, 230, 40)
                                              andTitleArray:[NSArray arrayWithObjects:@"0",@"20",@"50",@"100",@"200",@"1000",@"∞", nil]];
    [foot1TableView addSubview:rulerView];
    
    UIImage* trackBackgroundImage = [UIImage imageNamed:@"search_price_nor"];
    trackBackgroundImage = [trackBackgroundImage stretchableImageWithLeftCapWidth:trackBackgroundImage.size.width/2 topCapHeight:trackBackgroundImage.size.height/2];
    
    UIImage* trackImage = [UIImage imageNamed:@"search_price_press"];
    trackImage = [trackImage stretchableImageWithLeftCapWidth:trackImage.size.width / 2 topCapHeight:trackImage.size.height / 2];
    
    NMRangeSlider *rangeSlider=[[NMRangeSlider alloc]init];
    [rangeSlider setFrame:CGRectMake(20-10, 40, 230+10*2, 30)];
    [rangeSlider setMinimumValue:0];
    [rangeSlider setMaximumValue:6];
    [rangeSlider setStepValue:1];
    [rangeSlider setLowerValue:0];
    [rangeSlider setUpperValue:6];
    [rangeSlider setTrackBackgroundImage:trackBackgroundImage];
    [rangeSlider setTrackImage:trackImage];
    [rangeSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [foot1TableView addSubview:rangeSlider];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, foot1TableView.frame.size.height - 1, foot1TableView.frame.size.width, 1)];
    lineView.backgroundColor = COLOR_CELL_LINE_CLASS4;
    [foot1TableView addSubview:lineView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doConfirm:(id)sender
{
    [self.viewDeckController closeRightViewAnimated:YES
                                        completion:^(IIViewDeckController *controller, BOOL success) {
                                            if ([controller.centerController respondsToSelector:@selector(filterDataList)]) {
                                                [controller.centerController performSelector:@selector(filterDataList)];
                                            }
                                            if ([controller.centerController respondsToSelector:@selector(reloadItemDataList)]) {
                                                [controller.centerController performSelector:@selector(reloadItemDataList)];
                                            }
                                        }];
}

- (void)sliderChange:(NMRangeSlider*)slider
{
    int min=slider.lowerValue;
    int max=slider.upperValue;
    
    NSMutableDictionary *data=[self.dataList objectAtIndex:0];
    [data setObject:[NSString stringWithFormat:@"%@-%@",[self getValueByValue:min],[self getValueByValue:max]] forKey:@"text"];
    GoodsFilterCell *cell=(GoodsFilterCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setData:data];
    
    if (min!=6) {
        self.priceFrom=[self getValueByValue:min];
    }else{
        self.priceFrom=MAX_PRICE;
    }
    
    if (max!=6) {
        self.priceTo=[self getValueByValue:max];
    }else{
        self.priceTo=MAX_PRICE;
    }
}

- (void)doAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSMutableDictionary *data=[self.firstDataList objectAtIndex:btn.tag];
    if ([[data objectForKey:@"check"]intValue]==1) {
        [data setObject:@"0" forKey:@"check"];
        [btn setImage:[UIImage imageNamed:@"checkbox_nor.png"] forState:UIControlStateNormal];
    }else{
        [data setObject:@"1" forKey:@"check"];
        [btn setImage:[UIImage imageNamed:@"checkbox_press.png"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (int i=0; i<self.firstDataList.count; i++) {
        NSDictionary *data=[self.firstDataList objectAtIndex:i];
        if ([[data objectForKey:@"check"]intValue]==1) {
            [arr addObject:[data objectForKey:@"title"]];
        }
    }
    
    NSMutableDictionary *data2=[self.dataList objectAtIndex:0];
    [data2 setObject:[arr componentsJoinedByString:@","] forKey:@"text"];
    GoodsFilterCell *cell=(GoodsFilterCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setData:data2];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
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
    NSMutableDictionary *data=[self.dataList objectAtIndex:section];
    if ([[data objectForKey:@"check"]intValue]==1) {
        if (section==0) {
            return _foot1TableView.frame.size.height;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return _foot1TableView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return kSectionHeight;
    }
    if (section == 3)
    {
        return kSectionHeight;
    }
    if (section == 6)
    {
        return kSectionHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeight)];
    //aView.image = [UIImage imageNamed:@"bg_section_blue"];
    aView.backgroundColor = COLOR_594F47;
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, aView.frame.size.width, kSectionHeight)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.font = FONT_14;
    if (section == 1)
    {
        aLabel.text = @"新品";
    }
    else if (section == 3)
    {
        aLabel.text = @"女装";
    }
    else if (section == 6)
    {
        aLabel.text = @"男装";
    }
    aLabel.textColor = [UIColor whiteColor];
    [aView addSubview:aLabel];
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GoodsFilterCellIdentifier=@"GoodsFilterCellIdentifier";
    
    GoodsFilterCell *cell = (GoodsFilterCell *)[tableView dequeueReusableCellWithIdentifier:GoodsFilterCellIdentifier];
    if (cell == nil)
    {
        cell = [[GoodsFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GoodsFilterCellIdentifier];
    }
    
    NSDictionary *data = [_dataList objectAtIndex:indexPath.section];
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    NSMutableDictionary *data=[self.dataList objectAtIndex:indexPath.section];
    if ([[data objectForKey:@"check"]intValue]==1)
    {
        [data setObject:@"0" forKey:@"check"];
    }else{
        [data setObject:@"1" forKey:@"check"];
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didFilterChange:(NSString*)data
{
    NSIndexPath *indexPath=[_tableView indexPathForSelectedRow];
    UITableViewCell *cell=[_tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setText:data];
}

- (NSString*)getValueByValue:(int)value
{
    NSArray *arr=[NSArray arrayWithObjects:@"0",@"20",@"50",@"100",@"200",@"1000",@"∞", nil];
    return [arr objectAtIndex:value];
}

@end

