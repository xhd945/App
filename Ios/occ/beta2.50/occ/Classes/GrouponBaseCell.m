//
//  GrouponBaseCell.m
//  occ
//
//  Created by RS on 13-9-9.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "GrouponBaseCell.h"

@implementation GrouponBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setFont:FONT_20];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setText:[NSString stringWithFormat:@"商品名称"]];
        [_nameLabel setFrame:CGRectZero];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setNumberOfLines:0];
        [self.contentView addSubview:_nameLabel];
        
        _btn1 = [[UIButton alloc]init];
        [_btn1 setFrame:CGRectZero];
        [_btn1 setImage:[UIImage imageNamed:@"pei.png"] forState:UIControlStateNormal];
        _btn1.titleLabel.font = FONT_12;
        [_btn1 setTitleColor:COLOR_000000 forState:UIControlStateNormal];
        [_btn1 setTitle:@"无理由退货" forState:UIControlStateNormal];
        [_btn1 setUserInteractionEnabled:NO];
        [self.contentView addSubview:_btn1];
        
        _btn2 = [[UIButton alloc]init];
        [_btn2 setFrame:CGRectZero];
        [_btn2 setImage:[UIImage imageNamed:@"qian.png"] forState:UIControlStateNormal];
        _btn2.titleLabel.font = FONT_12;
        [_btn2 setTitleColor:COLOR_000000 forState:UIControlStateNormal];
        [_btn2 setTitle:@"过期退款" forState:UIControlStateNormal];
        [_btn2 setUserInteractionEnabled:NO];
        [self.contentView addSubview:_btn2];
        
        _btn3 = [[UIButton alloc]init];
        [_btn3 setFrame:CGRectZero];
        [_btn3 setImage:[UIImage imageNamed:@"tui.png"] forState:UIControlStateNormal];
        _btn3.titleLabel.font = FONT_12;
        [_btn3 setTitleColor:COLOR_000000 forState:UIControlStateNormal];
        [_btn3 setTitle:@"假一赔三" forState:UIControlStateNormal];
        [_btn3 setUserInteractionEnabled:NO];
        [self.contentView addSubview:_btn3];
        
        UIImage *image=[UIImage imageNamed:@"list_bgwhite_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:image];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        
        [self setBackgroundView:backgroundView];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
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

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    [_nameLabel setFrame:CGRectMake(10,10, 280, 20)];
    [_nameLabel sizeToFit];
    [_btn1 setFrame:CGRectMake(5,
                               self.bounds.size.height-HEADER_HEIGHT,
                               _btn1.frame.size.width,
                               _btn1.frame.size.height)];
    [_btn2 setFrame:CGRectMake(5+_btn1.frame.size.width,
                               self.bounds.size.height-HEADER_HEIGHT,
                               _btn2.frame.size.width,
                               _btn2.frame.size.height)];
    [_btn3 setFrame:CGRectMake(5+_btn1.frame.size.width+_btn2.frame.size.width,
                               self.bounds.size.height-HEADER_HEIGHT,
                               _btn3.frame.size.width,
                               _btn3.frame.size.height)];
}

-(void)setData:(NSDictionary*)data
{
    _data=data;
    [_nameLabel setText:[data objectForKey:@"name"]];
    _btn1.frame=CGRectMake(0, 0, [[_data objectForKey:@"isReturnItem"]intValue]==1?95:0,44);
    _btn2.frame=CGRectMake(0, 0, [[_data objectForKey:@"isReturnMoney"]intValue]==1?95:0,44);
    _btn3.frame=CGRectMake(0, 0, [[_data objectForKey:@"isPaidfor"]intValue]==1?95:0,44);
}

-(float)getCellHeight
{
    NSString* text=[_data objectForKey:@"name"];
    int height=[CommonMethods heightForString:text andFont:FONT_20 andWidth:kBargainLabelWidth];
    return height+HEADER_HEIGHT+10;
}

@end
