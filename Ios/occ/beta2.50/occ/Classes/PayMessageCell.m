//
//  PayMessageCell.m
//  occ
//
//  Created by RS on 13-8-26.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "PayMessageCell.h"

@implementation PayMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        _lineImageView=[CommonMethods lineWithWithType:OCCLineType3];
        [self.contentView addSubview:_lineImageView];
        
        _textView=[[SSTextView alloc]init];
        [_textView setFrame:CGRectZero];
        [_textView setText:@""];
        [_textView setPlaceholder:@"给商家留言"];
        [_textView setPlaceholderColor:COLOR_999999];
        [_textView setBackgroundColor:[UIColor whiteColor]];
        [_textView setFont:FONT_12];
        _textView.layer.cornerRadius=5.0;
        _textView.layer.masksToBounds=YES;
        _textView.layer.borderColor=COLOR_999999.CGColor;
        _textView.layer.borderWidth=.5;
        _textView.delegate=self;
        [self.contentView addSubview:_textView];
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        [topView setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
        [topView setItems:buttonsArray];
        [_textView setInputAccessoryView:topView];
        
        UIImageView *backgroundView=[[UIImageView alloc]init];
        [backgroundView setImage:[[UIImage imageNamed:@"list_bill_mid"]resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2)]];
        
        UIImageView *selectedBackgroundView=[[UIImageView alloc]init];
        [selectedBackgroundView setImage:[[UIImage imageNamed:@"list_bill_mid"]resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2)]];
        
        [self setBackgroundView:backgroundView];
        [self setSelectedBackgroundView:selectedBackgroundView];
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
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(10, 0, 300, self.frame.size.height);
    self.contentView.frame=CGRectMake(10, 0, 300, self.contentView.frame.size.height);
    
    _lineImageView.frame=CGRectMake(10, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-20, 1);
    _textView.frame=CGRectInset(self.contentView.bounds, 5, 5);
}

#pragma mark -
#pragma mark UITextViewDelegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    UITableView *tableView = (UITableView *)self.superview;
    if (![tableView isKindOfClass:[UITableView class]]) tableView = (UITableView *)tableView.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [_data setObject:textView.text forKey:@"message"];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

-(void)setData:(NSMutableDictionary*)data
{
    _data=data;
    self.textView.text=[data objectForKey:@"message"];
}

-(void)dismissKeyBoard
{
    [_textView resignFirstResponder];
}

@end
