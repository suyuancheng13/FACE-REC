//
//  FCViewController.m
//  FACE-REC
//
//  Created by Suyuancheng on 15-3-26.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "FCViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageShow = [[UIImageView alloc]init];
    [_imageShow setFrame:CGRectMake(10, 6, 310, 388)];
    [_imageShow setBounds:CGRectMake(0, 0, 310, 388)];
    [self.view addSubview:_imageShow];
    //imageShow = [[UIImageView alloc]init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark- functions about capture detect and recongnize
- (IBAction)CaptureImage:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing= YES;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{}];
}

- (IBAction)recognizeFace:(id)sender {
}

- (IBAction)trainFace:(id)sender {
}
- (UIImage*)convert2gray:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;   
    int height = sourceImage.size.height;   
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();   
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);   
    CGColorSpaceRelease(colorSpace);   
    if (context == NULL) {   
        return nil;   
    }   
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);   
    UIImage *_grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];   
    CGContextRelease(context);   
    return _grayImage;  
}

/*
 *Use the core image to detect the face partition
 */
- (void)faceDetect:(UIImage *)image
{
    CIImage *_image = [CIImage imageWithCGImage:image.CGImage];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    NSArray *features = [detector featuresInImage:_image];
    if([features count]==0)
    {
        UIAlertView *alter =[[UIAlertView alloc]initWithTitle:@"REC ERROR" message:@"no Face Found " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }
    
    for(CIFaceFeature *faceObj in features)
    {

        /*
         *caution: the faceObj is in 笛卡尔 coordinate
         */
        CGRect modifiedFaceBounds = faceObj.bounds;
        modifiedFaceBounds.origin.y = image.size.height-faceObj.bounds.size.height-faceObj.bounds.origin.y;
        _cropedImage = CGImageCreateWithImageInRect([image CGImage], modifiedFaceBounds);
        _cropedUIImage = [UIImage imageWithCGImage:_cropedImage];
        CGImageRelease(_cropedImage);
        [self extractFeature];
        
        /*
         *caculate the scale to add red rectangle
         */
        float widthScale = _imageShow.frame.size.width/image.size.width;
        float heightScale = _imageShow.frame.size.height/image.size.height;
        modifiedFaceBounds.size.width *= widthScale;
        modifiedFaceBounds.size.height *= heightScale;
        modifiedFaceBounds.origin.x *= widthScale;
        modifiedFaceBounds.origin.y *= heightScale;
        [self addFaceFrame:modifiedFaceBounds];

//         [imageShow setImage:[UIImage imageWithCGImage:cropedImage]];

       
    }
   
}
- (void)addFaceFrame:(CGRect)rect
{

    for(UIView *sub in [_imageShow subviews])
    {
        [sub removeFromSuperview];
    }
    UIAlertView *alter =[[UIAlertView alloc]initWithTitle:@"Face Found!!" message:NSStringFromCGRect(rect) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alter show];
    UIView *subView = [[UIView alloc]initWithFrame:rect];
    subView.layer.borderWidth = 4;
    subView.layer.borderColor =[[UIColor redColor]CGColor ];
    
    [_imageShow addSubview:subView];
}

/*
 *The main process in FACE REC
 */
- (void)extractFeature
{
    /*
     *step 1: convert the image to gray image
     */
    _cropedUIImage =[self convert2gray:_cropedUIImage];
    /*
     *step 2: get texture features by LBP
     */
    _lbpHistogram = [_lbpEngine LBP:_cropedUIImage];
    
    
}
#pragma mark- UIImagePickerControllerDelegate
/*
 2.x
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo 
{
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypeCamera) 
    {  
        
        UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; 
        UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
        _captureImage = original_image;
        _captureImage = [_captureImage fixOrientation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imageShow setImage:nil];
            [_imageShow setImage:_captureImage];
        });
        [self faceDetect:_captureImage];
        

    }  

    [picker dismissModalViewControllerAnimated:YES]; 
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{[_imageShow setImage:[UIImage imageNamed:@"IMG_1328.JPG"]];});
     
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
 
    UIAlertView *alter =[[UIAlertView alloc]initWithTitle:@"Save ERROR" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alter show];

}


@end
