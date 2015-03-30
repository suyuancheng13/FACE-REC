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
@interface FCViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage * grayImage;
    UIImageView *imageShow;
    CGImageRef cropedImage;
}

- (IBAction)CaptureImage:(id)sender;
- (UIImage*)convert2gray:(UIImage*)image;
- (void)faceDectect:(UIImage *)image;
- (void)addFaceFrame:(CGRect)rect;

@end
