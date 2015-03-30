//
//  FCCameraOverLayer.m
//  FACE-REC
//
//  Created by Suyuancheng on 15-3-26.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "FCCameraOverLayer.h"

@implementation FCCameraOverLayer
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw background        
    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    CGContextFillRect(context, [UIScreen mainScreen].bounds);
    
    // Cut hole
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextFillRect(context, CGRectMake(40, 40, 100, 100));

}
@end
