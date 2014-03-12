//
//  GoodsBaseCell.m
//  occ
//
//  Created by RS on 13-11-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GoodsHeadCell.h"
#import "ShowBigImageViewController.h"
#import "AppDelegate.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation GoodsHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.pathDictionary = [NSMutableDictionary dictionary];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = FONT_16;
        _nameLabel.textColor = COLOR_333333;
        _nameLabel.numberOfLines=2;
        _nameLabel.text=@"";
        [self.contentView addSubview:_nameLabel];
        
        UIScrollView *scrollView=[[UIScrollView alloc]init];
        [scrollView setDelegate:self];
        [scrollView setFrame:CGRectMake(0, 45, 240, 200)];
        [scrollView setCenter:CGPointMake(SCREEN_WIDTH/2, scrollView.center.y)];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [self.contentView addSubview:scrollView];
        _scrollView=scrollView;
        
        UIView *alphaView=[[UIView alloc]init];
        alphaView.frame=CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y+scrollView.frame.size.height-30, scrollView.frame.size.width, 30);
        alphaView.backgroundColor=COLOR_26221F;
        alphaView.alpha=0.75;
        [self.contentView addSubview:alphaView];
        
        _scoreButton = [[UIButton alloc]init];
        [_scoreButton setFrame:CGRectMake(0, 0, 30, 30)];
        [_scoreButton setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [_scoreButton setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateHighlighted];
        [_scoreButton.titleLabel setFont:FONT_12];
        [_scoreButton setTitleEdgeInsets:UIEdgeInsetsMake(1,0,0,0)];
        [_scoreButton setUserInteractionEnabled:NO];
        [alphaView addSubview:_scoreButton];
        
        UILabel *numLabel = [[UILabel alloc]init];
        numLabel.frame=CGRectMake(40, 0, alphaView.frame.size.width, alphaView.frame.size.height);
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.font = FONT_14;
        numLabel.textColor = COLOR_FFFFFF;
        numLabel.text=@"0条评价";
        [alphaView addSubview:numLabel];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(alphaView.frame.size.width-100, 0, 100, alphaView.frame.size.height)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
        [alphaView addSubview:_pageControl];
        
        UILabel *priceLabel=[[UILabel alloc]init];
        priceLabel.frame=CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y+_scrollView.frame.size.height, 50, 30);
        priceLabel.textColor=COLOR_666666;
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.textAlignment=UITextAlignmentLeft;
        priceLabel.text=@"价格:";
        priceLabel.font=FONT_12;
        [self.contentView addSubview:priceLabel];
        
        _plPriceLabel=[[UILabel alloc]init];
        _plPriceLabel.textColor=COLOR_D91F1E;
        _plPriceLabel.backgroundColor=[UIColor clearColor];
        _plPriceLabel.textAlignment=UITextAlignmentLeft;
        _plPriceLabel.font=FONT_22;
        [self.contentView addSubview:_plPriceLabel];
        
        _listPriceLabel=[[OCCStrikeThroughLabel alloc]init];
        _listPriceLabel.textColor=COLOR_453D3A;
        _listPriceLabel.backgroundColor=[UIColor clearColor];
        _listPriceLabel.textAlignment=UITextAlignmentLeft;
        _listPriceLabel.font=FONT_12;
        [self.contentView addSubview:_listPriceLabel];

        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [self setBackgroundView:nil];
    [super layoutSubviews];
    //self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    //self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    //self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);

    _nameLabel.frame=CGRectMake(0, 0, SCREEN_WIDTH-20, 20);
    [_nameLabel sizeToFit];
    _plPriceLabel.frame=CGRectMake(_scrollView.frame.origin.x+30, _scrollView.frame.origin.y+_scrollView.frame.size.height, SCREEN_WIDTH, 30);
    [_plPriceLabel sizeToFit];
    _plPriceLabel.frame=CGRectMake(_scrollView.frame.origin.x+30, _scrollView.frame.origin.y+_scrollView.frame.size.height, _plPriceLabel.frame.size.width, 30);
    
    _listPriceLabel.frame=CGRectMake(_plPriceLabel.frame.origin.x+_plPriceLabel.frame.size.width+5, _plPriceLabel.frame.origin.y, SCREEN_WIDTH, 30);
    [_listPriceLabel sizeToFit];
    _listPriceLabel.frame=CGRectMake(_plPriceLabel.frame.origin.x+_plPriceLabel.frame.size.width+5, _listPriceLabel.frame.origin.y, SCREEN_WIDTH, 30);
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat pageWidth = aScrollView.frame.size.width;
    NSInteger curPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [_pageControl setCurrentPage:curPage];
}

#pragma mark - Gallery Delegate

// 某张图片的来源
- (void)imageAtIndex:(NSInteger)index photoView:(MJPhotoView *)photoView
{
    NSLog(@"-------------------setphotopath******************");
    NSString *path = nil;

    NSArray *imageList = [_shopData objectForKey:@"imageList"];
    if (imageList.count == 0) {
        return ;
    }
    
    id object = [self.pathDictionary objectForKey:[NSString stringWithFormat:@"%d",index]];
    if (object)
    {
        path = (NSString *)object;
        [photoView setPhotoPath:[NSURL URLWithString:path]];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                       ^{
                           NSString *urlString = [imageList objectAtIndex:index];
                           NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                      [[Singleton sharedInstance]TGC], @"TGC",
                                                      urlString,@"picPath",
                                                      [NSString stringWithFormat:@"%0.f",SCREEN_HEIGHT],@"panelHeight",
                                                      [NSString stringWithFormat:@"%0.f",SCREEN_WIDTH],@"panelWidth",
                                                      nil];
                           
                           NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                           
                           
                           ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:pictureHandle_URL andData:reqdata andDelegate:nil];
                           
                           SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                           NSString *url = nil;
                           NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                           if ([[root objectForKey:@"code"]intValue]==0){
                               NSDictionary *data=[root objectForKey:@"data"];
                               url = [data objectForKey:@"picPath"];
                               NSLog(@"the translate image path:%@",path);
                           }
                           
                           [photoView setPhotoPath:[NSURL URLWithString:url]];
                           if (url) {
                               [self.pathDictionary setObject:url forKey:[NSString stringWithFormat:@"%d",index]];
                           }
                       });
    }
}

#pragma mark -
#pragma mark showBigIamge

- (void)showBigImage:(id)sender
{
    UIView *view = sender;
    NSArray *imageList = [_shopData objectForKey:@"imageList"];
    tapIndex = view.tag;
#if 0
    ShowBigImageViewController *viewController=[[ShowBigImageViewController alloc]init];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:NO];
    [viewController initWithImageList:imageList andSelectedIndex:tapIndex];
#else
    int count = imageList.count;
    NSMutableArray *pathArray = [NSMutableArray array];
    if (count > 0)
    {
        // 1.封装图片数据
        for (int i = 0; i<count; i++) {
            
            NSString *urlString = [imageList objectAtIndex:i];

            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:urlString]; // 图片路径
            
            UIImageView *imageView = (UIImageView *)[_scrollView viewWithTag:(0x100+i)];
            if (imageView) {
                photo.srcImageView = imageView; // 来源于哪个UIImageView
            }
            [pathArray addObject:photo];

        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = tapIndex; // 弹出相册时显示的第一张图片是？
        browser.delegate = self;
        browser.photos = pathArray; // 设置所有的图片
        [browser show];
    }
#endif
}

-(void)setData:(NSDictionary*)data
{
    _shopData=data;
    
    [_nameLabel setText:[data objectForKey:@"name"]];
    
    NSString *plPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"plPrice"]];
    [_plPriceLabel setText:plPrice];
    
    NSString *listPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"listPrice"]];
    [_listPriceLabel setText:listPrice];
    
    [_scoreButton setTitle:[NSString stringWithFormat:@"%@",[data objectForKey:@"evaluation"]] forState:UIControlStateNormal];
    
    NSArray *imageList = [data objectForKey:@"imageList"];
    _pageControl.numberOfPages=imageList.count;
    [_scrollView setContentSize:CGSizeMake([imageList count]*_scrollView.frame.size.width, _scrollView.frame.size.height)];
    for (int i = 0; i<[imageList count]; i++)
    {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        photoImageView.backgroundColor = [UIColor clearColor];
        photoImageView.tag = 0x100+i;
        photoImageView.userInteractionEnabled = YES;
        photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:photoImageView];
        
        NSString *urlString = [imageList objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [photoImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage] options:SDWebImageRetryFailed];
        
        UIButton *buttonTapend = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonTapend addTarget:self action:@selector(showBigImage:) forControlEvents:UIControlEventTouchUpInside];
        buttonTapend.frame = CGRectMake(0, 0, photoImageView.frame.size.width, photoImageView.frame.size.height);
        buttonTapend.tag=i;
        [photoImageView addSubview:buttonTapend];
    }
    
    if ([imageList count]>1)
    {
        _pageControl.hidden=NO;
    }
    else
    {
        _pageControl.hidden=YES;
    }
}

@end
