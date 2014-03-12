//
//  SearchSuggestViewController.m
//  occ
//
//  Created by RS on 13-8-10.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "SearchCategory2ViewController.h"
#import "SearchResultViewController.h"
#import "ShopFilterViewController.h"
#import "AppDelegate.h"
#import "CommonMethods.h"
#import "UILabel+Extra.h"
#import "OCCDefine.h"
#import "SearchCategory2Cell.h"

@interface SearchCategory2ViewController ()

@end

@implementation SearchCategory2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.titleLable = [[UILabel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = COLOR_BG_CLASSONE;

    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassOne];
    [self.view addSubview:topImageView];
    
    UIView *leftButton = [CommonMethods backNavigationButtonWithTarget:self andSelector:@selector(doBack:)];
    [topImageView addSubview:leftButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeNavigationTitle];
    [titleLable setText:self.titleLable.text];
    [titleLable setFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [self.view addSubview:titleLable];
    _titleLable=titleLable;
    
    OCCTableView *tableView=[[OCCTableView alloc]init];
    [tableView setFrame:CGRectMake(0,HEADER_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-FOOTER_HEIGHT)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS2];
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
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SearchCategory2CellIdentifier = @"SearchCategory2CellIdentifier";
    
    SearchCategory2Cell *cell = (SearchCategory2Cell *)[tableView dequeueReusableCellWithIdentifier:SearchCategory2CellIdentifier];
    if (cell == nil)
    {
        cell = [[SearchCategory2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCategory2CellIdentifier];
    }

    [cell setData:[_dataList objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableDictionary *dic=[_dataList objectAtIndex:indexPath.row];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:2];
    [data setObject:[dic objectForKey:@"name"] forKey:KEY_KEYWORD];
    [data setObject:[NSNumber numberWithInteger:OCCSearchClassiFicationItem] forKey:KEY_CLASSIFICATION];
    [data setObject:[[dic objectForKey:@"data"]objectForKey:KEY_CATEGORYID] forKey:KEY_CATEGORYID];
    [data setObject:[dic objectForKey:@"name"] forKey:KEY_CATEGORYNAME];

    SearchResultViewController *centerController=[[SearchResultViewController alloc]init];
    centerController.data = data;
    [centerController.titleLable setText:cell.textLabel.text];
    
    IIViewDeckController *deckController=[[IIViewDeckController alloc]init];
    deckController.leftController=nil;
    deckController.centerController=centerController;
    //deckController.rightController=nil;
    deckController.leftSize = 60;
    deckController.rightSize = 60;
    deckController.openSlideAnimationDuration = 0.3f;
    deckController.closeSlideAnimationDuration = 0.3f;
    deckController.bounceOpenSideDurationFactor = 0.3f;
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:deckController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [_dataList count]>0?1:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
