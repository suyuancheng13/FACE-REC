//
//  FCLBPEngine.h
//  FACE-REC
//
//  Created by Suyuancheng on 15-3-30.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "opencv2/opencv.hpp"

@interface FCLBPEngine : NSObject
- (NSArray*)LBP:(UIImage*)image;
@end
