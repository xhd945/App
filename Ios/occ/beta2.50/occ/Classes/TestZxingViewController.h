//
//  TestZxingViewController.h
//  occ
//
//  Created by RS on 13-8-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingWidgetController.h>
#import "CustomViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TestZxingViewController : UIViewController<ZXingDelegate, CustomViewControllerDelegate, DecoderDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;



@end
