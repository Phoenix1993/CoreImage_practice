//
//  SYFilter.m
//  CoreImage
//
//  Created by 宋岩 on 15/7/15.
//  Copyright (c) 2015年 宋岩. All rights reserved.
//

#import "SYFilter.h"

@implementation SYFilter

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (UIImage *)getMosaicImage:(UIImage *)image{
    
    //1.创建出filter滤镜
    CIFilter *filterone = [CIFilter filterWithName:@"CIPixellate"];
    [filterone setValue:[[CIImage alloc] initWithImage:image] forKey:kCIInputImageKey];
    [filterone setDefaults];
    CIImage *outputImage1 = [filterone valueForKey:kCIOutputImageKey];
    
    CIFilter *filtertwo = [CIFilter filterWithName:@"CIHueAdjust"];
    [filtertwo setValue:outputImage1 forKey:kCIInputImageKey];
    [filtertwo setDefaults];
    CIImage *outputImage2 = [filterone valueForKey:kCIOutputImageKey];
    
    [filtertwo setValue:@(3.14) forKey:kCIInputAngleKey];
    
    //2.用CIContext将滤镜中的图片渲染出来
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage2 fromRect:[outputImage2 extent]];
    
    //3.导出图片
    UIImage *mosaicImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return mosaicImage;
}

@end
