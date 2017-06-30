//
//  QRCodeViewController.h
//  RMXJY
//
//  Created by MacBooK on 16/3/4.
//  Copyright © 2016年 MacBooK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>


@property (strong, nonatomic) UIView *boxView;
@property (strong, nonatomic) CALayer *scanLayer;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;


@end
