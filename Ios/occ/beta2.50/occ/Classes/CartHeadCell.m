//
//  CartHeadCell.m
//  occ
//
//  Created by RS on 13-8-7.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "CartHeadCell.h"

@implementation CartHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView=[CommonMethods lineWithWithType:OCCLineType3];
        [self.contentView addSubview:_lineImageView];
        
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setTextColor:COLOR_D91F1E];
        [_nameLabel setHighlightedTextColor:COLOR_D91F1E];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:FONT_14];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFrame:CGRectMake(220, 0, 80, 20)];
        [self.contentView addSubview:_nameLabel];
        
        _editButton = [[UIButton alloc]init];
        [_editButton setFrame:CGRectZero];
        //[_editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        //[_editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateHighlighted];
        [_editButton setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        _editButton.titleLabel.font=FONT_14;
        [_editButton addTarget:self action:@selector(doEdit:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_editButton];
        
        _checkButton = [[UIButton alloc]init];
        [_checkButton setFrame:CGRectZero];
        [_checkButton setImage:[UIImage imageNamed:@"checkbox_nor.png"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"checkbox_nor.png"] forState:UIControlStateHighlighted];
        [_checkButton addTarget:self action:@selector(doCkeck:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkButton];
        
        UIImage *image=[UIImage imageNamed:@"list_bgwhite1_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height-10];
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:image];
        [self setBackgroundView:backgroundView];
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        [self setSelectedBackgroundView:selectedBackgroundView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    [_lineImageView setFrame:CGRectMake(10, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-20, 1)];
    
    self.nameLabel.frame=CGRectMake(40, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    
    self.checkButton.frame = CGRectMake(10, 0, 80, self.contentView.bounds.size.height);
    [self.checkButton setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    
    self.editButton.frame = CGRectMake(235, 0, 80, self.contentView.bounds.size.height);
}

- (void)doCkeck:(id)sender
{
    NSMutableArray *itemList=[_data objectForKey:@"itemList"];
    
    if ([[_data objectForKey:@"check"]boolValue]) {
        [_data setObject:[NSNumber numberWithBool:NO] forKey:@"check"];
        
        for (NSMutableDictionary *item in itemList) {
            [item setObject:[NSNumber numberWithBool:NO] forKey:@"check"];
        }
    }else{
        [_data setObject:[NSNumber numberWithBool:YES] forKey:@"check"];
        
        for (NSMutableDictionary *item in itemList) {
            [item setObject:[NSNumber numberWithBool:YES] forKey:@"check"];
        }
    }
    
    [_delegate cartCellDidChange];
}

- (void)doEdit:(id)sender
{
    if ([[_data objectForKey:@"edit"]boolValue]) {
        [_data setObject:[NSNumber numberWithBool:NO] forKey:@"edit"];
    }else{
        [_data setObject:[NSNumber numberWithBool:YES] forKey:@"edit"];
    }
    
    [_delegate cartCellDidChange];
}

-(void)setData:(NSMutableDictionary*)data
{
    _data =data;
    [_nameLabel setText:[data objectForKey:@"name"]];
    if ([[_data objectForKey:@"check"]boolValue]) {
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_press.png"] forState:UIControlStateNormal];
    }else{
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_nor.png"] forState:UIControlStateNormal];
    }
    
    if ([[_data objectForKey:@"edit"]boolValue]) {
        //[self.editButton setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        //[self.editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
}
@end
