//
//  GrouponHeadCell.m
//  occ
//
//  Created by plocc on 13-12-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponHeadCell.h"
#import "ShowBigImageViewController.h"
#import "AppDelegate.h"

@implementation GrouponHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIScrollView *scrollView=[[UIScrollView alloc]init];
        [scrollView setDelegate:self];
        [scrollView setFrame:CGRectMake(0, 0, 300, 200)];
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
        
        _numLabel = [[UILabel alloc]init];
        [_numLabel setFrame:CGRectMake(35,0, 280, alphaView.frame.size.height)];
        [_numLabel setTextColor:COLOR_FFFFFF];
        [_numLabel setFont:FONT_14];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setText:[NSString stringWithFormat:@"0人已购买"]];
        [_numLabel setTextAlignment:NSTextAlignmentLeft];
        [alphaView addSubview:_numLabel];
        
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setFrame:CGRectMake(10,0,280, alphaView.frame.size.height)];
        [_timeLabel setTextColor:COLOR_FFFFFF];
        [_timeLabel setFont:FONT_14];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setText:[NSString stringWithFormat:@""]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [alphaView addSubview:_timeLabel];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(alphaView.frame.size.width-100, 0, 100, alphaView.frame.size.height)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
        [alphaView addSubview:_pageControl];
        
        UILabel *priceLabel=[[UILabel alloc]init];
        priceLabel.frame=CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y+_scrollView.frame.size.height+5, 50, 30);
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
        
        _discountLabel=[[UILabel alloc]init];
        _discountLabel.textColor=COLOR_27813A;
        _discountLabel.backgroundColor=[UIColor clearColor];
        _discountLabel.textAlignment=UITextAlignmentLeft;
        _discountLabel.font=FONT_16;
        [self.contentView addSubview:_discountLabel];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _myTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    if (_myTimer!=nil)
    {
        [_myTimer invalidate];
        _myTimer=nil;
    }
}

- (void)layoutSubviews
{
    [self setBackgroundView:nil];
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    _plPriceLabel.frame=CGRectMake(_scrollView.frame.origin.x+30, _scrollView.frame.origin.y+_scrollView.frame.size.height+5, SCREEN_WIDTH, 30);
    [_plPriceLabel sizeToFit];
    _plPriceLabel.frame=CGRectMake(_scrollView.frame.origin.x+30, _scrollView.frame.origin.y+_scrollView.frame.size.height+5, _plPriceLabel.frame.size.width, 30);
    
    _listPriceLabel.frame=CGRectMake(_plPriceLabel.frame.origin.x+_plPriceLabel.frame.size.width+5, _plPriceLabel.frame.origin.y, SCREEN_WIDTH, 30);
    [_listPriceLabel sizeToFit];
    _listPriceLabel.frame=CGRectMake(_plPriceLabel.frame.origin.x+_plPriceLabel.frame.size.width+5, _listPriceLabel.frame.origin.y, _listPriceLabel.frame.size.width, 30);
    
    _discountLabel.frame=CGRectMake(_listPriceLabel.frame.origin.x+_listPriceLabel.frame.size.width+5, _listPriceLabel.frame.origin.y, SCREEN_WIDTH, 30);
    [_discountLabel sizeToFit];
    _discountLabel.frame=CGRectMake(_discountLabel.frame.origin.x, _discountLabel.frame.origin.y, _discountLabel.frame.size.width, _plPriceLabel.frame.size.height);
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat pageWidth = aScrollView.frame.size.width;
    NSInteger curPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [_pageControl setCurrentPage:curPage];
}

#pragma mark -
#pragma mark showBigIamge
- (void)showBigImage:(id)sender
{
    return;
    UIView *view = sender;
    NSArray *imageList = [_data objectForKey:@"imageList"];
    NSInteger index = view.tag;
    ShowBigImageViewController *viewController=[[ShowBigImageViewController alloc]init];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.navigationController pushViewController:viewController animated:NO];
    [viewController initWithImageList:imageList andSelectedIndex:index];
}

-(void)setData:(NSDictionary*)data
{
    _data=data;
    
    [_numLabel setText:[NSString stringWithFormat:@"%d人已购买",[[data objectForKey:@"sellNum"]intValue]]];
    
    NSString *plPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"plPrice"]];
    [_plPriceLabel setText:plPrice];
    
    NSString *listPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"listPrice"]];
    [_listPriceLabel setText:listPrice];
    
    float discount=[[data objectForKey:@"plPrice"]floatValue]/[[data objectForKey:@"listPrice"]floatValue];
    NSString *discountText=[NSString stringWithFormat:@"%.1f折",discount*10];
    [_discountLabel setText:discountText];
    
    if ([data objectForKey:@"evaluation"]!=nil)
    {
        [_scoreButton setTitle:[NSString stringWithFormat:@"%@",[data objectForKey:@"evaluation"]] forState:UIControlStateNormal];
    }
    else
    {
        [_scoreButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    NSArray *imageList = [data objectForKey:@"imageList"];
    _pageControl.numberOfPages=imageList.count;
    [_scrollView setContentSize:CGSizeMake([imageList count]*_scrollView.frame.size.width, _scrollView.frame.size.height)];
    for (int i = 0; i<[imageList count]; i++)
    {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        photoImageView.backgroundColor = [UIColor clearColor];
        photoImageView.userInteractionEnabled = YES;
        photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:photoImageView];
        
        NSString *urlString = [[imageList objectAtIndex:i]objectForKey:@"picturePath"];
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

-(void)handleTimer:(NSTimer *)timer
{
    [self downTime];
}

-(void)downTime
{
    if (_data==nil)
    {
        return;
    }
    
    GrouponStatusType type;
    long inputSeconds=0;
    long nowTime=(long)[[NSDate date] timeIntervalSince1970];
    long startTime=[[_data objectForKey:@"startDate"]longLongValue]/1000;
    long endTime=[[_data objectForKey:@"endDate"]longLongValue]/1000;
    if ([_data objectForKey:@"stockNum"]!=nil&&[[_data objectForKey:@"stockNum"]intValue]==0)
    {
        type=GrouponStatusTypeSellOut;
        [_numLabel setText:[NSString stringWithFormat:@"%d人已购买",[[_data objectForKey:@"sellNum"]intValue]]];
        [_timeLabel setText:@"卖光了"];
        return;
    }
    else if (nowTime<startTime )
    {
        inputSeconds=startTime-nowTime;
        type=GrouponStatusTypeWill;
        [_numLabel setText:@"即将开始"];
        //time
    }
    else if (nowTime>startTime && nowTime<endTime)
    {
        inputSeconds=endTime-nowTime;
        type=GrouponStatusTypeGoing;
        [_numLabel setText:[NSString stringWithFormat:@"%d人已购买",[[_data objectForKey:@"sellNum"]intValue]]];
        //time
    }
    else
    {
        type=GrouponStatusTypeOver;
        [_numLabel setText:[NSString stringWithFormat:@"%d人已购买",[[_data objectForKey:@"sellNum"]intValue]]];
        [_timeLabel setText:@"已结束"];
        return;
    }
    
    int hours = inputSeconds/3600;
    int minutes = (inputSeconds - hours*3600)/60;
    int seconds = inputSeconds - hours*3600 - minutes*60;
    NSString *strTime = @"";
    if (hours<24)
    {
        if (type==GrouponStatusTypeWill)
        {
            strTime = [NSString stringWithFormat:@"%d小时%d分%d秒后开始",hours,minutes,seconds];
        }
        else if (type==GrouponStatusTypeGoing)
        {
            strTime = [NSString stringWithFormat:@"还剩 %d小时%d分%d秒",hours,minutes,seconds];
        }
        
    }
    else
    {
        int days = hours/24;
        int leftHours = hours%24;
        if (type==GrouponStatusTypeWill)
        {
            strTime = [NSString stringWithFormat:@"%d天%d小时%d分%d秒后开始",days,leftHours,minutes,seconds];
        }
        else if (type==GrouponStatusTypeGoing)
        {
            strTime = [NSString stringWithFormat:@"还剩 %d天%d小时%d分%d秒",days,leftHours,minutes,seconds];
        }
    }
    [_timeLabel setText:strTime];
}

-(float)getCellHeight
{
    return 240.0;
}

@end
