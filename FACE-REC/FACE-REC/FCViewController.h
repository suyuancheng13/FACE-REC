//
//  FCViewController.h
//  FACE-REC
//
//  Created by Suyuancheng on 15-3-26.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+fixOrientation.h"
#import "FCLBPEngine.h"

@interface FCViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage * _captureImage;
    UIImageView *_imageShow;
    CGImageRef _cropedImage;
    UIImage *_cropedUIImage;
    
    FCLBPEngine *_lbpEngine;
    NSArray *_lbpHistogram 
}

- (IBAction)CaptureImage:(id)sender;
- (IBAction)recognizeFace:(id)sender;
- (IBAction)trainFace:(id)sender;

- (UIImage*)convert2gray:(UIImage*)image;
- (void)faceDetect:(UIImage *)image;
- (void)addFaceFrame:(CGRect)rect;
- (void)extractFeature;
@end
