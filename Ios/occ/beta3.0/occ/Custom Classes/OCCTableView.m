//
//  OCCTableView.m
//  occ
//
//  Created by RS on 13-9-23.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OCCTableView.h"

@implementation OCCTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundView:nil];
        
        UIView *nodataView=[[UIView alloc]init];
        [nodataView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [nodataView setHidden:YES];
        [self addSubview:nodataView];
        _nodataView=nodataView;
        
        UIImage *image=[UIImage imageNamed:@"no_list"];
        UIImageView *imageView=[[UIImageView alloc]init];
        [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        [imageView setImage:image];
        [nodataView addSubview:imageView];
        _imageView=imageView;
        
        UILabel *tipLabel=[[UILabel alloc]init];
        [tipLabel setFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+10, SCREEN_WIDTH, 30)];
        tipLabel.text=@"抱歉,没有相关数据!";
        tipLabel.font=FONT_16;
        tipLabel.textColor=COLOR_666666;
        tipLabel.backgroundColor=[UIColor clearColor];
        tipLabel.textAlignment=NSTextAlignmentCenter;
        [nodataView addSubview:tipLabel];
        _tipLabel=tipLabel;
        
        self.loading=YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self=[super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundView:nil];
        
        UIView *nodataView=[[UIView alloc]init];
        [nodataView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [nodataView setHidden:YES];
        [self addSubview:nodataView];
        _nodataView=nodataView;
        
        UIImage *image=[UIImage imageNamed:@"no_list"];
        UIImageView *imageView=[[UIImageView alloc]init];
        [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        [imageView setImage:image];
        [nodataView addSubview:imageView];
        _imageView=imageView;
        
        UILabel *tipLabel=[[UILabel alloc]init];
        [tipLabel setFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height, SCREEN_WIDTH, 30)];
        tipLabel.text=@"抱歉,没有相关数据!";
        tipLabel.font=FONT_16;
        tipLabel.textColor=COLOR_666666;
        tipLabel.backgroundColor=[UIColor clearColor];
        tipLabel.textAlignment=NSTextAlignmentCenter;
        [nodataView addSubview:tipLabel];
        _tipLabel=tipLabel;
        
        self.loading=YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andNoDataType:(DataType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        UIView *nodataView=[[UIView alloc]init];
        [nodataView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [nodataView setHidden:YES];
        [self addSubview:nodataView];
        _nodataView=nodataView;
        
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.center=CGPointMake(SCREEN_WIDTH/2,100);
        [nodataView addSubview:imageView];
        _imageView=imageView;
        
        switch (type) {
            case DataTypeShop:
            {
                UIImage *image=[UIImage imageNamed:@"no_shop"];
                [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
                [imageView setImage:image];
            }
                break;
            case DataTypeGrouponCode:
            case DataTypeCouponCode:
            case DataTypeGoods:
            {
                UIImage *image=[UIImage imageNamed:@"no_goods"];
                [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
                [imageView setImage:image];
            }
                break;
            case DataTypeOther:
            default:
            {
                UIImage *image=[UIImage imageNamed:@"no_list"];
                [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
                [imageView setImage:image];
            }
                break;
        }

        UILabel *tipLabel=[[UILabel alloc]init];
        [tipLabel setFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height, SCREEN_WIDTH, 40)];
        tipLabel.text=@"";
        tipLabel.font=FONT_16;
        tipLabel.textColor=COLOR_000000;
        tipLabel.backgroundColor=[UIColor clearColor];
        tipLabel.textAlignment=NSTextAlignmentCenter;
        [nodataView addSubview:tipLabel];
        _tipLabel=tipLabel;
        
        switch (type) {
            case DataTypeShop:
            {
                self.tipLabel.text=@"抱歉,没有找到相关店铺!";
            }
                break;
            case DataTypeGoods:
            {
                self.tipLabel.text=@"抱歉,没有找到相关商品!";
            }
                break;
            case DataTypeCart:
            {
                self.tipLabel.text=@"您的购物车还没有商品,去挑选几件吧!";
            }
                break;
            case DataTypeFavoriteShop:
            {
                self.tipLabel.text=@"您还没有收藏任何店铺!";
            }
                break;
            case DataTypeFavoriteGoods:
            {
                self.tipLabel.text=@"您还没有收藏任何商品!";
            }
                break;
            case DataTypeGrouponCode:
            {
                self.tipLabel.text=@"抱歉,没有相关团购劵!";
            }
                break;
            case DataTypeCouponCode:
            {
                self.tipLabel.text=@"抱歉,没有相关优惠劵!";
            }
                break;
            case DataTypeOther:
            default:
                break;
        }
    }
    
    self.loading=YES;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)reloadData;  
{
	[super reloadData];
    if ([self getDataCount]==0)
    {
        if (self.loading)
        {
            [_nodataView setHidden:YES];
        }
        else
        {
            [_nodataView setHidden:NO];
        }
        _nodataView.frame=CGRectMake(0, self.tableHeaderView.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    else
    {
        [_nodataView setHidden:YES];
        [self setSeparatorStyle:self.style==UITableViewStyleGrouped?UITableViewCellSeparatorStyleNone:UITableViewCellSeparatorStyleSingleLine];
    }
}

- (int)getDataCount
{
    int total=0;
    for (int i=0; i<[self numberOfSections]; i++)
    {
        total +=[self numberOfRowsInSection:i];
    }
    return total;
}

-(void)setLoading:(BOOL)loading
{
    _loading=loading;
}

-(void)setDataType:(DataType)dataType
{
    switch (dataType) {
        case DataTypeShop:
        {
            self.tipLabel.text=@"抱歉,没有找到相关店铺!";
            UIImage *image=[UIImage imageNamed:@"no_shop"];
            [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [self.imageView setImage:image];
            self.imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        }
            break;
        case DataTypeGoods:
        {
            self.tipLabel.text=@"抱歉,没有找到相关商品!";
            UIImage *image=[UIImage imageNamed:@"no_goods"];
            [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [self.imageView setImage:image];
            self.imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        }
            break;
        case DataTypeCart:
        {
            self.tipLabel.text=@"您的购物车还没有商品,去挑选几件吧!";
            UIImage *image=[UIImage imageNamed:@"no_goods"];
            [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [self.imageView setImage:image];
            self.imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        }
            break;
        case DataTypeFavoriteShop:
        {
            self.tipLabel.text=@"您还没有收藏任何店铺!";
            UIImage *image=[UIImage imageNamed:@"no_shop"];
            [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [self.imageView setImage:image];
            self.imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        }
            break;
        case DataTypeFavoriteGoods:
        {
            self.tipLabel.text=@"您还没有收藏任何商品!";
            UIImage *image=[UIImage imageNamed:@"no_goods"];
            [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [self.imageView setImage:image];
            self.imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        }
            break;
        case DataTypeGrouponCode:
        {
            self.tipLabel.text=@"抱歉,没有相关团购劵!";
            UIImage *image=[UIImage imageNamed:@"no_goods"];
            [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [self.imageView setImage:image];
            self.imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        }
            break;
        case DataTypeCouponCode:
        {
            self.tipLabel.text=@"抱歉,没有相关优惠劵!";
            UIImage *image=[UIImage imageNamed:@"no_goods"];
            [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [self.imageView setImage:image];
            self.imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        }
            break;
        case DataTypeOther:
        default:
        {
            UIImage *image=[UIImage imageNamed:@"no_list"];
            [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [self.imageView setImage:image];
            self.imageView.center=CGPointMake(SCREEN_WIDTH/2,90);
        }
            break;
    }
}

@end
