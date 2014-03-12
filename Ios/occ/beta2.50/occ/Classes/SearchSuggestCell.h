//
//  SearchSuggestCell.h
//  occ
//
//  Created by zhangss on 13-9-11.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSuggestCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_typeLabel;
}
@property (strong, nonatomic)  UIImageView *rightImageView;

- (void)setText:(NSString *)text andTypeString:(NSString *)typeStr;

@end
