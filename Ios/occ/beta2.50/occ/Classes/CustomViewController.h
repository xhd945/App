//
//  CustomViewController.h
//  occ
//
//  Created by RS on 13-8-6.
//  Copyright (c) 2013年 RS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Decoder.h>
@class CustomViewController;

@protocol CustomViewControllerDelegate <NSObject>

@optional
- (void)customViewController:(CustomViewController *)controller didScanResult:(NSString *)result;
- (void)customViewControllerDidCancel:(CustomViewController *)controller;

@end

@interface CustomViewController : UIViewController <UIAlertViewDelegate, DecoderDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) id<CustomViewControllerDelegate> delegate;

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) BOOL isScanning;

@end
