//
//  OrderItemCell.m
//  occ
//
//  Created by RS on 13-9-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import "OrderItemCell.h"

#define kImageHeight 70
#define kNameLabelWidth 150

@implementation OrderItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _lineImageView= [[UIImageView alloc]init];
        [_lineImageView setImage:[UIImage imageNamed:@"line_dotted.png"]];
        [_lineImageView setHighlightedImage:[UIImage imageNamed:@"line_dotted.png"]];
        [_lineImageView setFrame:CGRectZero];
        _lineImageView.clipsToBounds=YES;
        [self.contentView addSubview:_lineImageView];
        
        _leftImageView= [[UIImageView alloc]init];
        [_leftImageView setFrame:CGRectZero];
        _leftImageView.clipsToBounds=YES;
        _leftImageView.layer.masksToBounds=YES;
        _leftImageView.layer.cornerRadius=5.0;
        _leftImageView.layer.borderWidth=0.0;
        _leftImageView.layer.borderColor=COLOR_999999.CGColor;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_leftImageView];
        
        UIImage *typeImage = [UIImage imageNamed:@"groupon_bg_list"];
        _typeImageView=[[UIImageView alloc]init];
        _typeImageView.image=typeImage;
        _typeImageView.frame=CGRectMake(kImageHeight - typeImage.size.width, 0, typeImage.size.width, typeImage.size.height);
        _typeImageView.backgroundColor = [UIColor clearColor];
        [_leftImageView addSubview:_typeImageView];
        
        _priceLabel = [[UILabel alloc]init];
        [_priceLabel setFrame:CGRectZero];
        [_priceLabel setFont:FONT_12];
        [_priceLabel setTextColor:COLOR_453D3A];
        [_priceLabel setHighlightedTextColor:COLOR_453D3A];
        [_priceLabel setTextAlignment:NSTextAlignmentRight];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_priceLabel];
        
        _numLabel = [[UILabel alloc]init];
        [_numLabel setFrame:CGRectZero];
        [_numLabel setFont:FONT_12];
        [_numLabel setTextColor:COLOR_453D3A];
        [_numLabel setHighlightedTextColor:COLOR_453D3A];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_numLabel];
        
        _sizeLabel = [[UILabel alloc]init];
        [_sizeLabel setFrame:CGRectZero];
        [_sizeLabel setFont:FONT_12];
        [_sizeLabel setTextColor:COLOR_999999];
        [_sizeLabel setHighlightedTextColor:COLOR_999999];
        [_sizeLabel setBackgroundColor:[UIColor clearColor]];
        _sizeLabel.hidden=YES;
        [self.contentView addSubview:_sizeLabel];
        
        _bargainLabel = [[UILabel alloc]init];
        [_bargainLabel setTextAlignment:NSTextAlignmentLeft];
        [_bargainLabel setTextColor:COLOR_999999];
        [_bargainLabel setBackgroundColor:[UIColor clearColor]];
        [_bargainLabel setNumberOfLines:0];
        [_bargainLabel setFont:FONT_12];
        [self.contentView addSubview:_bargainLabel];
        
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFrame:CGRectZero];
        [_nameLabel setFont:FONT_12];
        [_nameLabel setTextColor:COLOR_333333];
        [_nameLabel setHighlightedTextColor:COLOR_333333];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setNumberOfLines:2];
        [_nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:_nameLabel];

        _tuiButton = [[UIButton alloc]init];
        [_tuiButton setFrame:CGRectZero];
        [_tuiButton setBackgroundImage:[[UIImage imageNamed:@"bg_white.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4, 4.0, 4)] forState:UIControlStateNormal];
        [_tuiButton addTarget:self action:@selector(doTui:) forControlEvents:UIControlEventTouchUpInside];
        _tuiButton.titleLabel.font = FONT_12;
        [_tuiButton setTitleColor:COLOR_000000 forState:UIControlStateNormal];
        [_tuiButton setTitle:@"退款" forState:UIControlStateNormal];
        //[self.contentView addSubview:_tuiButton];
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
    
    [self.lineImageView setFrame:CGRectMake(0, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width, 2)];
    
    self.leftImageView.frame = CGRectMake(10, 5, kImageHeight, kImageHeight);
    self.priceLabel.frame = CGRectMake(210, 5, 80, 20);
    self.numLabel.frame = CGRectOffset(self.priceLabel.frame, 0, 20);
    
    float height=[CommonMethods heightForString:_nameLabel.text andFont:_nameLabel.font andWidth:kNameLabelWidth];
    self.nameLabel.frame = CGRectMake(self.leftImageView.frame.origin.x+self.leftImageView.frame.size.width+10, self.leftImageView.frame.origin.y, kNameLabelWidth, height);
    [self.nameLabel sizeToFit];
    
    height=[CommonMethods heightForString:_bargainLabel.text andFont:_bargainLabel.font andWidth:kBargainLabelWidth];
    [self.bargainLabel setFrame:CGRectMake(self.leftImageView.frame.origin.x,self.leftImageView.frame.origin.y+self.leftImageView.frame.size.height+5, kBargainLabelWidth, height)];
    [self.bargainLabel sizeToFit];
    
    self.tuiButton.frame=CGRectMake(245, 50, 44, 26);
}

-(void)setData:(NSDictionary*)data
{
    _data=data;
    
    NSString *strURL  = [[data objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self.leftImageView setImageWithURL:url placeholderImage:[CommonMethods defaultImageWithType:OCCDefaultImageTypeImage]];
    
    if ([[data objectForKey:@"type"]intValue]==1)
    {
        self.typeImageView.hidden=NO;
    }
    else
    {
        self.typeImageView.hidden=YES;
    }
    
    NSString *itemName=[data objectForKey:@"itemName"];
    [_nameLabel setText:itemName];
    
    NSString *plPrice=[NSString stringWithFormat:@"￥%@",[data objectForKey:@"plPrice"]];
    [_priceLabel setText:plPrice];
    
    NSString *buyNum=[NSString stringWithFormat:@"×%@",[data objectForKey:@"buyNum"]];
    [_numLabel setText:buyNum];
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSMutableArray *itemBargainList=[data objectForKey:@"itemBargainList"];
    for (int i=0; i<[itemBargainList count]; i++) {
        NSDictionary *item=[itemBargainList objectAtIndex:i];
        if ([[item objectForKey:@"name"] isKindOfClass:[NSString class]]){
            [arr addObject:[item objectForKey:@"name"]];
        }
    }
    [_bargainLabel setText:[arr componentsJoinedByString:@"\n"]];
}

- (void)doTui:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSMutableDictionary *obj =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[[Singleton sharedInstance]mall]], @"mall",
                                                  [[Singleton sharedInstance]TGC], @"TGC",
                                                  [_data objectForKey:@"itemId"], @"itemId",
                                                  nil];
                       
                       NSString *reqdata=[[[SBJsonWriter alloc] init]stringWithObject:obj];
                       
                       
                       ASIFormDataRequest *request=[CommonMethods asiHttpRequestWithURL:loadCart_URL andData:reqdata andDelegate:nil];
                       
                       NSError *error = [request error];
                       if (error)
                       {
                           NSLog(@"Failed %@ with code %d and with userInfo %@",
                                 [error domain],
                                 [error code],
                                 [error userInfo]);
                           return;
                       }
                       
                       SBJsonParser *jsonParser=[[SBJsonParser alloc] init];
                       NSDictionary *root = [jsonParser objectWithString:[request responseString]];
                       if (root!=nil && [[root objectForKey:@"code"]intValue]==0)
                       {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              
                                          });
                       }
                   });
    
}

@end
