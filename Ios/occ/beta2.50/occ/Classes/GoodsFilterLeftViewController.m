//
//  GoodsFilterLeftViewController.m
//  occ
//
//  Created by RS on 13-10-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsFilterLeftViewController.h"
#import "GoodsFilterCell.h"
#import "RulerView.h"

#define kSectionHeight 44

@interface GoodsFilterLeftViewController ()

@end

@implementation GoodsFilterLeftViewController

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
    
    _dataList=[[NSMutableArray alloc]init];
    _firstDataList=[[NSMutableArray alloc]init];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = COLOR_BG_CLASSTWO;
    
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView setBackgroundColor:COLOR_C11016];
    [self.view addSubview:headView];
    
    // top背景
    UIView *topImageView = [CommonMethods navigationViewWithType:OCCNavigationTypeClassThree];
    [headView addSubview:topImageView];
    
    UIView *rightButton = [CommonMethods navigationButtonWithTarget:self andSelector:@selector(doConfirm:) andButtonType:OCCNavigationButtonTypeCheck andLeft:NO];
    [headView addSubview:rightButton];
    
    UILabel *titleLable = [[UILabel alloc]init];
    [titleLable labelWithType:OCCLabelTypeRightNavigationTitle];
    [titleLable setText:@"在分类下筛选"];
    [titleLable setFrame:CGRectMake(15, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    [headView addSubview:titleLable];
    _titleLable=titleLable;
    
    //没有标题栏
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, HEADER_HEIGHT , LEFTVIEW_WIDTH, SCREEN_HEIGHT-HEADER_HEIGHT) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setAllowsMultipleSelection:NO];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setSeparatorColor:COLOR_CELL_LINE_CLASS4];
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    [self sortData];
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

- (void)doHome:(id)sender
{
    [self.viewDeckController closeRightViewAnimated:YES];
}

- (void)doConfirm:(id)sender
{
    [self.viewDeckController closeRightViewAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_firstDataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
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
    static NSString *GoodsFilterCellIdentifier=@"GoodsFilterCellIdentifier";
    
    GoodsFilterCell *cell = (GoodsFilterCell *)[tableView dequeueReusableCellWithIdentifier:GoodsFilterCellIdentifier];
    if (cell == nil)
    {
        cell = [[GoodsFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GoodsFilterCellIdentifier];
    }
    
    NSDictionary *data = [_firstDataList objectAtIndex:indexPath.row];
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [_firstDataList objectAtIndex:indexPath.row];
    self.data=data;
    [self.viewDeckController closeLeftViewAnimated:YES
                                        completion:^(IIViewDeckController *controller, BOOL success) {
                                            if ([controller.centerController respondsToSelector:@selector(filterDataList)]) {
                                                [controller.centerController performSelector:@selector(filterDataList)];
                                            }
                                        }];
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

- (void)sortData
{
    _firstDataList=[[NSMutableArray alloc]init];
    for (NSDictionary *item in _dataList)
    {
        int id=[[item objectForKey:@"id"]intValue];
        int level=[[item objectForKey:@"level"]intValue];
        if (level==1) {
            NSMutableDictionary *data=[[NSMutableDictionary alloc]initWithDictionary:item];
            [data setObject:[NSNumber numberWithBool:YES] forKey:@"title"];
            [_firstDataList addObject:data];
            for (NSDictionary *item in _dataList)
            {
                int parentId=[[item objectForKey:@"parentId"]intValue];
                int parentLevel=[[item objectForKey:@"level"]intValue];
                if (id==parentId && parentLevel==2)
                {
                    NSMutableDictionary *data=[[NSMutableDictionary alloc]initWithDictionary:item];
                    [data setObject:[NSNumber numberWithBool:NO] forKey:@"title"];
                    [_firstDataList addObject:data];
                }
            }
        }
    }
}

-(void)setDataList:(NSArray *)dataList
{
    _dataList=[[NSArray alloc]initWithArray:dataList];
    [self sortData];
    [self.tableView reloadData];
}

@end
