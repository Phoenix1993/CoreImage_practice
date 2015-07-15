//
//  ViewController.m
//  CoreImage
//
//  Created by 宋岩 on 15/7/15.
//  Copyright (c) 2015年 宋岩. All rights reserved.
//

#import "ViewController.h"
#import "SYFilter.h"
#import <GLKit/GLKit.h>

@interface ViewController ()
@property (nonatomic, strong) GLKView *glkView;// 渲染用的buffer视图
@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) CIImage *ciImage;
@property (nonatomic, strong) CIContext *ciContext;;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIImageView *image = [[UIImageView alloc] initWithImage:[SYFilter getMosaicImage:[UIImage imageNamed:@"5"]]];
//    image.frame = CGRectMake(0, 0, 200, 300);
//    image.center = self.view.center;
//    [self.view addSubview:image];
    
    
    UIImage *showImage = [UIImage imageNamed:@"5"];
    CGRect rect = CGRectMake(0, 0, 200, 400);
    
    //获取OpenGLES渲染的上下文
    EAGLContext *eagContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //创建出渲染的buffer
    _glkView = [[GLKView alloc] initWithFrame:rect context:eagContext];
    [_glkView bindDrawable];
    [self.view addSubview:_glkView];
    
    //创建出CoreImage用的上下文
    _ciContext = [CIContext contextWithEAGLContext:eagContext options:@{kCIContextWorkingColorSpace : [NSNull null]}];
    
    //CoreImage相关设置
    _ciImage = [[CIImage alloc] initWithImage:showImage];
    
    _filter = [CIFilter filterWithName:@"CISepiaTone"];
    
    [_filter setValue:_ciImage forKey:kCIInputImageKey];
    [_filter setValue:@(0) forKey:kCIInputIntensityKey];
    
    [_ciContext drawImage:[_filter outputImage] inRect:CGRectMake(0, 0, _glkView.drawableWidth, _glkView.drawableHeight) fromRect:[_ciImage extent]];
    
    [_glkView display];
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 400, 300, 20)];
    slider.minimumValue = 0.f;
    slider.maximumValue = 1.f;
    [slider addTarget:self action:@selector(sliderEvent:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
}

- (void)sliderEvent:(UISlider *)slider{
    [_filter setValue:_ciImage forKey:kCIInputImageKey];
    [_filter setValue:@(slider.value) forKey:kCIInputIntensityKey];
    
    [_ciContext drawImage:[_filter outputImage] inRect:CGRectMake(0, 0, _glkView.drawableWidth, _glkView.drawableHeight) fromRect:[_ciImage extent]];
    
    [_glkView display];
}





@end
