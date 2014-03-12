//
//  ShopFilterViewController.m
//  occ
//
//  Created by RS on 13-8-22.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "ShopFilterViewController.h"
#import "GoodsFilterCell.h"

@interface ShopFilterViewController ()

@end

@implementation ShopFilterViewController

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
                @"7",@"image",
                @"价格区间：",@"title",
                @"0-∞",@"text",
                @"0",@"check",
                nil],
               [NSMutableDictionary dictionaryWithObjectsAndKeys:
                @"2",@"image",
                @"店家服务:",@"title",
                @"",@"text",
                @"0",@"check",
                nil],
               nil];
    
    _secondDataList=[NSMutableArray arrayWithObjects:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"0",@"check",
                      @"多倍积分",@"title",
                      nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"0",@"check",
                      @"VIP",@"title",
                      nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"0",@"check",
                      @"折扣",@"title",
                      nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"0",@"check",
                      @"包邮",@"title",
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
    [titleLable setText:[NSString stringWithFormat:@"在 \"%@\" 分类下筛选",_titleString]];
    [titleLable setFrame:CGRectMake(SCREEN_WIDTH - LEFTVIEW_WIDTH + 15, 5, rightButton.frame.origin.x - (SCREEN_WIDTH - LEFTVIEW_WIDTH + 15), HEADER_HEIGHT-5)];
    [headView addSubview:titleLable];
    _titleLable=titleLable;
    
    UIImage *whiteImage=[UIImage imageNamed:@"btn_white.png"];
    whiteImage=[whiteImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4, 0.0, 4)];
    
    //清除多余的Table线
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    emptyView.backgroundColor = [UIColor clearColor];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - LEFTVIEW_WIDTH,HEADER_HEIGHT,LEFTVIEW_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setAllowsMultipleSelection:NO];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:emptyView];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS4];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    //价格
    UIView *foot1TableView=[[UIView alloc]init];
    [foot1TableView setFrame:CGRectMake(0, 0, _tableView.frame.size.width, 90)];
    [foot1TableView setBackgroundColor:[UIColor clearColor]];
    [foot1TableView setClipsToBounds:YES];
    _foot1TableView=foot1TableView;
    
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
    _rangeSlider=rangeSlider;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, foot1TableView.frame.size.height - 1, foot1TableView.frame.size.width, 1)];
    lineView.backgroundColor = COLOR_CELL_LINE_CLASS4;
    [foot1TableView addSubview:lineView];
    
    //店铺优惠
    UIView *foot2TableView=[[UIView alloc]init];
    [foot2TableView setFrame:CGRectMake(0, 0, _tableView.frame.size.width, 44*4)];
    [foot2TableView setBackgroundColor:[UIColor clearColor]];
    [foot2TableView setClipsToBounds:YES];
    _foot2TableView = foot2TableView;
    
    for (int i=0; i < self.secondDataList.count; i++)
    {
        UILabel *label=[[UILabel alloc]init];
        [label setFrame:CGRectMake(20, 44*i, foot2TableView.frame.size.width - 44 - 10 - 20, 44)];
        [label setText:[[self.secondDataList objectAtIndex:i]objectForKey:@"title"]];
        [label setFont:FONT_16];
        label.textColor = COLOR_D1BEB0;
        [label setBackgroundColor:[UIColor clearColor]];
        [foot2TableView addSubview:label];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setFrame:CGRectMake(foot2TableView.frame.size.width - 44, 44*i, 44, 44)];
        [btn setImage:[UIImage imageNamed:@"checkbox_nor.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:COLOR_D1BEB0 forState:UIControlStateNormal];
        [btn.titleLabel setFont:FONT_14];
        [btn setTag:i];
        [foot2TableView addSubview:btn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44*(i+1)-1, foot2TableView.frame.size.width, 1)];
        lineView.backgroundColor = COLOR_CELL_LINE_CLASS4;
        [foot2TableView addSubview:lineView];
    }
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
                                             if ([controller.centerController respondsToSelector:@selector(reloadShopDataList)]) {
                                                 [controller.centerController performSelector:@selector(reloadShopDataList)];
                                             }
                                         }];
}

- (void)doAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSMutableDictionary *data=[self.secondDataList objectAtIndex:btn.tag];
    if ([[data objectForKey:@"check"]intValue]==1) {
        [data setObject:@"0" forKey:@"check"];
        [btn setImage:[UIImage imageNamed:@"checkbox_nor.png"] forState:UIControlStateNormal];
    }else{
        [data setObject:@"1" forKey:@"check"];
        [btn setImage:[UIImage imageNamed:@"checkbox_press.png"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (int i=0; i<self.secondDataList.count; i++) {
        NSDictionary *data=[self.secondDataList objectAtIndex:i];
        if ([[data objectForKey:@"check"]intValue]==1) {
            [arr addObject:[data objectForKey:@"title"]];
        }
    }
    
    NSMutableDictionary *data2=[self.dataList objectAtIndex:1];
    [data2 setObject:[arr componentsJoinedByString:@","] forKey:@"text"];
    GoodsFilterCell *cell=(GoodsFilterCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell setData:data2];
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

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSMutableDictionary *data=[self.dataList objectAtIndex:section];
    if ([[data objectForKey:@"check"]intValue]==1) {
        if (section==0) {
            return _foot1TableView.frame.size.height;
        }
        if (section==1) {
            return _foot2TableView.frame.size.height;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return _foot1TableView;
    }
    if (section==1) {
        return _foot2TableView;
    }
    return nil;
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
    NSMutableDictionary *data=[self.dataList objectAtIndex:indexPath.section];
    if ([[data objectForKey:@"check"]intValue]==1) {
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

